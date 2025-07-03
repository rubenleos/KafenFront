// mercado_pago_provider.dart
import 'dart:convert';
// Asegúrate de que esta ruta sea correcta
import 'package:get/get.dart';
import 'package:kafen/enviroment/enviroment.dart'; // Asumo que esta es la ruta a tu archivo de entorno
import 'package:kafen/models/mercado_pago/mercado_pago_card_token.dart';
import 'package:kafen/models/mercado_pago_document_type.dart';

class MercadoPagoProvider extends GetConnect {
  // URL base de la API de Mercado Pago
  final String _mercadoPagoApiUrl = 'https://api.mercadopago.com/v1';

  // Claves de tu aplicación de Mercado Pago (desde tu archivo de entorno)
  // ACCESS_TOKEN es para operaciones de backend (pagos, etc.). Es SECRETO.
  final String _accessToken = Enviroment.ACCESS_TOKEN;
  // PUBLIC_KEY es para operaciones de frontend (como crear tokens de tarjeta). Es PÚBLICA.
  final String _publicKey = Enviroment.PUBLIC_KEY;

  /// Obtiene los tipos de documento de identificación de Mercado Pago.
 

  /// Crea un token de tarjeta de un solo uso en Mercado Pago.
  /// Este token se usa para enviar los datos de la tarjeta de forma segura a tu backend.
  /// NOTA: La tokenización de tarjetas requiere la PUBLIC_KEY, no el ACCESS_TOKEN.
  Future<MercadoPagoCardToken?> createCardToken({
    required String cardNumber,
    required String expirationYear,
    required int expirationMonth,
    required String cardHolderName,
    required String cvv,
    
   
  }) async {
    // El endpoint para crear tokens de tarjeta es /card_tokens y usa la PUBLIC_KEY como query param.
    final String url = '$_mercadoPagoApiUrl/card_tokens?public_key=$_publicKey';

    // El cuerpo de la petición debe coincidir con la documentación de Mercado Pago.
    final Map<String, dynamic> cardTokenBody = {
      'card_number': cardNumber.replaceAll(' ', ''), // Enviamos sin espacios
      'expiration_year': expirationYear,
      'expiration_month': expirationMonth,
      'security_code': cvv,
      'cardholder': {
        'name': cardHolderName
        
      }
    };

    try {
      Response response = await post(
        url,
        json.encode(cardTokenBody), // El cuerpo debe ser un string JSON
        headers: {
          'Content-Type': 'application/json'
        },
       
      );

      print('RESPONSE: ${response}');
      print('Response status ${response.statusCode}');
      print('Respose body : ${response.body}');

      // Una respuesta exitosa para la creación de token es 201 (Created)
      if (response.statusCode == 201) {
     
        // Parseamos la respuesta JSON a nuestro modelo MercadoPagoCardToken
        final MercadoPagoCardToken cardToken = MercadoPagoCardToken.fromJson(response.body);
        return cardToken;
        
      }
      
       else {
        // Si la API de Mercado Pago devuelve un error (ej. 400 por datos inválidos)
        Get.snackbar( 'Error', 'No se pudo validar la tarjera');
        print('Error al crear token de tarjeta: ${response.statusCode}');
        print('Cuerpo del error: ${response.bodyString}');
        Get.snackbar(
          'Error en los datos de la tarjeta',
          'No se pudo crear el token. Revisa los datos de la tarjeta e inténtalo de nuevo.',
        );
        return null;
      }
    } catch (e) {
      // Error de conexión o cualquier otra excepción
      print('Excepción al crear token de tarjeta: $e');
      Get.snackbar('Error de conexión', 'No se pudo comunicar con el servidor. Revisa tu conexión a internet.');
      return null;
    }
  }
}