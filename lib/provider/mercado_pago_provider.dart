// mercado_pago_provider.dart

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kafen/enviroment/enviroment.dart';
import 'package:kafen/models/mercado_pago/mercado_pago_card_token.dart';
import 'package:kafen/models/user.dart';

import '../models/mercado_pago/order.dart';
// Asumo que tienes un modelo Order, si no, puedes pasar los datos directamente.


class MercadoPagoProvider extends GetConnect {
  final String _mercadoPagoApiUrl = 'https://api.mercadopago.com/v1';
  User userSession =User.fromJson(GetStorage().read('key') ?? {});
  // URL de tu propio backend. Asegúrate de que apunte a tu servidor.
  final String _myBackendApiUrl = Enviroment.API_URL;

  final String _accessToken = Enviroment.ACCESS_TOKEN;
  final String _publicKey = Enviroment.PUBLIC_KEY;

  // ... (tu función createCardToken se queda igual) ...

  /// Envía los datos del pago a tu backend para ser procesados.
  Future<Response> createPayment({
    required String token,
    required String paymentMethodId,
    required String paymentTypeId,
    required String emailCustomer,
    required String issuerId,
    required String identificationType,
    required String identificationNumber,
    // CORREGIDO: El monto de la transacción debe ser un número.
    required double transactionAmount, 
    // CORREGIDO: Las cuotas deben ser un número entero.
    required int installments, 
    required Order order,
  }) async {
    
    // Este es el endpoint que crearás en tu backend (ver la sección de Python más abajo).
    final String url = '$_myBackendApiUrl/pagos/create';

    final Map<String, dynamic> paymentBody = {
      'token': token,
      'payment_method_id': paymentMethodId,
      'payment_type_id': paymentTypeId,
      'issuer_id': issuerId,
      'installments': installments,
      'transaction_amount': transactionAmount,
      'payer': {
        'email': emailCustomer,
        'identification': {
          'type': identificationType,
          'number': identificationNumber,
        }
      },
      // Puedes enviar información adicional de la orden si tu backend la necesita.
      'order_details': order.toJson() 
    };

    try {
      // Realizamos la petición POST a nuestro propio servidor.
      // Si tu backend requiere autenticación (ej. un JWT), debes añadirlo aquí en los headers.
      Response response = await post(
        url,
        json.encode(paymentBody),
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer TU_JWT_TOKEN' // Descomentar si usas autenticación
        },
      );
      return response;

    } catch (e) {
      Get.snackbar('Error de Conexión', 'No se pudo conectar con el servidor: $e');
      // Devolvemos una respuesta de error para que el controller pueda manejarla.
      return Response(statusCode: 500, statusText: 'Error de conexión con el servidor.');
    }
  }
}