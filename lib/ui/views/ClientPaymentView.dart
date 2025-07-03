import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';
import 'package:kafen/ui/controller/client_payment_controller.dart';

class ClientPaymentsView extends StatelessWidget {
  const ClientPaymentsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ClientPaymentController con = Get.put(ClientPaymentController());

    return Container(
      color: const Color(0xFFFAF8F5), // Fondo cremita
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 700),
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(25, 0, 0, 0),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
          Obx(() => AspectRatio(
  aspectRatio: 16 / 9, // más rectangular, puedes probar también 14/9 o 12/7
  child: CreditCardWidget(
    cardNumber: con.cardNumber.value,
    expiryDate: con.expiryDate.value,
    cardHolderName: con.cardHolderName.value,
    cvvCode: con.cvvCode.value,
    showBackView: con.isCvvFocused.value,
    onCreditCardWidgetChange: (CreditCardBrand brand) {},
    cardBgColor:  Color.fromRGBO(213, 186, 152,35),
    isChipVisible: true,
    obscureCardNumber: true,
    obscureCardCvv: true,
  ),
)),
            const SizedBox(height: 20),
            CreditCardForm(
              formKey: con.keyForm,
              onCreditCardModelChange: con.onCreditCardModelChange,
              inputConfiguration: InputConfiguration(
                cardNumberDecoration:  _inputDecoration('Número de la tarjeta', 'XXXX XXXX XXXX XXXX',Icons.credit_card),
                expiryDateDecoration: _inputDecoration('Fecha de expiración', 'MM/YY',Icons.calendar_month),
                cvvCodeDecoration: _inputDecoration('CVV', 'XXX',Icons.security_outlined),
                cardHolderDecoration: _inputDecoration('Nombre del titular', '',Icons.person_4_outlined),
              ),
              cardNumber: '',
              expiryDate: '',
              cvvCode: '',
              cardHolderName: '',
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () {
                if (!con.isValidForm()) return;
                con.createCardToken();

                Get.snackbar(
                  'Procesando',
                  'La lógica de pago se implementará próximamente.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              child: const Text(
                'REALIZAR PAGO',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, String hint,IconData? icono) {
    return InputDecoration(
      filled: true,
      fillColor: const Color(0xFFF5F5F5),
      hintText: hint,
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black87),
      suffixIcon: Icon(icono as IconData?),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
        borderSide: const BorderSide(color: Colors.black, width: 1.2),
      ),
    );
  }
}
