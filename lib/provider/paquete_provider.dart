// lib/provider/package_provider.dart
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kafen/enviroment/enviroment.dart';

import 'package:kafen/models/paquetes_model.dart';

class PackageProvider extends GetConnect {
  final String _endpoint = Enviroment.API_URL;

  Future<List<PackageModel>> getPackages() async {
    final url = Uri.parse('$_endpoint/paquetes');
    print('PackageProvider: Llamando a la API (pública): $url');

    try {
      // Petición GET sin cabeceras de autenticación
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
      });

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isEmpty) {
          print('PackageProvider: Respuesta exitosa pero vacía.');
          return [];
        }
        
        final List<PackageModel> paquetes = packageModelFromJson(response.body);
        print('PackageProvider: ${paquetes.length} paquetes encontrados.');
        return paquetes;
      } else {
        print('PackageProvider: Error en la API - Código: ${response.statusCode}, Cuerpo: ${response.body}');
        throw Exception('Error al cargar los paquetes desde la API');
      }
    } catch (e) {
      print('PackageProvider: Error de conexión o de parseo de datos - $e');
      throw Exception('No se pudo conectar con el servidor para obtener los paquetes.');
    }
  }
}
