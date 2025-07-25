// lib/ui/controller/client_checkout_controller.dart
import 'package:get/get.dart';
import 'package:kafen/models/paquetes_model.dart';

class ClientCheckoutController extends GetxController {
  // Variable reactiva para almacenar el paquete seleccionado
  final Rx<PackageModel?> package = Rx<PackageModel?>(null);

  @override
  void onInit() {
    super.onInit();
    // Al iniciar el controlador, captura el paquete que se pasó como argumento
    // desde la vista de paquetes.
    if (Get.arguments is PackageModel) {
      package.value = Get.arguments as PackageModel;
    }
  }

  // Método para calcular el total a pagar.
  // Por ahora solo devuelve el precio, pero podría incluir impuestos u otros cargos.
  String getTotalAPagar() {
    if (package.value == null) {
      return '0.00';
    }
    return package.value!.precio;
  }
}