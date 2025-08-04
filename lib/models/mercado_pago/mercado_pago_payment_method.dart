import 'package:kafen/models/mercado_pago/mercado_pago_financial_institution.dart';
import 'package:kafen/models/mercado_pago/mercado_pago_issuer.dart';

class MercadoPagoPaymentMethod {
  //IDENTIFICADOR DEL MEDIO DE PAGO
  String? id;

  //NOMBRE DEL MEDIO DE PAGO
  String? name;

  String? paymentTypeId;
  String? status;
  String? secureThumbnail;
  String? thumbnail;
  String? deferredCapture;

  MercadoPagoIssuer? issuer = MercadoPagoIssuer();

  //SETTINGS
  int? cardNumberLength;
  String? binPattern;
  String? binExclusionPattern;
  int? securityCodeLength;

  List<dynamic>? additionalInfoNeeded = [];
  double? minAllowedAmount;
  double? maxAllowedAmount;
  double? accreditationTime;
  List<MercadoPagoFinancialInstitution>? financialInstitutions;

  MercadoPagoPaymentMethod({this.id});

  static List<MercadoPagoPaymentMethod> fromJsonList(List<dynamic> jsonList) {
    List<MercadoPagoPaymentMethod> toList = [];

    for (var item in jsonList) {
      MercadoPagoPaymentMethod model = MercadoPagoPaymentMethod.fromJson(item);
      toList.add(model);
    }

    return toList;
  }

  // --- CONSTRUCTOR CORREGIDO Y MÁS ROBUSTO ---
  MercadoPagoPaymentMethod.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    paymentTypeId = json['payment_type_id'];
    status = json['status'];
    secureThumbnail = json['secure_thumbnail'];
    thumbnail = json['thumbnail'];
    deferredCapture = json['deferred_capture'];

    // --- CORRECCIÓN APLICADA AQUÍ ---
    // Se añaden verificaciones de nulidad para evitar el crash.
    // Ahora, solo intentará leer los datos si la estructura es la esperada.
    if (json['payment_type_id'] == 'credit_card' && json['settings'] != null && json['settings'] is List && (json['settings'] as List).isNotEmpty) {
      var settings = json['settings'][0];
      if (settings['card_number'] != null) {
        cardNumberLength = int.tryParse(settings['card_number']['length']?.toString() ?? '-1');
      }
      if (settings['bin'] != null) {
        binPattern = settings['bin']['pattern'];
        binExclusionPattern = settings['bin']['exclusion_pattern'];
      }
      if (settings['security_code'] != null) {
        securityCodeLength = int.tryParse(settings['security_code']['length']?.toString() ?? '-1');
      }
    }

    additionalInfoNeeded = json['additional_info_needed'];
    minAllowedAmount = (json['min_allowed_amount'] != null)
        ? double.tryParse(json['min_allowed_amount'].toString())
        : null;
    maxAllowedAmount = (json['max_allowed_amount'] != null)
        ? double.tryParse(json['max_allowed_amount'].toString())
        : null;
    accreditationTime = (json['accreditation_time'] != null)
        ? double.tryParse(json['accreditation_time'].toString())
        : null;
    financialInstitutions = (json['financial_institutions'] != null)
        ? MercadoPagoFinancialInstitution.fromJsonList(
            json['financial_institutions'])
        : [];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'payment_type_id': paymentTypeId,
        'status': status,
        'secure_thumbnail': secureThumbnail,
        'thumbnail': thumbnail,
        'deferred_capture': deferredCapture,
        'card_number_length': cardNumberLength,
        'bin_pattern': binPattern,
        'bin_exclusion_pattern': binExclusionPattern,
        'security_code_length': securityCodeLength,
        'additional_info_needed': additionalInfoNeeded.toString(),
        'min_allowed_amount': minAllowedAmount,
        'max_allowed_amount': maxAllowedAmount,
        'accreditation_time': accreditationTime,
        'financial_institutions': financialInstitutions
      };
}
