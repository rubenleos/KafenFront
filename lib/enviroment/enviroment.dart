// lib/enviroment/enviroment.dart

class Enviroment {
  // Hemos reemplazado String.fromEnvironment por una constante directa
  // para evitar problemas de valores nulos durante el desarrollo en web.
  // Asegúrate de que esta sea la URL correcta de tu backend local.
  static const String API_URL = 'http://127.0.0.1:8000';
  static const API_MERCADO_PAGO = '';
   static const ACCESS_TOKEN= "";

   static const String PUBLIC_KEY = '';
}



