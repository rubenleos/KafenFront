import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:kafen/models/mercado_pago/mercado_pago_card_holder.dart';
import 'package:kafen/models/mercado_pago/mercado_pago_card_token.dart';
import 'package:kafen/models/mercado_pago/mercado_pago_document_type.dart';
import 'package:kafen/provider/mercado_pago_provider.dart';

class ClientPaymentController extends GetxController {
  // 1. Hacemos las variables "reactivas" con .obs
  RxString cardNumber = ''.obs;
  RxString expiryDate = ''.obs;
  RxString cardHolderName = ''.obs;
  RxString cvvCode = ''.obs;
  RxBool isCvvFocused = false.obs;

  GlobalKey<FormState> keyForm = GlobalKey();

  MercadoPagoProvider mercadoPagoProvider = MercadoPagoProvider();
  List<MercadoPagoDocumentType> document =  <MercadoPagoDocumentType>[].obs;


bool isValidForm(){
  if(cardNumber.value.isEmpty){
Get.snackbar('Formulario no valido', 'no valido');
return false;}
  if(cardHolderName.value.isEmpty){
Get.snackbar('Formulario no valido', 'ingresa el nombre del titular');
return false;}
  if(expiryDate.value.isEmpty){
Get.snackbar('Formulario no valido', 'Ingresa la fecha de vencimiento');
return false;}
  if(cvvCode.value.isEmpty){
Get.snackbar('Formulario no valido', 'Ingresa CVV');
return false;}
return true ;
 }

  // 2. Creamos una función para actualizar los datos desde el formulario
  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    cardNumber.value = creditCardModel.cardNumber;
    expiryDate.value = creditCardModel.expiryDate;
    cardHolderName.value = creditCardModel.cardHolderName;
    cvvCode.value = creditCardModel.cvvCode;
    isCvvFocused.value = creditCardModel.isCvvFocused;
  }

  void createCardToken() async {
  cardNumber.value = cardNumber.value.replaceAll(' ', '');
   print(expiryDate.value.split('/')[1]);
   print(expiryDate.value.split('/')[0]);



  MercadoPagoCardToken? cardToken = await mercadoPagoProvider.createCardToken(
    cardNumber: cardNumber.value,
   expirationYear: '20${expiryDate.value.split('/')[1]}',
    expirationMonth: int.parse(expiryDate.value.split('/')[0]),
    cardHolderName: cardHolderName.value,
    cvv: cvvCode.value,


  );

print(cardToken?.toJson());
  
  }

}