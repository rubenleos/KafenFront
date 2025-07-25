import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kafen/models/mercado_pago/mercado_pago_card_token.dart';
import 'package:kafen/models/mercado_pago/mercado_pago_installment.dart';
import 'package:kafen/models/mercado_pago/mercado_pago_payment_method.dart';
import 'package:kafen/models/mercado_pago/mercado_pago_payment_method_installments.dart';
import 'package:kafen/models/mercado_pago/order.dart';
import 'package:kafen/models/paquetes_model.dart';
import 'package:kafen/models/user.dart';
import 'package:kafen/provider/mercado_pago_provider.dart';

class ClientPaymentController extends GetxController {
  // --- ESTADO DEL FORMULARIO Y LA UI ---
  // Esta clave ahora solo pertenece al CreditCardForm.
  GlobalKey<FormState> keyForm = GlobalKey();
  RxBool isLoading = false.obs;
  Timer? _debounce;

  // ... (el resto de las variables reactivas no cambian) ...
  RxString cardNumber = ''.obs;
  RxString expiryDate = ''.obs;
  RxString cardHolderName = ''.obs;
  RxString cvvCode = ''.obs;
  RxBool isCvvFocused = false.obs;
  RxString paymentMethodId = ''.obs;
  RxString issuerId = ''.obs;
  Rx<MercadoPagoPaymentMethod?> paymentMethod = Rx(null);
  RxList<MercadoPagoInstallment> payerCosts = <MercadoPagoInstallment>[].obs;
  RxInt selectedInstallment = 1.obs;


  // --- CONTROLADORES DE TEXTO ---
  TextEditingController identificationTypeController = TextEditingController();
  TextEditingController identificationNumberController = TextEditingController();

  // --- DATOS DE LA COMPRA Y PROVEEDOR ---
  final Rx<PackageModel?> package = Rx<PackageModel?>(null);
  MercadoPagoProvider mercadoPagoProvider = MercadoPagoProvider();

  // ... (onInit, onClose, onCreditCardModelChange, etc. no cambian) ...
  @override
  void onInit() {
    super.onInit();
    if (Get.arguments is PackageModel) {
      package.value = Get.arguments;
    } else {
      Get.snackbar('Error', 'No se ha seleccionado un paquete para el pago.');
      Get.back();
    }

    ever(cardNumber, (String newCardNumber) {
      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        if (newCardNumber.length >= 6) {
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

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    cardNumber.value = creditCardModel.cardNumber;
    expiryDate.value = creditCardModel.expiryDate;
    cardHolderName.value = creditCardModel.cardHolderName;
    cvvCode.value = creditCardModel.cvvCode;
    isCvvFocused.value = creditCardModel.isCvvFocused;
  }

  void clearCardInfo() {
    paymentMethodId.value = '';
    issuerId.value = '';
    paymentMethod.value = null;
    payerCosts.clear();
  }

  Future<void> fetchCardInfo() async {
    String bin = cardNumber.value.replaceAll(' ', '').substring(0, 6);
    List<MercadoPagoPaymentMethod> paymentMethods = await mercadoPagoProvider.getPaymentMethods(bin);
    if (paymentMethods.isNotEmpty) {
      paymentMethod.value = paymentMethods[0];
      paymentMethodId.value = paymentMethods[0].id ?? '';
      if (package.value != null) {
        double amount = double.tryParse(package.value!.precio) ?? 0.0;
        await getInstallmentsInfo(bin, amount);
      }
    }
  }

  Future<void> getInstallmentsInfo(String bin, double amount) async {
    List<MercadoPagoPaymentMethodInstallments> installmentsList = await mercadoPagoProvider.getInstallments(bin, amount);
    if (installmentsList.isNotEmpty) {
      issuerId.value = installmentsList[0].issuer?.id ?? '';
      payerCosts.value = installmentsList[0].payerCosts ?? [];
      if (payerCosts.isNotEmpty) {
        selectedInstallment.value = payerCosts[0].installments ?? 1;
      }
    }
  }


  /// Orquesta todo el proceso de pago final.
  void processPayment() async {
    // --- CORRECCIÓN: Lógica de validación actualizada ---
    // 1. Valida el formulario de la tarjeta de crédito usando su clave.
    bool isCardFormValid = keyForm.currentState?.validate() ?? false;

    // 2. Valida manualmente los campos de identificación.
    bool isIdentificationValid =
        identificationTypeController.text.isNotEmpty &&
        identificationNumberController.text.isNotEmpty;

    if (!isCardFormValid || !isIdentificationValid) {
      Get.snackbar('Campos Incompletos',
          'Por favor, completa todos los datos de la tarjeta y de identificación.');
      return;
    }
    
    if (paymentMethodId.isEmpty || issuerId.isEmpty) {
      Get.snackbar('Validando Tarjeta', 'Por favor, espera un momento mientras validamos los datos de tu tarjeta.');
      return;
    }
    if (package.value == null) return;

    isLoading.value = true;

    MercadoPagoCardToken? cardToken = await _createCardToken();
    if (cardToken == null) {
      isLoading.value = false;
      return;
    }

    User user = User.fromJson(GetStorage().read('user') ?? {});
    Order order = Order(id: package.value!.paqueteId.toString(), total: double.parse(package.value!.precio));

    Response? response = await mercadoPagoProvider.createPayment(
      token: cardToken.id!,
      paymentMethodId: paymentMethodId.value,
      issuerId: issuerId.value,
      paymentTypeId: paymentMethod.value?.paymentTypeId ?? 'credit_card',
      emailCustomer: user.correoElectronico,
      identificationType: identificationTypeController.text,
      identificationNumber: identificationNumberController.text,
      transactionAmount: order.total,
      installments: selectedInstallment.value,
      order: order,
    );

    isLoading.value = false;

    if (response != null && (response.statusCode == 201 || response.statusCode == 200)) {
      Get.snackbar('Pago Exitoso', 'Tu compra ha sido realizada con éxito.', backgroundColor: Colors.green, colorText: Colors.white);
      Get.offAllNamed('/citas');
    } else {
      String errorMessage = response?.body?['message'] ?? 'Ocurrió un error desconocido. Intenta de nuevo.';
      Get.snackbar('Pago Rechazado', 'No se pudo procesar tu pago: $errorMessage', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<MercadoPagoCardToken?> _createCardToken() async {
    try {
      String year = expiryDate.value.split('/')[1];
      String expirationYear = '20$year';
      int expirationMonth = int.parse(expiryDate.value.split('/')[0]);

      return await mercadoPagoProvider.createCardToken(
        cardNumber: cardNumber.value.replaceAll(' ', ''),
        expirationYear: expirationYear,
        expirationMonth: expirationMonth,
        cardHolderName: cardHolderName.value,
        cvv: cvvCode.value,
        identificationType: identificationTypeController.text,
        identificationNumber: identificationNumberController.text,
      );
    } catch (e) {
      Get.snackbar('Error de Datos', 'Verifica que todos los campos de la tarjeta sean correctos.');
      return null;
    }
  }
}
