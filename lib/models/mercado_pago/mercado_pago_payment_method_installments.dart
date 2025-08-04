import 'dart:convert';
import 'package:kafen/models/mercado_pago/mercado_pago_installment.dart';
import 'package:kafen/models/mercado_pago/mercado_pago_issuer.dart';

/// Representa la respuesta completa de la API de cuotas de Mercado Pago.
/// Contiene la información del emisor y una lista de las cuotas disponibles (payer_costs).
class MercadoPagoPaymentMethodInstallments {
  MercadoPagoPaymentMethodInstallments({
    required this.paymentMethodId,
    required this.paymentTypeId,
    required this.issuer,
    required this.processingMode,
    this.merchantAccountId,
    required this.payerCosts,
    this.agreements,
  });

  final String paymentMethodId;
  final String paymentTypeId;
  final MercadoPagoIssuer issuer;
  final String processingMode;
  final dynamic merchantAccountId;
  // La lista de cuotas ahora usa el modelo corregido
  final List<MercadoPagoInstallment> payerCosts;
  final dynamic agreements;

  factory MercadoPagoPaymentMethodInstallments.fromJson(String str) =>
      MercadoPagoPaymentMethodInstallments.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  /// Construye el objeto desde un mapa (JSON) de forma segura.
  factory MercadoPagoPaymentMethodInstallments.fromMap(Map<String, dynamic> json) =>
      MercadoPagoPaymentMethodInstallments(
        paymentMethodId: json["payment_method_id"],
        paymentTypeId: json["payment_type_id"],
        issuer: MercadoPagoIssuer.fromJson(json["issuer"]),
        processingMode: json["processing_mode"],
        merchantAccountId: json["merchant_account_id"],
        // --- CORRECCIÓN CLAVE ---
        // Se asegura de que la lista de cuotas (payer_costs) se procese correctamente
        // llamando al método `fromMap` del modelo `MercadoPagoInstallment` que ya corregimos.
        payerCosts: List<MercadoPagoInstallment>.from(
            json["payer_costs"].map((x) => MercadoPagoInstallment.fromMap(x))),
        agreements: json["agreements"],
      );
  
  /// Convierte el objeto a un mapa.
  Map<String, dynamic> toMap() => {
        "payment_method_id": paymentMethodId,
        "payment_type_id": paymentTypeId,
        "issuer": issuer.toJson(),
        "processing_mode": processingMode,
        "merchant_account_id": merchantAccountId,
        "payer_costs": List<dynamic>.from(payerCosts.map((x) => x.toMap())),
        "agreements": agreements,
      };

  /// Método estático para convertir una lista de JSON en una lista de este objeto.
  /// Es el que usa tu provider.
  static List<MercadoPagoPaymentMethodInstallments> fromJsonList(List<dynamic> jsonList) {
    List<MercadoPagoPaymentMethodInstallments> toList = [];
    for (var item in jsonList) {
      toList.add(MercadoPagoPaymentMethodInstallments.fromMap(item));
    }
    return toList;
  }
}
