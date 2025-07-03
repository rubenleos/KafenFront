// lib/enviroment/enviroment.dart

class Enviroment {
  // Hemos reemplazado String.fromEnvironment por una constante directa
  // para evitar problemas de valores nulos durante el desarrollo en web.
  // Asegúrate de que esta sea la URL correcta de tu backend local.
  static const String API_URL = 'http://127.0.0.1:8000';
  static const API_MERCADO_PAGO = 'https://api.mercadopago.com/v1';
   static const ACCESS_TOKEN= "TEST-8924484007365875-061815-e993285aff913ff9710e37a95f77d064-72857723";

   static const String PUBLIC_KEY = 'TEST-51703793-b227-4e6a-9b45-ec7ee2055aa9';
}


