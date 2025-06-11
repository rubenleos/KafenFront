import 'package:flutter/material.dart';
import 'dart:math' show pi; // Necesitamos pi para la rotación

class ClassCard extends StatefulWidget { // Cambiado a StatefulWidget
  final String image;
  final String label;
  final String backText; // Texto que se mostrará al voltear

  const ClassCard({
    Key? key, // Siempre es buena idea añadir Key a los constructores
    required this.image,
    required this.label,
    required this.backText, // Hacemos el texto trasero requerido
  }) : super(key: key);

  @override
  _ClassCardState createState() => _ClassCardState();
}

class _ClassCardState extends State<ClassCard> with SingleTickerProviderStateMixin { // Necesario para AnimationController
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFrontVisible = true; // Para saber qué lado mostrar

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600), // Duración de la animación de volteo
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    )..addListener(() {
        // Cambiar la visibilidad a mitad de la animación
        if (_animation.value >= 0.5 && _isFrontVisible) {
          setState(() {
            _isFrontVisible = false;
          });
        } else if (_animation.value < 0.5 && !_isFrontVisible) {
           setState(() {
             _isFrontVisible = true;
           });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose(); // Liberar recursos
    super.dispose();
  }

  void _handleHover(bool hovering) {
    if (hovering) {
      _controller.forward(); // Inicia la animación hacia adelante al entrar
    } else {
      _controller.reverse(); // Inicia la animación hacia atrás al salir
    }
  }

  @override
  Widget build(BuildContext context) {
    // Usamos MouseRegion para detectar el hover
    return MouseRegion(
      onEnter: (_) => _handleHover(true),
      onExit: (_) => _handleHover(false),
      cursor: SystemMouseCursors.click, // Cambia el cursor para indicar interactividad
      child: SizedBox(
        width: 220,
        height: 300,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            // Calcula el ángulo de rotación (0 a PI = 180 grados)
            final angle = _animation.value * pi;
            // Aplica la transformación de rotación en el eje Y
            // Añadimos una pequeña perspectiva para el efecto 3D
            final transform = Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Perspectiva
              ..rotateY(angle);

            return Transform(
              transform: transform,
              alignment: Alignment.center, // El punto sobre el que rota
              child: _isFrontVisible
                  ? _buildFrontSide() // Muestra la cara frontal
                  : Transform( // Voltea la cara trasera para que se vea correctamente
                      transform: Matrix4.identity()..rotateY(pi), // Rota 180 grados
                      alignment: Alignment.center,
                      child: _buildBackSide(), // Muestra la cara trasera
                    ),
            );
          },
        ),
      ),
    );
  }

  // --- Cara Frontal ---
  Widget _buildFrontSide() {
    // Mismo código que tenías, pero usando widget.image y widget.label
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            widget.image, // Acceder via widget.
            fit: BoxFit.cover,
            width: 220,
            height: 300,
            errorBuilder: (context, error, stackTrace) => Container(
              decoration: BoxDecoration(
                 color: Colors.grey[300],
                 borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: Icon(Icons.broken_image, size: 40, color: Colors.grey[600])),
            ),
          ),
        ),
        // Superposición oscura
        Container(
          width: 220,
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient( // Un gradiente sutil puede verse mejor
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                 Colors.black.withOpacity(0.1),
                 Colors.black.withOpacity(0.5),
                 Colors.black.withOpacity(0.7),
              ],
              stops: const [0.0, 0.6, 1.0]
            )
            // color: Colors.black.withOpacity(0.3), // Alternativa simple
          ),
        ),
        // Etiqueta
        Positioned(
          bottom: 20,
          left: 15, // Un poco de padding lateral
          right: 15,
          child: Text(
            widget.label, // Acceder via widget.
            textAlign: TextAlign.center, // Centrar el texto
            style: Theme.of(context).textTheme.titleMedium?.copyWith( // Usar tema
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  // fontSize: 14, // El tema ya podría definir un tamaño adecuado
                  shadows: [ // Sombra sutil para legibilidad
                     Shadow(
                       blurRadius: 4.0,
                       color: Colors.black.withOpacity(0.5),
                       offset: const Offset(1.0, 1.0),
                     ),
                  ]
            ),
          ),
        ),
      ],
    );
  }

  // --- Cara Trasera ---
  Widget _buildBackSide() {
    return Container(
      width: 220,
      height: 300,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant, // Un color de fondo del tema
        borderRadius: BorderRadius.circular(12),
        boxShadow: [ // Sombra sutil para destacar la tarjeta
           BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
           )
        ]
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0), // Padding interno
        child: Center(
          child: Text(
            widget.backText, // Texto trasero del widget
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                 color: Theme.of(context).colorScheme.onSurfaceVariant, // Color de texto del tema
                 height: 1.4 // Interlineado
            ),
          ),
        ),
      ),
    );
  }
}