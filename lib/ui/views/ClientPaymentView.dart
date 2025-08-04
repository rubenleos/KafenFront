
import 'package:flutter/material.dart';

import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:get/get.dart';
import 'package:kafen/ui/controller/client_payment_controller.dart';

class ClientPaymentsView extends StatelessWidget {
  const ClientPaymentsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Encuentra la instancia del controlador que fue creada por el Binding.
    // Esto es crucial para la estabilidad y para evitar errores.
    final ClientPaymentController con = Get.find<ClientPaymentController>();

    // Se elimina el Scaffold, ya que el MainLayout ya proporciona uno.
    // El widget raíz es un Container para centrar el contenido.
    return Container(
      alignment: Alignment.topCenter, // Alinea el formulario en la parte superior.
      child: SingleChildScrollView(
        // Permite el desplazamiento en pantallas pequeñas para evitar desbordamientos.
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: ConstrainedBox(
          // Limita el ancho del formulario para una mejor apariencia en web.
          constraints: const BoxConstraints(maxWidth: 550),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- WIDGET DE TARJETA DE CRÉDITO ---
              // Se actualiza dinámicamente con los datos del controlador.
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

              // --- FORMULARIO DE TARJETA DE CRÉDITO ---
              // Utiliza la GlobalKey del controlador para la validación.
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

              // Los campos de identificación han sido eliminados para México.
              const SizedBox(height: 32),

              // --- BOTÓN DE PAGO ---
              // Muestra un indicador de carga cuando se está procesando el pago.
              Obx(() => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: con.isLoading.value ? null : con.processPayment,
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
    );
  }
}
