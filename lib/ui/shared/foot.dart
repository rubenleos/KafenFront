import 'package:flutter/material.dart';
// Importa el paquete para lanzar URLs
import 'package:url_launcher/url_launcher.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({Key? key}) : super(key: key);

  // --- Función auxiliar para lanzar URLs de forma segura ---
  Future<void> _launchUrlHelper(String urlString) async {
    final Uri url = Uri.parse(urlString);
    // Usamos canLaunchUrl por si acaso, aunque launchUrl ya hace verificaciones
    if (await canLaunchUrl(url)) {
      // Intentar abrir fuera de la app (en navegador, app de email/teléfono)
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        print('Error: No se pudo lanzar $urlString en modo externo.');
      }
    } else {
      print('Error: No se puede lanzar la URL $urlString');
      // Aquí podrías mostrar un mensaje al usuario si falla
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // Colores para texto e iconos sobre fondo oscuro
    final Color footerTextColor = Colors.white.withOpacity(0.85);
    final Color footerIconColor = Colors.white.withOpacity(0.7);
    final Color footerLinkColor = Colors.white;
    final Color copyrightTextColor = Colors.white.withOpacity(0.5);

    return Container(
      // Color de fondo del footer
      color: const Color(0xFF111111), // Casi negro, puedes ajustarlo
      width: double.infinity, // Asegura que ocupe todo el ancho
      padding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 40.0), // Padding general
      child: Column(
        children: [
          // --- Contenido Principal (Responsivo) ---
          LayoutBuilder(
            builder: (context, constraints) {
              // Define el punto de quiebre para cambiar de layout
              final bool isMobile = constraints.maxWidth < 850;
              final double columnSpacing = isMobile ? 0 : 60; // Espacio entre columnas en desktop
              final double rowSpacing = isMobile ? 45 : 0; // Espacio entre filas en mobile

              if (isMobile) {
                // --- Layout Móvil (Columnas apiladas) ---
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center, // Centrar contenido en móvil
                  children: [
                    _buildLogoColumn(context, footerTextColor, footerIconColor, isMobile: true),
                    SizedBox(height: rowSpacing),
                    _buildNavigationColumn(context, footerLinkColor, isMobile: true),
                    SizedBox(height: rowSpacing),
                    _buildContactColumn(context, footerTextColor, footerIconColor, isMobile: true),
                  ],
                );
              } else {
                // --- Layout Escritorio (Columnas en fila) ---
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start, // Alinear columnas arriba
                  children: [
                    // Columna 1: Logo (más ancha)
                    Expanded(
                      flex: 3, // Proporción de ancho
                      child: _buildLogoColumn(context, footerTextColor, footerIconColor, isMobile: false),
                    ),
                    SizedBox(width: columnSpacing),
                    // Columna 2: Navegación (estrecha)
                    Expanded(
                      flex: 2,
                      child: _buildNavigationColumn(context, footerLinkColor, isMobile: false),
                    ),
                    SizedBox(width: columnSpacing),
                    // Columna 3: Contacto (ancho medio)
                    Expanded(
                      flex: 3,
                      child: _buildContactColumn(context, footerTextColor, footerIconColor, isMobile: false),
                    ),
                  ],
                );
              }
            },
          ),

          // --- Espacio antes del Copyright ---
          const SizedBox(height: 70),

          // --- Línea Divisora (Opcional) ---
          // Divider(color: copyrightTextColor.withOpacity(0.4), height: 1),
          // const SizedBox(height: 30),

          // --- Texto de Copyright ---
          Text(
            'Copyright © ${DateTime.now().year} Kafen. Powered by Fer', // Año dinámico
            textAlign: TextAlign.center,
            style: textTheme.bodySmall?.copyWith(color: copyrightTextColor),
          ),
        ],
      ),
    );
  }

  // --- Columna 1: Logo, Descripción, Redes Sociales ---
  Widget _buildLogoColumn(BuildContext context, Color textColor, Color iconColor, {required bool isMobile}) {
    final CrossAxisAlignment align = isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start;
    final TextAlign textAlign = isMobile ? TextAlign.center : TextAlign.left;

    return Column(
      crossAxisAlignment: align,
      children: [
        // --- Logo ---
        Image.asset(
          'assets/images/kafenlogo.jpeg', // <-- ¡CAMBIA ESTA RUTA POR LA DE TU LOGO!
          height: 50, // Ajusta el tamaño según tu logo
          // Puedes añadir color si es una imagen que lo permita (ej. SVG blanco)
          // color: Colors.white,
          filterQuality: FilterQuality.high, // Buena calidad de imagen
        ),
        const SizedBox(height: 25),

        // --- Descripción ---
        Text(
          'Somos un estudio de pilates, movimiento y bienestar que cultiva una experiencia bajo la intención de hacer ejercicio.',
          textAlign: textAlign,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: textColor.withOpacity(0.8),
                height: 1.6, // Interlineado
              ),
        ),
        const SizedBox(height: 20),

        // --- Icono Instagram ---
        IconButton(
          icon: const Icon(Icons.camera_alt_outlined), // Puedes cambiar por un icono específico de Instagram
          color: iconColor,
          iconSize: 28,
          tooltip: 'Síguenos en Instagram',
          onPressed: () {
            // --- ¡CAMBIA ESTA URL POR TU PERFIL DE INSTAGRAM! ---
            _launchUrlHelper('https://www.instagram.com/kafenmx/');
          },
          // Estilo para quitar padding extra si es necesario
           padding: EdgeInsets.zero,
           constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  // --- Columna 2: Enlaces de Navegación ---
  Widget _buildNavigationColumn(BuildContext context, Color linkColor, {required bool isMobile}) {
    final CrossAxisAlignment align = isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: align,
      children: [
        _footerLink(context, 'SOBRE NOSOTROS', '/about', linkColor), // Ajusta la ruta/acción
        const SizedBox(height: 12),
        _footerLink(context, 'PAQUETES', '/packages', linkColor),
        const SizedBox(height: 12),
        _footerLink(context, 'CONTÁCTANOS', '/contact', linkColor),
      ],
    );
  }

  // Widget auxiliar para crear un enlace de texto en el footer
  Widget _footerLink(BuildContext context, String text, String routeOrAction, Color color) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: color, // Color del texto
        padding: const EdgeInsets.symmetric(vertical: 4), // Padding vertical para área de toque
        minimumSize: Size.zero, // Tamaño mínimo
        tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Ajusta el área de toque
        alignment: Alignment.centerLeft, // Alineación interna
      ),
      onPressed: () {
        // --- Aquí va tu lógica de navegación ---
        // Ejemplo: Si usas rutas nombradas: Navigator.pushNamed(context, routeOrAction);
        // Ejemplo: Si usas page controller: pageController.animateToPage(...);
        // Ejemplo: Si usas scroll controller: scrollController.animateTo(...);
        print('Navegar a: $routeOrAction');
      },
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          letterSpacing: 1.1, // Espaciado entre letras
        ),
      ),
    );
  }

  // --- Columna 3: Información de Contacto ---
  Widget _buildContactColumn(BuildContext context, Color textColor, Color iconColor, {required bool isMobile}) {
    final CrossAxisAlignment align = isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    return Column(
      crossAxisAlignment: align,
      children: [
        _contactItem(
          context,
          icon: Icons.location_on_outlined,
          // --- ¡VERIFICA Y CORRIGE LA DIRECCIÓN! ---
          // Saltillo está en Coahuila (Coah.), no San Luis Potosí (S.L.P.)
          text: 'Gral. M. Alvarez 115, Llano Blanco, 25270 Saltillo, Coah.',
          textColor: textColor,
          iconColor: iconColor,
          onTap: () {
            // URL para abrir en Google Maps (asegúrate que la dirección sea correcta)
            _launchUrlHelper('https://www.google.com/maps/search/?api=1&query=Gral.+M.+Alvarez+115,+Llano+Blanco,+25270+Saltillo,+Coah.');
          },
        ),
        const SizedBox(height: 18),
        _contactItem(
          context,
          icon: Icons.phone_outlined,
          // --- ¡CAMBIA "hola estudio" POR EL NÚMERO REAL! ---
          text: '+52 (XXX) XXX-XXXX',
          textColor: textColor,
          iconColor: iconColor,
          onTap: () {
             // --- ¡CAMBIA XXXXX POR EL NÚMERO REAL para el enlace tel:! ---
            _launchUrlHelper('tel:+52XXXXXXXXXX');
          },
        ),
        const SizedBox(height: 18),
        _contactItem(
          context,
          icon: Icons.email_outlined,
           // --- ¡CONFIRMA LA DIRECCIÓN DE EMAIL! ---
          text: 'holakafen@studio.com',
          textColor: textColor,
          iconColor: iconColor,
          onTap: () {
             // --- ¡CONFIRMA LA DIRECCIÓN DE EMAIL para el enlace mailto:! ---
            _launchUrlHelper('mailto:holakafen@studio.com');
          },
        ),
      ],
    );
  }

  // Widget auxiliar para mostrar un ítem de contacto (Icono + Texto)
  Widget _contactItem(BuildContext context, {required IconData icon, required String text, required Color textColor, required Color iconColor, VoidCallback? onTap}) {
    // El contenido visual (Icono y Texto)
    Widget content = Row(
      mainAxisSize: MainAxisSize.min, // Evita que la Row ocupe más espacio del necesario
      crossAxisAlignment: CrossAxisAlignment.start, // Alinea icono y texto arriba
      children: [
        Icon(icon, color: iconColor, size: 18), // Tamaño del icono
        const SizedBox(width: 12), // Espacio entre icono y texto
        // Flexible para que el texto haga wrap si es muy largo
        Flexible(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: textColor,
                  height: 1.5, // Interlineado
                ),
          ),
        ),
      ],
    );

    // Si tiene acción onTap, envolver en InkWell para hacerlo clickeable
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        hoverColor: Colors.white.withOpacity(0.08), // Efecto hover sutil
        borderRadius: BorderRadius.circular(4), // Bordes redondeados para el hover
        child: Padding(
          // Padding para aumentar el área de toque
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 2.0),
          child: content,
        ),
      );
    } else {
      // Si no es clickeable, solo devolver el contenido con padding
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: content,
      );
    }
  }
}