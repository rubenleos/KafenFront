import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui'; // Needed for ImageFilter

// Importa tu widget de contenido de login (lo crearemos después)
// Asegúrate de tener también el archivo login_dialog_content.dart creado
// import 'login_dialog_content.dart'; // Asumiendo que tienes este archivo

class CustomAppMenu extends StatelessWidget {
  final bool isScrolled;
  // --- NUEVO: LayerLink para conectar posición ---
  final LayerLink userIconLayerLink;
  // --- NUEVO: Callback para manejar el clic en el icono ---
  final VoidCallback onUserIconPressed;

  const CustomAppMenu({
    super.key,
    required this.isScrolled,
    required this.userIconLayerLink, // Hacer requerido
    required this.onUserIconPressed, // Hacer requerido
  });

  // Helper _buildNavItem sin cambios...
 Widget _buildNavItem(String text, VoidCallback onPressed, {required Color textColor}) {
    return TextButton(
      // --- Estilo del Botón ---
      style: ButtonStyle(
        // Color del texto principal
        foregroundColor: WidgetStateProperty.all(textColor),
        // Color de superposición para hover/pressed (basado en textColor)
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            // Aplica un efecto de color semitransparente si está en hover o presionado
            if (states.contains(WidgetState.hovered) || states.contains(WidgetState.pressed)) {
              return textColor.withOpacity(0.1); // Usa el color del texto con opacidad
            }
            return null; // Usa el color de superposición por defecto (o ninguno)
          },
        ),
        // Estilo del texto dentro del botón
        textStyle: WidgetStateProperty.all(
          const TextStyle(
            fontWeight: FontWeight.w600, // Peso de la fuente
            letterSpacing: 1.1,       // Espaciado entre letras
            fontSize: 14,             // Tamaño de la fuente
          ),
        ),
        // Padding interno del botón
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 10), // Espaciado horizontal y vertical
        ),
        // Forma del botón (bordes redondeados)
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Radio de 8px
        ),
      ),

      // --- Acción al Presionar ---
      // Ejecuta la función específica que se pasó para ESTE botón
      onPressed: onPressed,

      // --- Contenido del Botón ---
      // Muestra el texto en mayúsculas
      child: Text(text.toUpperCase()),
    );
  } // Fin de _buildNavItem
  @override
  Widget build(BuildContext context) {
    final Color currentBgColor = isScrolled ? Colors.white : Colors.transparent;
    final Color currentTextColor = isScrolled ? Colors.black87 : Colors.white;
    final List<BoxShadow>? currentShadow = isScrolled
        ? [ /* tu sombra */ BoxShadow(color: Colors.black.withOpacity(0.1), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 2)) ]
        : null;
    final BoxDecoration currentDecoration = isScrolled
        ? BoxDecoration( color: currentBgColor, boxShadow: currentShadow )
        : BoxDecoration( /* tu decoración con imagen */ color: Colors.transparent, image: DecorationImage(image: const AssetImage('assets/images/studio1.jpeg'), fit: BoxFit.cover, colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.35), BlendMode.darken), onError: (exception, stackTrace) { print('Error loading navbar background image: $exception');} ) );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      width: double.infinity,
      height: 80,
      decoration: currentDecoration,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text( /* Tu texto KAFEN */ 'KAFEN', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: currentTextColor, letterSpacing: 1.5, shadows: !isScrolled ? [ Shadow(offset: const Offset(1.0, 1.0), blurRadius: 2.0, color: Colors.black.withOpacity(0.5), ), ] : null, ), ),

          // --- Left Navigation Items ---
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
        
              const SizedBox(width: 15),
              _buildNavItem('PAQUTES', () => Get.toNamed('/paquetes'), textColor: currentTextColor),
              _buildNavItem('SOBRE NOSOTROS', () => Get.toNamed('/nosotros'), textColor: currentTextColor),
              _buildNavItem('CONTACTANOS', () => Get.toNamed('/contacto'), textColor: currentTextColor),
            ],
          ),

          // --- Center Logo/Title ---
          
          // --- Right Navigation Items (Incluye el nuevo icono) ---
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildNavItem('Home', () => Get.toNamed('/home'), textColor: currentTextColor),
            
              const SizedBox(width: 15), // Espacio antes del icono de usuario

              // --- NUEVO: Icono de Usuario ---
              // Envuelto en CompositedTransformTarget para vincular el LayerLink
              CompositedTransformTarget(
                link: userIconLayerLink, // Vincula este punto
                child: IconButton(
                  icon: Icon(
                    Icons.person_outline,
                    color: currentTextColor, // Usa el color dinámico
                    size: 28,
                  ),
                  //tooltip: 'Iniciar Sesión / Mi Cuenta',
                  onPressed: onUserIconPressed, // Llama al callback del padre
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}