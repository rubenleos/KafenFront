// lib/controllers/login_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// Asegúrate que ResponseApi y UsersProvider están correctamente importados
import 'package:kafen/models/response_api.dart'; // Ajusta la ruta si es necesario
import 'package:kafen/provider/userProvider.dart'; // Ajusta la ruta si es necesario

class LoginController extends GetxController {
  // Controladores para los campos de texto
  // La UI puede enlazar directamente a estos o pasar los valores.
  // Es común tenerlos aquí para centralizar la lógica.
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Proveedor de usuarios
  final UsersProvider usersProvider = UsersProvider();

  // Variables reactivas para el estado de la UI
  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    // Importante limpiar los controladores cuando el controlador se destruye
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Método para realizar el login
  // Devuelve true si el login fue exitoso, false en caso contrario.
  Future<bool> performRealLogin() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // Validación básica (puedes hacerla más robusta o delegarla a la UI con FormKey)
    if (email.isEmpty || !GetUtils.isEmail(email)) {
      Get.snackbar(
        'Entrada Inválida',
        'Por favor, ingresa un correo electrónico válido.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }
    if (password.isEmpty) {
      Get.snackbar(
        'Entrada Inválida',
        'Por favor, ingresa tu contraseña.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }
    // Aquí puedes añadir la validación de la longitud de la contraseña si la API la requiere antes de enviar.
    // Por ejemplo, si la contraseña que la API espera es 'contrasena' y debe tener 8 caracteres:
    // if (password.length < 8) {
    //   Get.snackbar(
    //     'Entrada Inválida',
    //     'La contraseña debe tener al menos 8 caracteres.',
    //     snackPosition: SnackPosition.BOTTOM,
    //     backgroundColor: Colors.orange,
    //     colorText: Colors.white,
    //   );
    //   return false;
    // }


    isLoading.value = true; // Inicia el indicador de carga

    try {
      // Llama a tu proveedor para hacer la petición de login
      // Asegúrate que tu UsersProvider.login() espera el email y la contraseña
      // que el API necesita (ej. "correo_electronico" y "contrasena").
      // Si tu UsersProvider ya maneja los nombres de campo correctos para la API,
      // entonces solo necesitas pasar 'email' y 'password'.
      // Si no, necesitarías un modelo o un Map aquí:
      // Map<String, String> loginData = {
      //   "correo_electronico": email, // Nombre de campo que espera tu API
      //   "password": password       // Nombre de campo que espera tu API (o 'contrasena')
      // };
      // ResponseApi responseApi = await usersProvider.login(loginData);

      ResponseApi responseApi = await usersProvider.login(email, password); // Ajusta según tu UsersProvider

      print('LoginController - Response api: ${responseApi.toJson()}');

      if (responseApi.success == true) {
        // Verifica que 'data' no sea null y contenga la información esperada (ej. token, datos del usuario)
        if (responseApi.data != null /* && responseApi.data.containsKey('token') */) {
           print('response api data: ${responseApi.data}');
          GetStorage().write('user', responseApi.data);
           // Guarda los datos del usuario o el token
          GetStorage().write('loginTimestamp', DateTime.now().toIso8601String());

          Get.snackbar(
            '¡Éxito!',
            responseApi.message ?? 'Inicio de sesión exitoso.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
           Get.toNamed('/citas');

          isLoading.value = false; // Detiene el indicador de carga
          return true; // Login exitoso
        } else {
          Get.snackbar(
            'Error de Servidor',
            responseApi.message ?? 'La respuesta del servidor no contiene datos de usuario válidos.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error de Inicio de Sesión',
          responseApi.message ?? 'Correo electrónico o contraseña incorrectos.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error de Conexión',
        'Ocurrió un problema al intentar iniciar sesión: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      print('LoginController - Error en login: $e');
    }

    isLoading.value = false; // Detiene el indicador de carga en caso de error
    return false; // Login fallido
  }
}