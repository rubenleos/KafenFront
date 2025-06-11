// lib/controllers/registration_controller.dart (o la ruta que prefieres para tus controladores)

import 'package:flutter/material.dart'; // Para BuildContext
import 'package:get/get.dart';
import 'package:http/http.dart' as http; // Para el tipo http.Response
import 'package:kafen/provider/authprovider.dart';
import 'dart:convert'; // Para json.decode

// Asume que tu AuthProvider (GetConnect) está en esta ruta
// y tu modelo User también. Ajusta las rutas si es necesario.

class RegistrationController extends GetxController {
  // Instancia de tu AuthProvider (el que extiende GetConnect)
  // Se asume que AuthProvider está registrado con Get.put()
  final AuthProvider _authProvider = Get.find<AuthProvider>();

  // Estado de carga para la UI
  var isLoading = false.obs;

  // Método para manejar el proceso de registro
  Future<void> registerUser({
    required String name,
    required String email,
    required String phone,
    required String password,
    required BuildContext context, // Para mostrar SnackBars desde la UI si es necesario
  }) async {
    isLoading.value = true; // Inicia la carga

    try {
      // Llama al método registerUser de tu AuthProvider (GetConnect)
      http.Response response = await _authProvider.registerUser(
        name : name,
        email: email,
        phone: phone,
        password: password,
         // El AuthProvider ya maneja un Snackbar en caso de error de conexión
      );

      isLoading.value = false; // Finaliza la carga

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Registro exitoso
        final responseBody = json.decode(response.body);
        print('RegistrationController: Registro exitoso - ${response.body}');

        Get.snackbar(
          'Registro Exitoso',
          responseBody['message'] ?? 'Tu cuenta ha sido creada.', // Usa el mensaje de la API si existe
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Navegar a la pantalla de login o a donde corresponda
        Get.offNamed('/login'); // Ajusta la ruta según tu app
      } else {
        // Error en el registro (la API respondió con un error)
        final responseBody = json.decode(response.body);
        String errorMessage = 'Error desconocido en el registro.';
        if (responseBody != null && responseBody['message'] != null) {
          errorMessage = responseBody['message'];
        } else if (responseBody != null && responseBody['errors'] is List && responseBody['errors'].isNotEmpty) {
          errorMessage = responseBody['errors'].join(', '); // Si hay una lista de errores
        }
        print('RegistrationController: Error en registro - Código: ${response.statusCode}, Cuerpo: ${response.body}');
        Get.snackbar(
          'Error de Registro',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // Este catch es por si el _authProvider.registerUser lanza una excepción
      // que no fue un http.Response (aunque tu AuthProvider actual devuelve un Response en el catch)
      // o por si hay algún otro error inesperado en este controlador.
      isLoading.value = false;
      print('RegistrationController: Excepción - $e');
      Get.snackbar(
        'Error Inesperado',
        'Ocurrió un error durante el registro. Por favor, inténtalo de nuevo.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
