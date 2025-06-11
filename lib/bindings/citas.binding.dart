// lib/modules/citas/bindings/citas_binding.dart
import 'package:get/get.dart';
import 'package:kafen/ui/controller/citas_controlador.dart';
// Asegúrate que la ruta al controlador sea la correcta


class CitasBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CitasController>(
      () => CitasController(),
    );
  }
}
