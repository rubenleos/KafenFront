import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Para SystemUiOverlayStyle
// Asegúrate que las rutas sean correctas para tus widgets personalizados
import 'package:kafen/ui/shared/custom_app_menu.dart'; // Reemplaza con tu ruta real
import 'package:kafen/ui/shared/login_overlay_content.dart'; // Reemplaza con tu ruta real
import 'dart:math' as math;

// Para el delegate

// --- Delegate para el SliverPersistentHeader ---
// Se encarga de construir y definir el tamaño del menú fijo
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child, // El widget del menú (CustomAppMenu configurado)
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // Devuelve el menú que ya viene configurado
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    // Reconstruye si cambian las alturas o el widget hijo (importante!)
    return maxHeight != oldDelegate.maxHeight ||
           minHeight != oldDelegate.minHeight ||
           child != oldDelegate.child;
  }
}


// --- MainLayout StatefulWidget ---
class MainLayout extends StatefulWidget {
  final Widget child; // El contenido de la página específica

  const MainLayout({Key? key, required this.child}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}


// --- _MainLayoutState ---
class _MainLayoutState extends State<MainLayout> {
  // Controlador para detectar el scroll
  final ScrollController _scrollController = ScrollController();
  // Estado para saber si se ha hecho scroll y cambiar estilo del menú
  bool _isScrolled = false;

  // --- Estado y Lógica para el Overlay de Login ---
  // LayerLink para conectar la posición del icono con el overlay
  final LayerLink _userIconLayerLink = LayerLink();
  // Referencia al OverlayEntry que se está mostrando (o null si no hay)
  OverlayEntry? _loginOverlayEntry;

  @override
  void initState() {
    super.initState();
    // Escuchar los eventos de scroll
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    // Limpiar recursos para evitar fugas de memoria
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _removeLoginOverlay(); // Asegurarse de quitar el overlay al destruir
    super.dispose();
  }

  // Se ejecuta cada vez que el usuario hace scroll
  void _scrollListener() {
    // Umbral para considerar que se hizo scroll (ej. 10 píxeles)
    const double scrollThreshold = 10.0;
    // Si el widget ya no está en el árbol, no hacer nada
    if (!mounted) return;

    // --- Ocultar overlay al hacer scroll ---
    if (_scrollController.offset > scrollThreshold && _loginOverlayEntry != null) {
      _removeLoginOverlay();
    }

    // Comprobar si el estado de scroll cambió
    final bool currentlyScrolled = _scrollController.offset > scrollThreshold;
    if (currentlyScrolled != _isScrolled) {
      // Actualizar estado solo si cambió, para evitar reconstrucciones innecesarias
      setState(() {
        _isScrolled = currentlyScrolled;
      });
    }
  }

  void _toggleLoginOverlay() {
    if (!mounted) return;
    // Usa setState para asegurar que la UI se actualice si es necesario
    setState(() {
      if (_loginOverlayEntry == null) {
        // Si no hay overlay visible, lo muestra
        _showLoginOverlay();
      } else {
        // Si ya hay un overlay visible, lo quita
        _removeLoginOverlay();
      }
    });
  }

  // Muestra el OverlayEntry
  // NO recibe BuildContext como parámetro, usa el 'context' de la clase State
  void _showLoginOverlay() {
    if (!mounted) return;
    // Obtener el Overlay usando el Navigator raíz (más robusto)
    // Usa el 'context' disponible en la clase State (_MainLayoutState)
    final overlay = Navigator.of(context, rootNavigator: true).overlay;
    // Comprobar si se pudo obtener el Overlay
    if (overlay == null) {
      print("Error Crítico: No se pudo obtener OverlayState desde el root Navigator.");
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
         const SnackBar(content: Text("Error al mostrar panel."), backgroundColor: Colors.red)
      );
      return;
    }

    // Crear la entrada del Overlay
    _loginOverlayEntry = OverlayEntry(
      // El builder recibe su propio contexto (overlayContext)
      builder: (overlayContext) {
        return Positioned(
          child: CompositedTransformFollower(
            link: _userIconLayerLink, // Sigue la posición del icono
            showWhenUnlinked: false, // No mostrar si el target (icono) desaparece
            // Offset para ajustar la posición (x, y) relativo al icono
            // ¡AJUSTA ESTOS VALORES PARA QUE QUEDE DONDE QUIERES!
            offset: const Offset(-260, 60), // Ej: -260 izq, 60 abajo
            // TapRegion para detectar clics FUERA del panel
            child: TapRegion(
              onTapOutside: (event) {
                // Si se hace clic fuera, cerrar el overlay
                _removeLoginOverlay();
              },
              // El contenido del overlay (formulario de login)
              child: LoginOverlayContent(
                // Pasar la función para que el contenido pueda cerrarse a sí mismo
                onClose: _removeLoginOverlay,
              ),
            ),
          ),
        );
      },
    );

    // Insertar el overlay en pantalla
    overlay.insert(_loginOverlayEntry!);
  }

  // Elimina el OverlayEntry de la pantalla
  void _removeLoginOverlay() {
    // Solo intentar quitar si existe una referencia
    if (_loginOverlayEntry != null) {
      _loginOverlayEntry!.remove(); // Quitarlo del Overlay
      _loginOverlayEntry = null; // Limpiar la referencia
      // Actualizar el estado si es necesario (por si la UI depende de esto)
      if (mounted) {
        setState(() {});
      }
    }
  }
  // --- Fin Métodos Overlay ---

  // Método build principal de _MainLayoutState
  @override
  Widget build(BuildContext context) {
    // Altura definida para el CustomAppMenu
    const double menuHeight = 80.0;

    return Scaffold(
      // AppBar solo para controlar SystemUiOverlayStyle (iconos de estado)
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 0, // El menú real está en el Sliver
        systemOverlayStyle: _isScrolled
            ? SystemUiOverlayStyle.dark // Iconos oscuros para menú blanco
            : SystemUiOverlayStyle.light, // Iconos claros para menú transparente
      ),
      // CustomScrollView para contenido scrollable con header fijo
      body: CustomScrollView(
        controller: _scrollController, // Conectar el controlador
        slivers: <Widget>[
          // --- Header Fijo (SliverPersistentHeader) ---
          SliverPersistentHeader(
            pinned: true, // Mantiene el header fijo arriba al hacer scroll
            delegate: _SliverAppBarDelegate(
              minHeight: menuHeight, // Altura mínima y máxima son iguales
              maxHeight: menuHeight,
              // --- Construye CustomAppMenu ---
              // Pasa el estado de scroll, el LayerLink y el callback correctos
              child: CustomAppMenu(
                  isScrolled: _isScrolled,
                  userIconLayerLink: _userIconLayerLink,
                  // Pasamos la referencia a _toggleLoginOverlay (VoidCallback)
                  onUserIconPressed: _toggleLoginOverlay,
              ),
            ),
          ),
          // --- Contenido Principal Scrollable ---
          SliverToBoxAdapter(
            // GestureDetector para cerrar el overlay al tocar el contenido principal
            child: GestureDetector(
              onTap: _removeLoginOverlay, // Llama a la función de cerrar
              behavior: HitTestBehavior.translucent, // Captura taps en áreas vacías
              // El widget hijo que contiene el contenido real de la página
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}