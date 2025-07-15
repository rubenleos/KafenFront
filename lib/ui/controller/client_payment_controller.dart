import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:kafen/models/mercado_pago/mercado_pago_card_token.dart';
import 'package:kafen/provider/mercado_pago_provider.dart';
// Asumo que tienes un modelo para la orden, si no, puedes adaptarlo.


class ClientPaymentController extends GetxController {
  // --- ESTADO DEL FORMULARIO DE LA TARJETA ---
  RxString cardNumber = ''.obs;
  RxString expiryDate = ''.obs;
  RxString cardHolderName = ''.obs;
  RxString cvvCode = ''.obs;
  RxBool isCvvFocused = false.obs;
  GlobalKey<FormState> keyForm = GlobalKey();

  // --- CONTROLADORES PARA DATOS DE IDENTIFICACIÓN ---
  // Debes conectar estos controllers a TextFields en tu vista.
  TextEditingController identificationTypeController = TextEditingController();
  TextEditingController identificationNumberController = TextEditingController();

  // --- ESTADO DE LA OPERACIÓN ---
  RxBool isLoading = false.obs;

  // --- DEPENDENCIAS ---
  MercadoPagoProvider mercadoPagoProvider = MercadoPagoProvider();

  /// Se ejecuta cuando el modelo de la tarjeta de crédito cambia en el formulario.
  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    cardNumber.value = creditCardModel.cardNumber;
    expiryDate.value = creditCardModel.expiryDate;
    cardHolderName.value = creditCardModel.cardHolderName;
    cvvCode.value = creditCardModel.cvvCode;
    isCvvFocused.value = creditCardModel.isCvvFocused;
  }

  /// Valida todos los campos del formulario de pago.
  bool isValidForm() {
    if (cardNumber.value.isEmpty) {
      Get.snackbar('Formulario no válido', 'Ingresa el número de la tarjeta');
      return false;
    }
    if (expiryDate.value.isEmpty) {
      Get.snackbar('Formulario no válido', 'Ingresa la fecha de vencimiento');
      return false;
    }
    if (cardHolderName.value.isEmpty) {
      Get.snackbar('Formulario no válido', 'Ingresa el nombre del titular');
      return false;
    }
    if (cvvCode.value.isEmpty) {
      Get.snackbar('Formulario no válido', 'Ingresa el código CVV');
      return false;
    }
    if (identificationTypeController.text.isEmpty) {
      Get.snackbar('Formulario no válido', 'Ingresa tu tipo de documento');
      return false;
    }
    if (identificationNumberController.text.isEmpty) {
      Get.snackbar('Formulario no válido', 'Ingresa tu número de documento');
      return false;
    }
    return true;
  }

  /// Orquesta todo el proceso de pago.
  void processPayment() async {
    if (!isValidForm()) {
      return; // Si el formulario no es válido, no continuamos.
    }

    isLoading.value = true; // Mostramos el indicador de carga

    // 1. CREAR EL TOKEN DE LA TARJETA
    MercadoPagoCardToken? cardToken = await mercadoPagoProvider.createCardToken(
      cardNumber: cardNumber.value,
      expirationYear: '20${expiryDate.value.split('/')[1]}',
      expirationMonth: int.parse(expiryDate.value.split('/')[0]),
      cardHolderName: cardHolderName.value,
      cvv: cvvCode.value,
      // La API de Mercado Pago requiere estos datos para la tokenización
      identificationType: identificationTypeController.text,
      identificationNumber: identificationNumberController.text,
    );

    if (cardToken == null) {
      // Si el token no se pudo crear, mostramos un error y detenemos el proceso.
      Get.snackbar('Error con la tarjeta', 'No se pudo validar la tarjeta. Revisa los datos.');
      isLoading.value = false;
      return;
    }

    // --- DATOS DE EJEMPLO PARA EL PAGO ---
    // Estos datos deberían venir de tu lógica de negocio (carrito de compras, usuario logueado, etc.)
[=ht[q4tp6ablspe[],''=4rgr=[]]]
    
    // 2. ENVIAR EL PAGO AL BACKEND
    Response? response = await mercadoPagoProvider.createPayment(
      token: cardToken.id,
      paymentMethodId: "visa", // Este dato puede venir de un endpoint de MP o ser fijo si solo aceptas una marca
      paymentTypeId: 'credit_card',
      issuerId: "310", // ID del banco emisor, también se puede obtener de un endpoint de MP
      emailCustomer: userEmail,
      identificationType: identificationTypeController.text,
      identificationNumber: identificationNumberController.text,
      transactionAmount: exampleOrder.total,
      installments: 1, // Número de cuotas
      order: exampleOrder,
    );

    isLoading.value = false; // Ocultamos el indicador de carga

    // 3. MANEJAR LA RESPUESTA DEL BACKEND
    if (response != null && response.statusCode == 201) { // 201 Created o 200 OK según tu backend
      Get.snackbar('Pago Exitoso', 'Tu compra ha sido realizada con éxito.');
      // Aquí puedes navegar a una pantalla de confirmación de orden.
      // Get.toNamed('/order/confirmation');
    } else {
      // Si el backend devuelve un error
      String errorMessage = response?.body['message'] ?? 'Ocurrió un error desconocido.';
      Get.snackbar('Pago Rechazado', 'No se pudo procesar tu pago: $errorMessage');
    }
  }
}
