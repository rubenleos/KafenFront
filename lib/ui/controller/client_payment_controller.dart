import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get_storage/get_storage.dart';

// Importa tus modelos y providers
import 'package:kafen/models/mercado_pago/mercado_pago_card_token.dart';
import 'package:kafen/models/mercado_pago/mercado_pago_installment.dart';
import 'package:kafen/models/mercado_pago/mercado_pago_payment_method.dart';
import 'package:kafen/models/mercado_pago/mercado_pago_payment_method_installments.dart';
import 'package:kafen/models/paquetes_model.dart'; // Asegúrate que este sea el nombre correcto de tu modelo de paquete
import 'package:kafen/models/user.dart';
import 'package:kafen/provider/mercado_pago_provider.dart';

class ClientPaymentController extends GetxController {
  // --- STATE MANAGEMENT ---
  // Clave para validar el formulario de la tarjeta
  GlobalKey<FormState> keyForm = GlobalKey();

  // Variables reactivas para la UI
  RxBool isLoading = false.obs;
  Timer? _debounce;

  // Datos del formulario de la tarjeta de crédito
  RxString cardNumber = ''.obs;
  RxString expiryDate = ''.obs;
  RxString cardHolderName = ''.obs;
  RxString cvvCode = ''.obs;
  RxBool isCvvFocused = false.obs;

  // Datos obtenidos de la API de Mercado Pago
  RxString paymentMethodId = ''.obs;
  RxString issuerId = ''.obs;
  Rx<MercadoPagoPaymentMethod?> paymentMethod = Rx(null);
  RxList<MercadoPagoInstallment> payerCosts = <MercadoPagoInstallment>[].obs;
  RxInt selectedInstallment = 1.obs;

  // Datos del paquete a pagar
  final Rx<PackageModel?> package = Rx<PackageModel?>(null);

  // Provider para comunicarse con las APIs
  MercadoPagoProvider mercadoPagoProvider = MercadoPagoProvider();

