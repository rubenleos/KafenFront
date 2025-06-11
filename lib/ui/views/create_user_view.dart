// lib/ui/views/create_user_view.dart (MODIFICADO para usar RegistrationController)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kafen/ui/controller/regitration_controller.dart';

// Importa tu RegistrationController (asegúrate que la ruta sea correcta)
 // Ajusta la ruta

class CreateUserView extends StatefulWidget {
  const CreateUserView({Key? key}) : super(key: key);

  @override
  State<CreateUserView> createState() => _CreateUserViewState();
}

class _CreateUserViewState extends State<CreateUserView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  // Acceder al RegistrationController
  // Se asume que RegistrationController fue registrado globalmente con Get.put()
  final RegistrationController _registrationController = Get.find<RegistrationController>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitRegistrationForm() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return; // Si el formulario no es válido, no continuar
    }

    // Llamar al método registerUser del RegistrationController
    await _registrationController.registerUser(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      password: _passwordController.text,
      context: context, // El contexto se pasa por si el controlador necesita mostrar algo directamente (aunque es mejor manejarlo con Get.snackbar)
    );
    // La lógica de navegación y SnackBars ahora está principalmente en RegistrationController
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Crea tu Cuenta',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                // --- Campos del formulario (sin cambios aquí) ---
                TextFormField(
                  controller: _nameController,
                  // ... (resto de la configuración del campo de nombre)
                   decoration: const InputDecoration(labelText: 'Nombre Completo', prefixIcon: Icon(Icons.person_outline, size: 20), border: OutlineInputBorder(), isDense: true,), keyboardType: TextInputType.name, textInputAction: TextInputAction.next, validator: (value) { if (value == null || value.trim().isEmpty) { return 'Ingresa tu nombre'; } return null; },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  // ... (resto de la configuración del campo de email)
                  decoration: const InputDecoration(labelText: 'Correo Electrónico', prefixIcon: Icon(Icons.email_outlined, size: 20), border: OutlineInputBorder(), isDense: true,), keyboardType: TextInputType.emailAddress, textInputAction: TextInputAction.next, validator: (value) { if (value == null || value.trim().isEmpty) { return 'Ingresa tu correo'; } if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value.trim())) { return 'Correo no válido';} return null; },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _phoneController,
                  // ... (resto de la configuración del campo de celular)
                  decoration: const InputDecoration(labelText: 'Número de Celular (10 dígitos)', prefixIcon: Icon(Icons.phone_outlined, size: 20), border: OutlineInputBorder(), isDense: true,), keyboardType: TextInputType.phone, inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)], textInputAction: TextInputAction.next, validator: (value) { if (value == null || value.trim().isEmpty) { return 'Ingresa tu número de celular'; } if (value.trim().length != 10) { return 'El número debe tener 10 dígitos'; } return null; },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  // ... (resto de la configuración del campo de contraseña)
                  decoration: InputDecoration(labelText: 'Contraseña', prefixIcon: const Icon(Icons.lock_outline, size: 20), border: const OutlineInputBorder(), isDense: true, suffixIcon: IconButton(icon: Icon(_passwordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20,), tooltip: _passwordVisible ? 'Ocultar contraseña' : 'Mostrar contraseña', onPressed: () => setState(() => _passwordVisible = !_passwordVisible),),), textInputAction: TextInputAction.next, validator: (value) { if (value == null || value.isEmpty) { return 'Ingresa una contraseña'; } if (value.length < 6) { return 'Debe tener al menos 6 caracteres';} return null; },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_confirmPasswordVisible,
                  // ... (resto de la configuración del campo de confirmar contraseña)
                  decoration: InputDecoration(labelText: 'Confirmar Contraseña', prefixIcon: const Icon(Icons.lock_outline, size: 20), border: const OutlineInputBorder(), isDense: true, suffixIcon: IconButton(icon: Icon(_confirmPasswordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20,), tooltip: _confirmPasswordVisible ? 'Ocultar contraseña' : 'Mostrar contraseña', onPressed: () => setState(() => _confirmPasswordVisible = !_confirmPasswordVisible),),), textInputAction: TextInputAction.done, onFieldSubmitted: (_) => _submitRegistrationForm(), validator: (value) { if (value == null || value.isEmpty) { return 'Confirma tu contraseña'; } if (value != _passwordController.text) { return 'Las contraseñas no coinciden'; } return null; },
                ),
                const SizedBox(height: 30),

                // --- Botón de Registrarse / Indicador de Carga ---
                // Usamos Obx para escuchar el estado isLoading del RegistrationController
                Obx(() {
                  return _registrationController.isLoading.value
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _submitRegistrationForm, // Llama al nuevo método
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text('REGISTRARSE'),
                        );
                }),
                const SizedBox(height: 20),

                // Botón para ir a Iniciar Sesión
                Obx(() {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    onPressed: _registrationController.isLoading.value
                        ? null // Deshabilitado si está cargando
                        : () {
                            Get.back();
                          },
                    child: const Text('¿Ya tienes cuenta? Inicia sesión'),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
