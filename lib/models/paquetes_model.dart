// lib/models/paquete_model.dart
import 'dart:convert';

// Funciones de ayuda para la conversión JSON
List<PackageModel> packageModelFromJson(String str) => List<PackageModel>.from(json.decode(str).map((x) => PackageModel.fromJson(x)));
String paqueteToJson(List<PackageModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PackageModel {
    final int paqueteId;
    final String nombrePaquete;
    final String? descripcion; // Nulable
    final int numeroClases;
    final String precio; // Lo manejamos como String para la UI, se puede convertir si se necesita calcular
    final String? duracion; // Nulable
    final String? tipoDePaquete; // Nulable

    PackageModel({
        required this.paqueteId,
        required this.nombrePaquete,
        this.descripcion,
        required this.numeroClases,
        required this.precio,
        this.duracion,
        this.tipoDePaquete,
    });

    // Factory para crear un objeto desde un mapa JSON que viene de la API
    // Esta es la parte clave de la solución.
    factory PackageModel.fromJson(Map<String, dynamic> json) => PackageModel(
        // Para campos obligatorios, si son nulos en el JSON, se lanzará un error, lo cual es correcto.
        paqueteId: json["paquete_id"],
        nombrePaquete: json["nombre_paquete"] ?? 'Paquete sin nombre', // Valor por defecto si es nulo
        
        // Para campos opcionales, simplemente los asignamos. Si son nulos, la propiedad será nula.
        descripcion: json["descripcion"],
        
        // Para campos numéricos, proporcionamos un valor por defecto si son nulos.
        numeroClases: json["numero_clases"] ?? 0,
        
        // El precio viene como un número, lo convertimos a String.
        precio: json["precio"]?.toString() ?? '0.00',
        
        duracion: json["duracion"],
        tipoDePaquete: json["Tipo_de_paquete"], // La API usa 'Tipo_de_paquete'
    );

    // Método para convertir el objeto a un mapa JSON
    Map<String, dynamic> toJson() => {
        "paquete_id": paqueteId,
        "nombre_paquete": nombrePaquete,
        "descripcion": descripcion,
        "numero_clases": numeroClases,
        "precio": precio,
        "duracion": duracion,
        "Tipo_de_paquete": tipoDePaquete,
    };
}
