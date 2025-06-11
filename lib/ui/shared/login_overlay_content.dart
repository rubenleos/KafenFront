import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Asegúrate de importar tu LoginController

import 'package:kafen/ui/controller/login_controler.dart'; // Ajusta esta ruta a tu proyecto

class LoginOverlayContent extends StatefulWidget {
  final VoidCallback onClose;

  const LoginOverlayContent({
    Key? key,
    required this.onClose,
  }) : super(key: key);

  @override
  State<LoginOverlayContent> createState() => _LoginOverlayContentState();
}

class _LoginOverlayContentState extends State<LoginOverlayContent> {
  final _formKey = GlobalKey<FormState>();
  // Obtén (o crea) la instancia de tu LoginController
  // Get.put() crea una instancia si no existe, o Get.find() la busca si ya fue creada en otro lado.
  // Para un overlay/dialog, Get.put() aquí puede ser apropiado si es su único contexto,
  // o Get.find() si el controller es más global.
  final LoginController loginController = Get.put(LoginController());
  
  bool _passwordVisible = false;

  @override
  void dispose() {
    // GetX maneja el dispose de los controladores de texto si el LoginController se elimina.
    // Si usaste Get.put() aquí y este widget es la única referencia, puedes considerar Get.delete<LoginController>();
    // si quieres que se limpie inmediatamente al cerrar el overlay. 
    // Sin embargo, LoginController.onClose() ya limpia sus propios TextEditingControllers.
    super.dispose();
  }

  // --- Lógica de Inicio de Sesión (AHORA USA EL CONTROLLER) ---
  Future<void> _handleLoginAttempt() async {
    // Validar el formulario
    if (!(_formKey.currentState?.validate() ?? false)) {
      return; // Si no es válido, no hacer nada
    }

    // Llama al método del controlador para el login real.
    // El controlador internamente usa loginController.emailController.text y loginController.passwordController.text
    bool loginExitoso = await loginController.performRealLogin();

    // Si ya no estamos en el árbol de widgets, no continuar
    if (!mounted) return;

    if (loginExitoso) {
      // Si el login es exitoso, llamar al callback para cerrar el overlay
      widget.onClose();
      // El SnackBar de éxito ahora se muestra desde el LoginController.
    } else {
      // El SnackBar de error ahora se muestra desde el LoginController.
    }
  }

  // --- Lógica para ir a Crear Usuario ---
  void _navigateToCreateUser() {
    // Primero cerramos este overlay
    widget.onClose();
    // Navega usando GetX
    Get.toNamed('/register'); // Asegúrate que esta ruta esté definida en tu GetMaterialApp
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8.0, 
      borderRadius: BorderRadius.circular(12.0), 
      child: Container(
        width: 320, 
        padding: const EdgeInsets.all(24.0), 
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Form(
          key: _formKey, 
          child: Column(
            mainAxisSize: MainAxisSize.min, 
            crossAxisAlignment: CrossAxisAlignment.stretch, 
            children: <Widget>[
              Text(
                'Iniciar Sesión',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24), 
              TextFormField(
                // USA EL CONTROLADOR DEL LOGINCONTROLLER
                controller: loginController.emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo Electrónico',
                  prefixIcon: Icon(Icons.email_outlined, size: 20),
                  border: OutlineInputBorder(),
                  isDense: true, 
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next, 
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Ingresa tu correo';
                  }
                  // Usar GetUtils para una validación de email más robusta
                  if (!GetUtils.isEmail(value.trim())) {
                    return 'Correo no válido';
                  }
                  return null; 
                },
              ),
              const SizedBox(height: 16), 
              TextFormField(
                // USA EL CONTROLADOR DEL LOGINCONTROLLER
                controller: loginController.passwordController,
                obscureText: !_passwordVisible, 
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: const Icon(Icons.lock_outline, size: 20),
                  border: const OutlineInputBorder(),
                  isDense: true,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                    ),
                    tooltip: _passwordVisible ? 'Ocultar contraseña' : 'Mostrar contraseña',
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                textInputAction: TextInputAction.done, 
                onFieldSubmitted: (_) => loginController.isLoading.value ? null : _handleLoginAttempt(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa tu contraseña';
                  }
                  // La validación de longitud de contraseña se maneja mejor en el LoginController
                  // o la API se encarga (FastAPI ya lo hace con min_length).
                  return null; 
                },
              ),
              const SizedBox(height: 30), 
              // Reacciona al estado de carga del LoginController
              Obx(() => loginController.isLoading.value
                  ? const Center(
                      child: SizedBox( 
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 3),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: _handleLoginAttempt, 
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('INICIAR SESIÓN'),
                    )),
              const SizedBox(height: 12), 
              Obx(() => TextButton( // Deshabilita el botón si está cargando
                    onPressed: loginController.isLoading.value ? null : _navigateToCreateUser,
                    child: const Text('Crear usuario'),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}