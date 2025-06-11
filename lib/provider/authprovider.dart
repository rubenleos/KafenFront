// lib/provider/authprovider.dart
import 'dart:convert'; // Para json.decode y json.encode
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:kafen/models/response_api.dart';
import '../models/user.dart'; // Ajusta esta ruta si es necesario
import 'package:kafen/enviroment/enviroment.dart';

class AuthProvider extends GetConnect {
  final GetStorage _storage = GetStorage();
  final String _endpoint = Enviroment.API_URL;

  final Rx<User?> usuarioActual = Rx<User?>(null);

  String get nombreDelUsuario {
    return usuarioActual.value?.nombreCompleto ?? "Invitado";
  }

  bool get isLoggedIn => usuarioActual.value != null;

  @override
  void onInit() {
    super.onInit();
    _cargarUsuarioDesdeStorage();
  }

  // Método para cargar o recargar el usuario desde GetStorage
  // Ahora puede ser llamado externamente.
  void actualizarUsuarioDesdeStorage() {
    print("AuthProvider: actualizarUsuarioDesdeStorage() llamado.");
    final dynamic rawUserData = _storage.read('user');
    print("AuthProvider: Raw data read from GetStorage for key 'user': $rawUserData");
    print("AuthProvider: Type of raw data from GetStorage: ${rawUserData.runtimeType}");

    if (rawUserData == null) {
      print("AuthProvider: No data found in GetStorage for key 'user' during update.");
      // Solo actualiza a null si realmente no hay nada o si queremos forzar un reset.
      // Si es una actualización post-login, y rawUserData es null, algo salió mal en el guardado.
      if (usuarioActual.value != null) { // Solo cambia a null si antes había un usuario
          usuarioActual.value = null;
      }
      return;
    }

    Map<String, dynamic>? userDataMap;

    if (rawUserData is String) {
      print("AuthProvider: Data from GetStorage is a String. Attempting to decode JSON during update.");
      try {
        userDataMap = json.decode(rawUserData) as Map<String, dynamic>?;
      } catch (e) {
        print("AuthProvider: Failed to decode JSON string from GetStorage during update: $e");
        if (usuarioActual.value != null) usuarioActual.value = null;
        return;
      }
    } else if (rawUserData is Map<String, dynamic>) {
      print("AuthProvider: Data from GetStorage is already a Map<String, dynamic> during update.");
      userDataMap = rawUserData;
    } else {
      print("AuthProvider: Data from GetStorage (during update) is not null, not a String, and not a Map<String, dynamic>. Format is incorrect. Type: ${rawUserData.runtimeType}");
      if (usuarioActual.value != null) usuarioActual.value = null;
      return;
    }

    if (userDataMap != null) {
      try {
        usuarioActual.value = User.fromJson(userDataMap);
        print("AuthProvider: User parsed successfully during update. Nombre Completo: ${usuarioActual.value?.nombreCompleto}");

        if (usuarioActual.value?.nombreCompleto?.isEmpty ?? true) {
            print("AuthProvider: WARNING - nombreCompleto (during update) está vacío después del parseo. Verifica User.fromJson y las claves en los datos.");
            print("AuthProvider: Datos del mapa pasados a User.fromJson (during update): $userDataMap");
        }
      } catch (e) {
        print("AuthProvider: Error while calling User.fromJson (during update): $e");
        print("AuthProvider: Data map passed to User.fromJson (during update): $userDataMap");
        if (usuarioActual.value != null) usuarioActual.value = null;
      }
    } else {
      print("AuthProvider: userDataMap es null (during update) después de las verificaciones de tipo y posible decodificación.");
      if (usuarioActual.value != null) usuarioActual.value = null;
    }
  }

  // _cargarUsuarioDesdeStorage ahora es interno y llamado por onInit y el método público.
  void _cargarUsuarioDesdeStorage() {
      actualizarUsuarioDesdeStorage(); // Reutiliza la lógica
  }


  Future<http.Response> registerUser({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    final url = Uri.parse('$_endpoint/usuarios');
    final headers = {'Content-Type': 'application/json'};
    final body = json.encode({
      'nombre_completo': name,
      'username': name,
      'correo_electronico': email,
      'telefono': phone,
      'password': password,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      return response;
    } catch (e) {
      print('AuthProvider - Error en registerUser: $e');
      Get.snackbar('Error de Registro', 'No se pudo conectar con el servidor.');
      return http.Response('Error de conexión: $e', 503);
    }
  }

  void logout() {
    _storage.remove('user');
    _storage.remove('loginTimestamp');
    usuarioActual.value = null; // Esto disparará Obx en CitasView
    print("AuthProvider: Usuario deslogueado.");
    Get.offAllNamed('/home');
  }
}

