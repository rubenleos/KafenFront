import 'package:flutter/material.dart';

class AboutUsSection extends StatelessWidget {
  const AboutUsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    // Define un ancho máximo para el contenido en pantallas muy grandes
    const double maxContentWidth = 1100;

    return Container(
      // Un color de fondo sutil si quieres diferenciar la sección
      // color: Colors.grey[100],
      padding: const EdgeInsets.symmetric(vertical: 80.0), // Espacio vertical generoso
      child: Center( // Centra el contenido limitado por ConstrainedBox
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: maxContentWidth),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0), // Padding horizontal
            child: Column(
              children: [
                // --- Línea Divisora Superior ---
                const Divider(
                  // thickness: 0.8, // Grosor de la línea
                  // indent: 50, // Espacio antes de la línea
                  // endIndent: 50, // Espacio después de la línea
                  // color: Colors.grey[300], // Color
                ),
                const SizedBox(height: 50), // Espacio antes del título

                // --- Título Principal ---
                Text(
                  'Kafen nació de risas\ny sueños dichos en voz alta.',
                  textAlign: TextAlign.center,
                  style: textTheme.displaySmall?.copyWith( // Un estilo de título grande
                    // Puedes especificar una fuente Serif si la tienes configurada:
                    // fontFamily: 'TuFuenteSerif',
                    fontWeight: FontWeight.w500,
                    height: 1.4, // Interlineado
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 60), // Espacio antes del contenido principal

                // --- Layout Responsivo (Imagen + Texto) ---
                LayoutBuilder(
                  builder: (context, constraints) {
                    final bool isMobile = constraints.maxWidth < 700; // Ajusta este breakpoint si es necesario
                    final double imageWidth = isMobile ? constraints.maxWidth * 0.8 : constraints.maxWidth * 0.35; // Ancho de imagen
                    final double spacing = isMobile ? 40 : 50; // Espacio entre elementos

                    if (isMobile) {
                      // --- Layout Móvil (Vertical) ---
                      return Column(
                        children: [
                          _buildAboutImage(width: imageWidth),
                          SizedBox(height: spacing),
                          _buildAboutText(context, isMobile: true),
                        ],
                      );
                    } else {
                      // --- Layout Escritorio (Horizontal) ---
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start, // Alinear arriba
                        children: [
                          // Columna Izquierda: Imagen
                          SizedBox( // Controla el tamaño de la imagen
                            width: imageWidth,
                            child: _buildAboutImage(width: imageWidth),
                          ),
                          SizedBox(width: spacing), // Espacio entre columnas
                          // Columna Derecha: Texto (expandida)
                          Expanded(
                            child: _buildAboutText(context, isMobile: false),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Widget Helper para la Imagen ---
  Widget _buildAboutImage({required double width}) {
    return ClipRRect( // Para bordes redondeados si los quieres
      borderRadius: BorderRadius.circular(8.0),
      child: Image.asset(
        // Asegúrate que esta ruta es correcta en tu pubspec.yaml y assets
        'assets/images/about_us.jpg', // <--- ¡CAMBIA ESTA RUTA!
        fit: BoxFit.cover,
        width: width,
        // Altura opcional, si quieres forzarla. BoxFit.cover la ajustará.
        // height: width * 1.5, // Ejemplo de proporción alto/ancho
         errorBuilder: (context, error, stackTrace) => Container(
           width: width,
           height: width * 1.2, // Mantén una altura similar
           color: Colors.grey[200],
           child: Center(child: Icon(Icons.image_not_supported, color: Colors.grey[400])),
         ),
      ),
    );
  }

  // --- Widget Helper para el Bloque de Texto ---
  Widget _buildAboutText(BuildContext context, {required bool isMobile}) {
     final textTheme = Theme.of(context).textTheme;
     final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          'Somos Karli y Fernanda, dos amigas que creyeron en la magia de convertir una idea en un espacio donde el tiempo se detiene, el movimiento fluye y lo único que importa eres tú.',
          textAlign: isMobile ? TextAlign.center : TextAlign.left, // O TextAlign.justify
          style: textTheme.bodyLarge?.copyWith(
            height: 1.6, // Interlineado
            fontSize: 16,
            color: colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 15), // Espacio
        Text(
          'Este estudio fue diseñado con el mismo cuidado con el que imaginamos cada detalle: desde el recibidor cálido y con propósito, atención que se siente y pequeños lujos que hacen la diferencia.',
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
           style: textTheme.bodyLarge?.copyWith(
            height: 1.6,
            fontSize: 16,
            color: colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
         const SizedBox(height: 15),
         Text(
          'Te invitamos a moverte a tu ritmo, a respirar profundo y a sentirte como en casa.',
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
           style: textTheme.bodyLarge?.copyWith(
            height: 1.6,
            fontSize: 16,
            color: colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
         const SizedBox(height: 15),
         Text(
          'Porque esto, al final, es una extensión de nuestra amistad, y queremos compartirla contigo.',
          textAlign: isMobile ? TextAlign.center : TextAlign.left,
           style: textTheme.bodyLarge?.copyWith(
            height: 1.6,
            fontSize: 16,
            color: colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 30), // Espacio antes de la firma

        // --- Firma ---
        Align(
          // Alinear a la derecha en escritorio, centrado en móvil
          alignment: isMobile ? Alignment.center : Alignment.centerRight,
          child: Text(
            'Karli & Fer',
             style: textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic, // Cursiva para la firma
                color: colorScheme.onSurface.withOpacity(0.7),
             ),
          ),
        ),
      ],
    );
  }
}