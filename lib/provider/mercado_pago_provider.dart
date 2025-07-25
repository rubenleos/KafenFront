import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:kafen/enviroment/enviroment.dart';
import 'package:kafen/models/mercado_pago/mercado_pago_card_token.dart';
import 'package:kafen/models/mercado_pago/mercado_pago_payment_method.dart';
import 'package:kafen/models/mercado_pago/mercado_pago_payment_method_installments.dart';
import '../models/mercado_pago/order.dart';

class MercadoPagoProvider extends GetConnect {
  // URL base de la API de Mercado Pago
  final String _mercadoPagoApiUrl = Enviroment.API_MERCADO_PAGO;
  // URL de tu propio backend
  final String _myBackendApiUrl = Enviroment.API_URL;
  // Credenciales de Mercado Pago (desde tu archivo de entorno)
  final String _accessToken = Enviroment.ACCESS_TOKEN;
  final String _publicKey = Enviroment.PUBLIC_KEY;

  /// Obtiene la información del medio de pago (Visa, Mastercard, etc.)
  /// basado en el BIN de la tarjeta (los primeros 6 u 8 dígitos).
  ///
  /// @param bin Los primeros dígitos del número de la tarjeta.
  /// @return Una lista de métodos de pago que coinciden con el BIN.
  Future<List<MercadoPagoPaymentMethod>> getPaymentMethods(String bin) async {
    // Construye la URL para el endpoint de 'payment_methods' de Mercado Pago.
    final url = '$_mercadoPagoApiUrl/payment_methods?public_key=$_publicKey&bin=$bin';
    
    try {
      Response response = await get(url);

      // Si la solicitud fue exitosa (código 200)
      if (response.statusCode == 200) {
        // Verifica que la respuesta sea una lista y no esté vacía.
        if (response.body is List && response.body.isNotEmpty) {
          // Parsea la respuesta JSON a una lista de objetos MercadoPagoPaymentMethod.
          return MercadoPagoPaymentMethod.fromJsonList(response.body);
        }
      } else {
        // Si hay un error, lo imprime en la consola para depuración.
        if (kDebugMode) {
          print('Error al obtener métodos de pago: ${response.body}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Excepción al obtener métodos de pago: $e');
      }
    }
    // Si algo falla, retorna una lista vacía.
    return [];
  }

  /// Obtiene las opciones de cuotas y la información del banco emisor.
  ///
  /// @param bin El BIN de la tarjeta.
  /// @param amount El monto total de la transacción.
  /// @return Una lista con la información de las cuotas y el emisor.
  Future<List<MercadoPagoPaymentMethodInstallments>> getInstallments(String bin, double amount) async {
    // Construye la URL para el endpoint de 'installments' de Mercado Pago.
    final url = '$_mercadoPagoApiUrl/payment_methods/installments?public_key=$_publicKey&bin=$bin&amount=$amount';

    try {
      Response response = await get(url);

      if (response.statusCode == 200) {
        if (response.body is List && response.body.isNotEmpty) {
          // Parsea la respuesta JSON a una lista de objetos.
          return MercadoPagoPaymentMethodInstallments.fromJsonList(response.body);
        }
      } else {
        if (kDebugMode) {
          print('Error al obtener cuotas: ${response.body}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Excepción al obtener cuotas: $e');
      }
    }
    return [];
  }

  /// Crea un token seguro de un solo uso para la tarjeta.
  /// Esto evita que los datos sensibles de la tarjeta viajen a tu backend.
  Future<MercadoPagoCardToken?> createCardToken({
    required String cardNumber,
    required String expirationYear,
    required int expirationMonth,
    required String cardHolderName,
    required String cvv,
    required String identificationType,
    required String identificationNumber,
  }) async {
    // Construye la URL para crear el token de tarjeta.
    final url = '$_mercadoPagoApiUrl/card_tokens?public_key=$_publicKey';

    final body = {
      'card_number': cardNumber,
      'expiration_year': expirationYear,
      'expiration_month': expirationMonth,
      'security_code': cvv,
      'cardholder': {
        'name': cardHolderName,
        'identification': {
          'type': identificationType,
          'number': identificationNumber,
        }
      }
    };

    try {
      Response response = await post(url, json.encode(body));

      if (response.statusCode == 201) { // 201 = Created
        // Si el token se crea correctamente, lo parsea y lo retorna.
        return MercadoPagoCardToken.fromJson(response.body);
      } else {
        if (kDebugMode) {
          print('Error al crear token de tarjeta: ${response.body}');
        }
        Get.snackbar('Error de validación', 'No se pudo validar la tarjeta. Revisa los datos e intenta de nuevo.');
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Excepción al crear token de tarjeta: $e');
      }
      return null;
    }
  }

  /// Envía la información del pago (incluyendo el token) a tu propio backend
  /// para que este complete la transacción con Mercado Pago.
  Future<Response?> createPayment({
    required String token,
    required String paymentMethodId,
    required String paymentTypeId,
    required String emailCustomer,
    required String issuerId,
    required String identificationType,
    required String identificationNumber,
    required double transactionAmount,
    required int installments,
    required Order order,
  }) async {
    // La URL de tu backend que procesará el pago.
    final String url = '$_myBackendApiUrl/pagos/create'; // Asegúrate que este endpoint exista en tu backend.

    final Map<String, dynamic> paymentBody = {
      'token': token,
      'payment_method_id': paymentMethodId,
      'payment_type_id': paymentTypeId,
      'issuer_id': issuerId,
      'installments': installments,
      'transaction_amount': transactionAmount,
      'payer': {
        'email': emailCustomer,
        'identification': {'type': identificationType, 'number': identificationNumber}
      },
      'order_details': order.toJson(), // Detalles adicionales de la orden
      // Puedes agregar más metadata aquí si tu backend lo requiere.
      'description': 'Compra de paquete: ${order.id}',
    };

    try {
      // Se hace la llamada POST a tu servidor con todos los datos del pago.
      Response response = await post(
        url,
        json.encode(paymentBody),
        headers: {
          'Content-Type': 'application/json',
          // Si tu backend requiere autenticación, agrégala aquí.
          // 'Authorization': 'Bearer TU_JWT_TOKEN'
        },
      );
      return response;
    } catch (e) {
      if (kDebugMode) {
        print('Excepción al crear el pago en el backend: $e');
      }
      return null;
    }
  }
}
