// lib/models/user.dart
import 'dart:convert';

// Funciones de ayuda para la conversión JSON
User userFromJson(String str) => User.fromJson(json.decode(str));
String userToJson(User data) => json.encode(data.toJson());

class User {
  // Propiedades que tu aplicación necesita para funcionar
  int? usuarioId;
  String nombreCompleto;
  String correoElectronico;
  String? telefono;
  String? nombreUsuario; // El username que se usa para login/registro
  String? accessToken;   // Para guardar el token de la sesión

  User({
    this.usuarioId,
    required this.nombreCompleto,
    required this.correoElectronico,
    this.telefono,
    this.nombreUsuario,
    this.accessToken,
  });

  // Factory para crear un objeto User desde el JSON
  // Este es el paso MÁS IMPORTANTE. Ahora lee las claves que devuelve tu API.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      // Lee las claves que tu API devuelve DENTRO del objeto 'data'
      usuarioId: json["usuario_id"],
      nombreCompleto: json["nombre_completo"] ?? '', // Si es nulo, usa un string vacío
      correoElectronico: json["correo_electronico"] ?? '',
      telefono: json["telefono"],
      nombreUsuario: json["nombre_usuario"],
      accessToken: json["access_token"],
    );
  }

  // Método para convertir el objeto User a un Map JSON.
  // Es útil para cuando necesitas ENVIAR datos a la API (ej. crear un nuevo usuario).
  Map<String, dynamic> toJson() => {
    // Usa las claves que la API espera para crear o actualizar
    "usuario_id": usuarioId,
    "nombre_usuario": nombreUsuario,
    "nombre_completo": nombreCompleto,
    "correo_electronico": correoElectronico,
    "telefono": telefono,
    // No incluyas el token o la contraseña aquí por seguridad.
    // La contraseña se maneja por separado en los formularios de registro/login.
  };
}
