import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CallToActionBanner extends StatelessWidget {
  const CallToActionBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final buttonBackgroundColor = const Color(0xFFD2C6B5); // Tono beige/arena
    final buttonTextColor = Colors.black.withOpacity(0.8); // Casi negro

    return Container(
      // --- Altura Fija ---
      // Ajusta este valor según la altura que desees para el banner
      height: 450.0,
      // --- Ancho Infinito ---
      // Ocupa todo el ancho que le permita el widget padre
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand, // Asegura que los hijos llenen el Stack
        children: [
          // 1. Imagen de Fondo
          Image.asset(
            '/images/banner_background.jpg', // <-- ¡CAMBIA LA RUTA!
            fit: BoxFit.cover, // Cubre el contenedor
            semanticLabel: 'Practicando movimiento consciente  en el estudio',
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey[800],
              child: const Center(
                  child: Icon(Icons.broken_image,
                      color: Colors.grey, size: 50)),
            ),
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              if (wasSynchronouslyLoaded) return child;
              return AnimatedOpacity(
                child: child,
                opacity: frame == null ? 0 : 1,
                duration: const Duration(seconds: 1),
                curve: Curves.easeOut,
              );
            },
          ),

          // 2. Capa Oscura Superpuesta
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.35),
                  Colors.black.withOpacity(0.55),
                ],
              ),
            ),
          ),

          // 3. Contenido Centrado
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Texto principal
                  Text(
                    'Tu práctica, tu\nritmo, tu espacio',
                    textAlign: TextAlign.center,
                    style: textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                      letterSpacing: 0.5,
                       shadows: [
                         Shadow(
                           blurRadius: 8.0,
                           color: Colors.black.withOpacity(0.4),
                           offset: const Offset(1, 1),
                         ),
                       ],
                    ),
                  ),
                  const SizedBox(height: 35),

                  // Botón
                  ElevatedButton(
                    onPressed: () {
                       Get.toNamed('/citas');
                      print('Botón de reservar presionado!');
                      // Acción del botón
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonBackgroundColor,
                      foregroundColor: buttonTextColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      textStyle: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.3,
                        fontSize: 13
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                       elevation: 4,
                    ),
                    child: const Text('RESERVAR AHORA'), // <-- CONFIRMA TEXTO
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}