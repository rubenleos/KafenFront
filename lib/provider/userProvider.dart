import 'package:get/get.dart';
import 'package:kafen/models/response_api.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kafen/enviroment/enviroment.dart';

   final String endpoint = ('${Enviroment
        .API_URL}');
  

class UsersProvider extends GetConnect {

   Future<ResponseApi> login(String numero, String password) async {
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'username': numero, 'password': password});
    final url =Uri.parse('$endpoint/usuarios/login');
    try {
      final response = await http.post(url, headers: headers, body: body); // Usa http.post

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final decodedBody = jsonDecode(response.body);
        if (decodedBody is Map<String, dynamic>) {
          return ResponseApi.fromJson(decodedBody);
        }
        else {
          //Respuesta inesperada
          return ResponseApi(success: false, message: "Respuesta Invalida", nombre: '',  correoElectronico: '', );
        }
      } else {
        //Simplificado, considera diferentes codigos de error.
        return ResponseApi(success: false, message: response.body, nombre: '', correoElectronico: '', );
      }
    } catch (e) {
      print('Error de conexión: $e');
      Get.snackbar('Error', 'No se pudo ejecutar la peticion'); //Usa Get.snackbar dentro del catch
      return ResponseApi(success: false, message: "Error de Conexión", nombre: '',  correoElectronico: '');
    }
  }
  

}