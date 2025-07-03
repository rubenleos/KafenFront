

class MercadoPagoDocumentType {
  String? id;
  String? name;
  String? type;
  int? minLength;
  int? maxLength;

  // Constructor principal
  MercadoPagoDocumentType({
    this.id,
    this.name,
    this.type,
    this.minLength,
    this.maxLength,
  });

  // Constructor con nombre para crear una lista a partir de un JSON
  // Este método estático es más limpio y seguro.
  static List<MercadoPagoDocumentType> fromJsonList(List<dynamic> jsonList) {
    List<MercadoPagoDocumentType> toList = [];
    jsonList.forEach((item) {
      // Usamos el constructor fromJson para cada elemento de la lista
      MercadoPagoDocumentType document = MercadoPagoDocumentType.fromJson(item);
      toList.add(document);
    });
    return toList;
  }

  // Constructor con nombre para crear una instancia desde un mapa JSON
  factory MercadoPagoDocumentType.fromJson(Map<String, dynamic> json) {
    return MercadoPagoDocumentType(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      // Hacemos una validación segura para los campos numéricos
      minLength: (json['min_length'] != null) ? int.tryParse(json['min_length'].toString()) ?? 0 : 0,
      maxLength: (json['max_length'] != null) ? int.tryParse(json['max_length'].toString()) ?? 0 : 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'min_length': minLength,
        'max_length': maxLength,
      };
}
