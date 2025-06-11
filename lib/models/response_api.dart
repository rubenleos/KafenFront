import 'dart:convert';

ResponseApi responseApiFromJson(String str) => ResponseApi.fromJson(json.decode(str));

String responseApiToJson(ResponseApi data) => json.encode(data.toJson());

class ResponseApi {
  bool? success;
  String? message;
  String? nombre;
  String? apellido;
  String? correoElectronico;

 
  dynamic data;

  ResponseApi({
    required this.success,
    required this.message,
    required this.nombre,
    // required this.apellido,
    required this.correoElectronico,
  

    this.data,

  });

  factory ResponseApi.fromJson(Map<String, dynamic> json) => ResponseApi(
    success: json["success"],
    message: json["message"],
    nombre: json["nombre"],
   
    correoElectronico: json["correo_electronico"],
     data: json["data"],
    
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "nombre": nombre,
   
    "correo_electronico": correoElectronico,
    "data": data,
    
  };
}