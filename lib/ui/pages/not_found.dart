import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Importa Get si usarás su navegación

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Puedes añadir un AppBar si quieres mantener la consistencia visual
      // appBar: AppBar(
      //   title: Text("Error"),
      // ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Añade padding alrededor
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Centra verticalmente
            crossAxisAlignment: CrossAxisAlignment.center, // Centra horizontalmente
            children: [
              Icon(
                Icons.error_outline, // Ícono de error
                color: Colors.red,
                size: 80,
              ),
              const SizedBox(height: 20), // Espacio
              Text(
                '404',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10), // Espacio
              Text(
                'Página No Encontrada',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15), // Espacio
              Text(
                'Lo sentimos, la ruta o página que estás buscando no existe o no está disponible.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30), // Espacio antes del botón
              ElevatedButton.icon(
                icon: const Icon(Icons.home),
                label: const Text('Ir al Inicio'),
                onPressed: () {
                  // Navega a la página de inicio y elimina el historial anterior
                  // Asegúrate de que '/home' o '/' sea tu ruta de inicio correcta
                  Get.offAllNamed('/counter');
                  // Si no usas GetX para navegación, usarías:
                  // Navigator.of(context).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}