import 'dart:convert';

/// Representa una de las opciones de cuotas (installments) devueltas por la API de Mercado Pago.
/// Este modelo está diseñado para ser robusto y manejar correctamente los tipos de datos.
class MercadoPagoInstallment {
  MercadoPagoInstallment({
    required this.installments,
    required this.installmentRate,
    required this.discountRate,
    required this.reimbursementRate,
    required this.labels,
    required this.installmentRateCollector,
    required this.minAllowedAmount,
    required this.maxAllowedAmount,
    required this.recommendedMessage,
    required this.installmentAmount,
    required this.totalAmount,
    required this.paymentMethodOptionId,
  });

  final int installments;
  // --- CORRECCIÓN CLAVE ---
  // Cambiado de int a double para aceptar decimales como 7.91
  final double installmentRate;
  final int discountRate;
  final int reimbursementRate;
  final List<String> labels;
  final List<String> installmentRateCollector;
  final int minAllowedAmount;
  final int maxAllowedAmount;
  final String recommendedMessage;
  // --- CORRECCIÓN CLAVE ---
  // Cambiado de int a double para aceptar decimales como 35.97
  final double installmentAmount;
  // --- CORRECCIÓN CLAVE ---
  // Cambiado de int a double para aceptar decimales como 107.91
  final double totalAmount;
  final String paymentMethodOptionId;

  factory MercadoPagoInstallment.fromJson(String str) =>
      MercadoPagoInstallment.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  /// Construye un objeto MercadoPagoInstallment desde un mapa (JSON).
  /// Este método es seguro y maneja la conversión de tipos correctamente.
  factory MercadoPagoInstallment.fromMap(Map<String, dynamic> json) =>
      MercadoPagoInstallment(
        installments: json["installments"],
        // --- CORRECCIÓN CLAVE ---
        // Se asegura de convertir el número a double de forma segura.
        installmentRate: (json["installment_rate"] as num).toDouble(),
        discountRate: json["discount_rate"],
        reimbursementRate: json["reimbursement_rate"],
        labels: List<String>.from(json["labels"].map((x) => x)),
        installmentRateCollector:
            List<String>.from(json["installment_rate_collector"].map((x) => x)),
        minAllowedAmount: json["min_allowed_amount"],
        maxAllowedAmount: json["max_allowed_amount"],
        recommendedMessage: json["recommended_message"],
        // --- CORRECCIÓN CLAVE ---
        // Se asegura de convertir el número a double de forma segura.
        installmentAmount: (json["installment_amount"] as num).toDouble(),
        // --- CORRECCIÓN CLAVE ---
        // Se asegura de convertir el número a double de forma segura.
        totalAmount: (json["total_amount"] as num).toDouble(),
        paymentMethodOptionId: json["payment_method_option_id"],
      );

  /// Convierte el objeto a un mapa para poder enviarlo como JSON si es necesario.
  Map<String, dynamic> toMap() => {
        "installments": installments,
        "installment_rate": installmentRate,
        "discount_rate": discountRate,
        "reimbursement_rate": reimbursementRate,
        "labels": List<dynamic>.from(labels.map((x) => x)),
        "installment_rate_collector":
            List<dynamic>.from(installmentRateCollector.map((x) => x)),
        "min_allowed_amount": minAllowedAmount,
        "max_allowed_amount": maxAllowedAmount,
        "recommended_message": recommendedMessage,
        "installment_amount": installmentAmount,
        "total_amount": totalAmount,
        "payment_method_option_id": paymentMethodOptionId,
      };
}
