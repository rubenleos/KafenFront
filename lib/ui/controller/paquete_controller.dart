// lib/ui/controller/paquete_controller.dart
// lib/ui/controller/paquete_controller.dart
import 'package:flutter/scheduler.dart';
import 'package:kafen/provider/paquete_provider.dart';


import 'package:get/get.dart';
import 'package:kafen/models/paquetes_model.dart';
 // Asegúrate que el nombre del provider sea el correcto

class PackagesController extends GetxController {
  final PackageProvider _packageProvider = PackageProvider();
  final RxList<PackageModel> packages = <PackageModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPackages();
  }

  Future<void> fetchPackages() async {
    try {
      isLoading.value = true;
      final List<PackageModel> result = await _packageProvider.getPackages();
      packages.assignAll(result);
    } catch (e) {
      print("PackagesController: Error al buscar paquetes - $e");
      
      // ===== INICIO DE LA CORRECCIÓN =====
      // Usamos addPostFrameCallback para asegurarnos de que la UI esté lista
      // antes de intentar mostrar un Snackbar.
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
          "Error",
          "No se pudieron cargar los paquetes.",
          snackPosition: SnackPosition.BOTTOM,
        );
      });
      // ===== FIN DE LA CORRECCIÓN =====

    } finally {
      isLoading.value = false;
    }
  }
}
