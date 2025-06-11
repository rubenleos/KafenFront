// lib/models/calendario_clase_model.dart
import 'dart:convert';

// Función de ayuda para convertir una lista de JSON en una lista de objetos CalendarioClase
List<CalendarioClase> calendarioClaseFromJson(String str) => List<CalendarioClase>.from(json.decode(str).map((x) => CalendarioClase.fromJson(x)));

// Función de ayuda para convertir una lista de objetos CalendarioClase a un string JSON
String calendarioClaseToJson(List<CalendarioClase> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CalendarioClase {
    final int calendarioId;
    final DateTime fecha;
    final String horaInicio;
    final String horaFin;
    final int cupoMaximo;
    final int cupoDisponible;

    CalendarioClase({
        required this.calendarioId,
        required this.fecha,
        required this.horaInicio,
        required this.horaFin,
        required this.cupoMaximo,
        required this.cupoDisponible,
    });

    // Factory para crear un objeto desde un mapa JSON que viene de la API
    factory CalendarioClase.fromJson(Map<String, dynamic> json) => CalendarioClase(
        calendarioId: json["calendario_id"],
        fecha: DateTime.parse(json["fecha"]), // Parsea el string de fecha a un objeto DateTime
        horaInicio: json["hora_inicio"],
        horaFin: json["hora_fin"],
        cupoMaximo: json["cupo_maximo"],
        cupoDisponible: json["cupo_disponible"],
    );

    // Método para convertir el objeto a un mapa JSON (útil si necesitas enviar datos)
    Map<String, dynamic> toJson() => {
        "calendario_id": calendarioId,
        "fecha": "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
        "hora_inicio": horaInicio,
        "hora_fin": horaFin,
        "cupo_maximo": cupoMaximo,
        "cupo_disponible": cupoDisponible,
    };
}
