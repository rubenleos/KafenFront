import 'package:get/get.dart';
import 'package:kafen/ui/controller/citas_controlador.dart';

// --- CORRECCIÓN APLICADA ---
// Se ha renombrado la clase a "CitasBinding" para que sea única
// y coincida con el propósito del archivo. Esto elimina el error de ambigüedad.
class CitasBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CitasController>(() => CitasController());
  }
}
