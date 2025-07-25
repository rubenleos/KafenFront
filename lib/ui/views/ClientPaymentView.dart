import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';
import 'package:kafen/ui/controller/client_payment_controller.dart';

class ClientPaymentsView extends StatelessWidget {
  const ClientPaymentsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // --- CORRECCIÓN DEFINITIVA ---
    // Usamos Get.find() para localizar el controlador que el Binding ya creó.
    // Esto evita la creación de duplicados y estabiliza el GlobalKey.
    final ClientPaymentController con = Get.find<ClientPaymentController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Realizar Pago'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 550),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Obx(() => CreditCardWidget(
                      cardNumber: con.cardNumber.value,
                      expiryDate: con.expiryDate.value,
                      cardHolderName: con.cardHolderName.value,
                      cvvCode: con.cvvCode.value,
                      showBackView: con.isCvvFocused.value,
                      onCreditCardWidgetChange: (brand) {},
                      cardBgColor: const Color(0xFF2C3E50),
                      isChipVisible: true,
                      cardType: CardType.otherBrand,
                      customCardTypeIcons: [
                        if (con.paymentMethod.value?.secureThumbnail != null)
                          CustomCardTypeIcon(
                            cardType: CardType.otherBrand,
                            cardImage: Image.network(
                              con.paymentMethod.value!.secureThumbnail!,
                              height: 40,
                              width: 55,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.credit_card,
                                      color: Colors.white),
                            ),
                          ),
                      ],
                    )),
                CreditCardForm(
                  formKey: con.keyForm,
                  onCreditCardModelChange: con.onCreditCardModelChange,
                  inputConfiguration: const InputConfiguration(
                    cardNumberDecoration: InputDecoration(
                        labelText: 'Número de la tarjeta',
                        hintText: 'XXXX XXXX XXXX XXXX'),
                    expiryDateDecoration: InputDecoration(
                        labelText: 'Fecha de expiración', hintText: 'MM/YY'),
                    cvvCodeDecoration:
                        InputDecoration(labelText: 'CVV', hintText: 'XXX'),
                    cardHolderDecoration:
                        InputDecoration(labelText: 'Nombre del titular'),
                  ),
                  cardNumber: con.cardNumber.value,
                  expiryDate: con.expiryDate.value,
                  cvvCode: con.cvvCode.value,
                  cardHolderName: con.cardHolderName.value,
                ),
                const SizedBox(height: 24),
                _buildIdentificationFields(con),
                const SizedBox(height: 32),
                Obx(() => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed:
                          con.isLoading.value ? null : con.processPayment,
                      child: con.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              'PAGAR \$${con.package.value?.precio ?? '0.00'}'),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIdentificationFields(ClientPaymentController con) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Datos de Identificación del Titular",
          style:
              Get.theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: con.identificationTypeController,
          decoration: const InputDecoration(
            labelText: 'Tipo de documento',
            hintText: 'Ej: CI, DNI, Pasaporte',
            border: OutlineInputBorder(),
          ),
          validator: (value) =>
              (value == null || value.isEmpty) ? 'Este campo es requerido' : null,
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: con.identificationNumberController,
          decoration: const InputDecoration(
            labelText: 'Número de documento',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) =>
              (value == null || value.isEmpty) ? 'Este campo es requerido' : null,
        ),
      ],
    );
  }
}
