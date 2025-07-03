import 'package:flutter/material.dart' hide CarouselController; // Oculta el CarouselController de Material
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kafen/ui/shared/abouts_us.dart';
import 'package:kafen/ui/shared/foot.dart';
import 'package:kafen/ui/widget/call_action_banner.dart';

import '../widget/card.dart'; // Importa el paquete del carrusel

// Asegúrate de tener GetX importado si lo usas para navegación en otros botones (no usado en este snippet)
// import 'package:get/get.dart';

// --- CustomAppMenu (Incluido solo para referencia, no se usa directamente aquí) ---
// (El código de CustomAppMenu se omite aquí por brevedad, asumiendo que existe en otro archivo)
// import 'package:kafen/ui/shared/custom_app_menu.dart';


//============================================================================
// HomeView Widget (Anteriormente HomePage)
//============================================================================
class  ContactoView extends StatefulWidget {
  const ContactoView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ContactoViewState createState() => _ContactoViewState();
}

class _ContactoViewState extends State<ContactoView> {
  // --- Lista de rutas de imágenes para el carrusel ---
  // IMPORTANTE: Reemplaza estas rutas con las de tus imágenes reales
  final List<String> _carouselImages = [
    'assets/images/carousel/image1.jpg',
    'assets/images/carousel/image2.jpg',
    'assets/images/carousel/image3.jpg',
    'assets/images/carousel/image4.jpg',
  ];

  // --- Controlador y estado para los indicadores (opcional) ---
final CarouselSliderController _carouselController = CarouselSliderController();
  int _currentCarouselIndex = 0;

  @override
  Widget build(BuildContext context) {
    // --- Se devuelve la Columna original con el contenido ---
    // Esta Columna será el 'child' dentro del SliverToBoxAdapter del MainLayout
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
         // --- El SizedBox inicial ya no es necesario con CustomScrollView ---
         // const SizedBox(height: 100),

         // --- Contenido de HomeView ---
         

         // --- Contenedor para el Carrusel y las Flechas ---
         Stack(
           alignment: Alignment.center, // Centra las flechas verticalmente por defecto
           children: [
             // --- Widget CarouselSlider ---
             CarouselSlider(
              items: _carouselImages.map((imagePath) {
  return Builder(
    builder: (BuildContext context) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 15.0),
        width: double.infinity,
        height: 400,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Image.asset(
                imagePath,
                fit: BoxFit.fitWidth,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 60, color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Descubre nuestra galería',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: () {
                      // Acción del botón
                    },
                    child: const Text('Reserva Ahora'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}).toList(),
              
               carouselController: _carouselController,
               options: CarouselOptions(
                 // --- Opciones Modificadas ---
                 height: 620.0, // Altura del carrusel (ajusta según necesites)
                 autoPlay: true,
            enlargeCenterPage: true,
            aspectRatio: 16/ 9,
            viewportFraction: 1.1,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,

                 // enlargeCenterPage: false, // Ya no es relevante con viewportFraction: 1.0
                 // aspectRatio: 2.0, // Puedes usar height o aspectRatio
                 initialPage: 0, // Empieza en la primera imagen
                 onPageChanged: (index, reason) {
                   setState(() {
                     _currentCarouselIndex = index;
                   });
                 },
               ),
             ),

             // --- Flecha Izquierda ---
             Positioned(
               left: 15, // Distancia desde la izquierda
               child: IconButton(
                 icon: const Icon(Icons.arrow_back_ios_new),
                 color: Colors.white.withOpacity(0.7), // Color semi-transparente
                 iconSize: 20,
                 style: IconButton.styleFrom(
                   backgroundColor: Colors.black.withOpacity(0.1), // Fondo sutil
                   shape: const CircleBorder(),
                   padding: const EdgeInsets.all(8),
                 ),
                 onPressed: () => _carouselController.previousPage(
                    duration: const Duration(milliseconds: 300), curve: Curves.linear
                 ),
                 tooltip: 'Anterior', // Texto de ayuda para accesibilidad web
               ),
             ),

             // --- Flecha Derecha ---
             Positioned(
               right: 15, // Distancia desde la derecha
               child: IconButton(
                 icon: const Icon(Icons.arrow_forward_ios),
                  color: Colors.white.withOpacity(0.7), // Color semi-transparente
                 iconSize:20,
                 style: IconButton.styleFrom(
                   backgroundColor: Colors.black.withOpacity(0.1), // Fondo sutil
                   shape: const CircleBorder(),
                   padding: const EdgeInsets.all(8),
                 ),
                 onPressed: () => _carouselController.nextPage(
                    duration: const Duration(milliseconds: 300), curve: Curves.linear
                 ),
                 tooltip: 'Siguiente', // Texto de ayuda para accesibilidad web
               ),
             ),
           ],
         ),
     // Espacio entre carrusel e indicadores

         // --- Indicadores (Puntos) ---
         // (Los indicadores pueden ser menos necesarios con flechas, pero los dejamos)
         

         const SizedBox(height: 5), // Espacio después del carrusel
   //   

Padding(
  padding: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 30.0),
  child: Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Imagen circular decorativa
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/circulo.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey[200],
                child: const Icon(Icons.broken_image, size: 60, color: Colors.grey),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Título central
        const Text(
          'Aquí, el cuerpo se fortalece\ny la mente encuentra calma.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 20),

        // Texto descriptivo
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Text(
            'Conoce Kafen, tu refugio de movimiento consciente, un espacio diseñado para que te muevas a tu ritmo, con atención personalizada, calma y propósito.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 15,
                  color: Colors.grey[800],
                  height: 1.5,
                ),
          ),
        ),
        const SizedBox(height: 25),

        // Botón estilo enlace
        TextButton(
          onPressed: () {
            // Scroll o navegación aquí
          },
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).primaryColor,
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              letterSpacing: 1.1,
              decoration: TextDecoration.underline,
            ),
          ),
          child: const Text('Nuestros Servicios'),
        ),
      ],
    ),
  ),
),
    Container(
  width: double.infinity,
  color: const Color(0xFFB6A993), // Fondo beige
  padding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 20.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      const Text(
        'Nuestras Clases',
        style: TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 40),
      Wrap(
        alignment: WrapAlignment.center,
        spacing: 40,
        runSpacing: 40,
        children: [
          ClassCard(
  image: 'assets/images/card1.jpg',
  label: 'Pilates Reformer',
  backText: 'Clases diseñadas para fortalecer, alinear y reconectar con tu cuerpo. Movimiento consciente, atención personalizada y un ambiente que inspira..',
),
ClassCard(
  image: 'assets/images/card2.jpg',
  label: 'Nutricion',
  backText: 'Guiadas por nuestra coach y nutrióloga certificada. Porque el bienestar también empieza desde adentro.',
),
SizedBox(height: 40),
  	 
        ],
      ),
    ],
  ),
),
 AboutUsSection(),
       // <-- Añade el banner aquí
    SizedBox(height: 20),
 CallToActionBanner(),
         // --- Ejemplo: Sección simple de texto ---
        AppFooter()

         // --- Aquí puedes añadir más secciones si lo necesitas ---

      ],
    );
  }


  
}
