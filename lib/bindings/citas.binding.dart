// lib/modules/citas/bindings/citas_binding.dart
import 'package:get/get.dart';
import 'package:kafen/ui/controller/client_payment_controller.dart';

class ClientPaymentBinding extends Bindings {
  @override
  void dependencies() {
    // Usa lazyPut para crear el controlador de forma segura solo cuando
    // se necesite por primera vez en la ruta.
    // Esto asegura que solo exista una instancia.
    Get.lazyPut<ClientPaymentController>(() => ClientPaymentController());
  }
}
