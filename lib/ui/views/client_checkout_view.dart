import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kafen/ui/controller/client_checkout_controller.dart';

class ClientCheckoutView extends StatelessWidget {
  const ClientCheckoutView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inyecta el controlador en la vista
    final ClientCheckoutController con = Get.put(ClientCheckoutController());

    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Obx(() {
          // Si no se ha cargado ningún paquete, muestra un indicador de carga.
          if (con.package.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          // Si hay un paquete, muestra el resumen de la compra.
          return Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Resumen de tu compra',
                    style: GoogleFonts.lora(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 25),
                  // Muestra el nombre del paquete
                  _buildDetailRow(
                    'Paquete:',
                    con.package.value!.nombrePaquete,
                  ),
                  const SizedBox(height: 10),
                  // Muestra la descripción o duración
                  _buildDetailRow(
                    'Duración:',
                    con.package.value!.duracion ?? 'Vencimiento de 30 días',
                  ),
                  const Divider(height: 40),
                  // Muestra el total a pagar
                  _buildTotalRow(
                    'Total a pagar:',
                    '\$${con.getTotalAPagar()}',
                  ),
                  const SizedBox(height: 35),
                  // Botón para proceder al pago
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        // --- CORRECCIÓN APLICADA AQUÍ ---
                        // Ahora pasamos el paquete como un argumento en la navegación.
                        // El controlador de la pantalla de pago podrá recibirlo.
                        Get.toNamed('/pagos', arguments: con.package.value);
                      },
                      child: Text(
                        'PROCEDER AL PAGO',
                        style: GoogleFonts.raleway(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.raleway(
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: GoogleFonts.raleway(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTotalRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.lora(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.lora(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: const Color(0xFFE0706B),
          ),
        ),
      ],
    );
  }
}