  @override
  void onInit() {
    super.onInit();
    // Obtiene el paquete pasado como argumento desde la vista anterior
    if (Get.arguments is PackageModel) {
      package.value = Get.arguments;
    } else {
      // Si no hay paquete, muestra un error y regresa
      Get.snackbar('Error', 'No se ha seleccionado un paquete para el pago.');
      if (Get.isSnackbarOpen) {
        Get.back();
      }
    }

    // Escucha los cambios en el número de tarjeta para obtener la información de la misma
    ever(cardNumber, (String newCardNumber) {
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 800), () {
        if (newCardNumber.replaceAll(' ', '').length >= 6) {
          fetchCardInfo();
        } else {
          clearCardInfo();
        }
      });
    });
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }

  /// Actualiza las variables del controlador cuando el usuario escribe en el formulario.
  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    cardNumber.value = creditCardModel.cardNumber;
    expiryDate.value = creditCardModel.expiryDate;
    cardHolderName.value = creditCardModel.cardHolderName;
    cvvCode.value = creditCardModel.cvvCode;
    isCvvFocused.value = creditCardModel.isCvvFocused;
  }

  /// Limpia la información de la tarjeta si el número es inválido.
  void clearCardInfo() {
    paymentMethodId.value = '';
    issuerId.value = '';
    paymentMethod.value = null;
    payerCosts.clear();
  }

  /// Obtiene el tipo de tarjeta y las cuotas disponibles desde Mercado Pago.
  Future<void> fetchCardInfo() async {
    String cleanCardNumber = cardNumber.value.replaceAll(' ', '');
    if (cleanCardNumber.length < 6) return;

    String bin = cleanCardNumber.substring(0, 6);
    List<MercadoPagoPaymentMethod> paymentMethods =
        await mercadoPagoProvider.getPaymentMethods(bin);

    if (paymentMethods.isNotEmpty) {
      paymentMethod.value = paymentMethods[0];
      paymentMethodId.value = paymentMethods[0].id ?? '';

      if (package.value != null) {
        // --- CORRECCIÓN APLICADA ---
        // Convierte el precio a double de forma segura para evitar FormatException.
        // --- CORRECCIÓN APLICADA ---
        // Se maneja el caso de que el precio sea nulo, asignando un string vacío por defecto.
        String priceString = (package.value!.precio ?? '')
            .replaceAll(RegExp(r'[^\d.,]'), '') // Quita todo excepto números, puntos y comas
            .replaceAll(',', '.'); // Reemplaza la coma por un punto

        double amount = double.tryParse(priceString) ?? 0.0;
        
        if (amount > 0) {
          try {
            await getInstallmentsInfo(bin, amount);
          } catch (e) {
            print('Error getting installments: $e');
            // Opcionalmente, puedes mostrar un mensaje de error al usuario aquí.
          }
        }
      }
    }
  }

  /// Obtiene las cuotas (installments) para un monto y tarjeta específicos.
  Future<void> getInstallmentsInfo(String bin, double amount) async {
    try {
      List<MercadoPagoPaymentMethodInstallments> installmentsList =
          await mercadoPagoProvider.getInstallments(bin, amount);

      if (installmentsList.isNotEmpty) {
        issuerId.value = installmentsList[0].issuer?.id ?? '';
        payerCosts.value = installmentsList[0].payerCosts ?? [];
        if (payerCosts.isNotEmpty) {
          selectedInstallment.value = payerCosts[0].installments ?? 1;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error al obtener las cuotas: $e');
      }
      Get.snackbar('Error de Conexión', 'No se pudieron obtener las opciones de cuotas.');
    }
  }

  /// Procesa el pago completo.
  void processPayment() async {
    if (!(keyForm.currentState?.validate() ?? false)) {
      Get.snackbar('Datos Inválidos', 'Por favor, completa todos los datos de la tarjeta.');
      return;
    }

    if (paymentMethodId.isEmpty || issuerId.isEmpty) {
      Get.snackbar('Validando Tarjeta', 'Espera un momento mientras validamos los datos de tu tarjeta.');
      return;
    }
    if (package.value == null) return;

    isLoading.value = true;

    // 1. Crear el token de la tarjeta
    MercadoPagoCardToken? cardToken = await _createCardToken();
    if (cardToken == null) {
      isLoading.value = false;
      return;
    }

    // 2. Obtener datos del usuario y del paquete
    User user = User.fromJson(GetStorage().read('user') ?? {});
    if (user.usuarioId == null) {
      Get.snackbar('Error de Autenticación', 'No se pudo identificar al usuario.');
      isLoading.value = false;
      return;
    }
    
    // Convierte el precio de nuevo para asegurar consistencia
    String priceString = package.value!.precio.replaceAll(RegExp(r'[^\d.,]'), '').replaceAll(',', '.');
    double totalAmount = double.tryParse(priceString) ?? 0.0;
    
    String description = 'Compra del paquete: ${package.value?.nombrePaquete ?? 'Desconocido'}';

    // 3. Enviar el pago al backend
    Response? response = await mercadoPagoProvider.createPayment(
      token: cardToken.id!,
      paymentMethodId: paymentMethodId.value,
      issuerId: issuerId.value,
      transactionAmount: totalAmount,
      installments: selectedInstallment.value,
      description: description,
      user: user,
    );

    isLoading.value = false;

    // 4. Manejar la respuesta del backend
    if (response != null && response.statusCode == 200) {
      Get.snackbar(
        'Pago Exitoso',
        response.body['message'] ?? 'Tu compra ha sido realizada con éxito.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.offAllNamed('/citas'); // O a la ruta que corresponda
    } else {
      String errorMessage = "Ocurrió un error desconocido.";
      if (response?.body != null && response?.body['detail'] is Map) {
        errorMessage = response?.body['detail']['message'] ?? 'No se pudo procesar tu pago.';
      } else if (response?.body != null && response?.body['detail'] is String) {
        errorMessage = response?.body['detail'];
      }
      
      Get.snackbar(
        'Pago Rechazado',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    }
  }

  /// Crea un token de un solo uso para la tarjeta de forma segura.
  Future<MercadoPagoCardToken?> _createCardToken() async {
    if (expiryDate.value.isEmpty || !expiryDate.value.contains('/')) {
      Get.snackbar('Error de Datos', 'La fecha de expiración no es válida.');
      return null;
    }

    try {
      List<String> dateParts = expiryDate.value.split('/');
      int expirationMonth = int.parse(dateParts[0]);
      String expirationYear = '20${dateParts[1]}';

      return await mercadoPagoProvider.createCardToken(
        cardNumber: cardNumber.value.replaceAll(' ', ''),
        expirationYear: expirationYear,
        expirationMonth: expirationMonth,
        cardHolderName: cardHolderName.value,
        cvv: cvvCode.value,
        // Estos campos no son necesarios para México, se envían vacíos.
        identificationType: '',
        identificationNumber: '',
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error al crear token de tarjeta: $e');
      }
      Get.snackbar('Error de Datos', 'Verifica que todos los campos de la tarjeta sean correctos.');
      return null;
    }
  }
}
