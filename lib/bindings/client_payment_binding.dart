import 'package:get/get.dart';
import 'package:kafen/ui/controller/client_payment_controller.dart';

// Esta clase le dice a GetX cómo crear el controlador para la ruta de pagos.
// Es la forma recomendada para evitar errores de "Controller not found".
class ClientPaymentBinding extends Bindings {
  @override
  void dependencies() {
    // Usa lazyPut para crear el controlador de forma segura solo cuando
    // se necesite por primera vez. Esto previene errores y optimiza la memoria.
    Get.lazyPut<ClientPaymentController>(() => ClientPaymentController());
  }
}

