// lib/provider/calendario_provider.dart
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

// Asegúrate que las rutas a tus modelos y environment sean correctas
import 'package:kafen/enviroment/enviroment.dart';
import 'package:kafen/models/calendario_clase_model.dart';

class CalendarioProvider extends GetConnect {
  final String _endpoint = Enviroment.API_URL;

  // Método para obtener las clases de una fecha específica
  Future<List<CalendarioClase>> getClasesPorFecha(DateTime fecha) async {
    // Formatear la fecha al formato YYYY-MM-DD que espera la API
    final String fechaFormateada = DateFormat('yyyy-MM-dd').format(fecha);
    final url = Uri.parse('$_endpoint/calendario/fecha/$fechaFormateada');
    
    print('CalendarioProvider: Llamando a la API: $url');

    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json'
      });

      if (response.statusCode == 200) {
        // Si la respuesta está vacía, devuelve una lista vacía
        if (response.body.isEmpty) {
          print('CalendarioProvider: Respuesta exitosa pero vacía para la fecha $fechaFormateada.');
          return [];
        }
        
        // Decodifica la respuesta JSON y la convierte a una lista de objetos CalendarioClase
        final List<CalendarioClase> clases = calendarioClaseFromJson(response.body);
        print('CalendarioProvider: ${clases.length} clases encontradas para la fecha $fechaFormateada.');
        return clases;
      } else {
        print('CalendarioProvider: Error en la API - Código: ${response.statusCode}, Cuerpo: ${response.body}');
        throw Exception('Error al cargar las clases desde la API');
      }
    } catch (e) {
      print('CalendarioProvider: Error de conexión o de parseo de datos - $e');
      throw Exception('No se pudo conectar con el servidor para obtener las clases.');
    }
  }
}
