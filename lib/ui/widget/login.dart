import 'package:flutter/material.dart';

class LoginOverlayContent extends StatefulWidget {
  final VoidCallback onClose; // Callback para cerrar el overlay

  const LoginOverlayContent({
    Key? key,
    required this.onClose,
    // Podrías añadir más callbacks aquí:
    // final VoidCallback? onLoginSuccess;
    // final VoidCallback? onCreateUser;
  }) : super(key: key);

  @override
  _LoginOverlayContentState createState() => _LoginOverlayContentState();
}

class _LoginOverlayContentState extends State<LoginOverlayContent> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _performLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      // --- TU LÓGICA DE LOGIN AQUÍ ---
      await Future.delayed(const Duration(seconds: 1)); // Simulación
      print('Login con: ${_emailController.text}');
      // --- FIN LÓGICA ---
      setState(() => _isLoading = false);

      // Si es exitoso, cierra el overlay
      widget.onClose(); // Llama al callback del padre para cerrar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login exitoso (simulado)'), backgroundColor: Colors.green),
      );
    }
  }

  void _navigateToCreateUser() {
    widget.onClose(); // Cierra el overlay actual
    // --- TU LÓGICA PARA IR A REGISTRO AQUÍ ---
    print('Navegar a Crear Usuario...');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ir a Crear Usuario (no implementado)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Usamos Material para darle fondo, sombra y bordes redondeados
    return Material(
      elevation: 8.0, // Sombra
      borderRadius: BorderRadius.circular(12.0), // Bordes redondeados
      child: Container(
         width: 300, // Ancho fijo para el panel de login
         padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white, // Fondo blanco
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Form( // Quitamos el SingleChildScrollView, asumimos que cabe
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text('Iniciar Sesión', style: Theme.of(context).textTheme.titleLarge, textAlign: TextAlign.center,),
              const SizedBox(height: 20),
              // --- Campo de Email ---
              TextFormField(
                 controller: _emailController,
                 decoration: const InputDecoration(
                   labelText: 'Correo Electrónico',
                   prefixIcon: Icon(Icons.email_outlined),
                   border: OutlineInputBorder(),
                   isDense: true, // Más compacto
                 ),
                 keyboardType: TextInputType.emailAddress,
                 textInputAction: TextInputAction.next,
                 validator: (value) { /* ... validación email ... */
                   if (value == null || value.trim().isEmpty || !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) { return 'Correo inválido'; } return null;
                 },
              ),
              const SizedBox(height: 12),
              // --- Campo de Contraseña ---
              TextFormField(
                 controller: _passwordController,
                 obscureText: !_passwordVisible,
                 decoration: InputDecoration(
                   labelText: 'Contraseña',
                   prefixIcon: const Icon(Icons.lock_outline),
                   border: const OutlineInputBorder(),
                   isDense: true, // Más compacto
                   suffixIcon: IconButton(
                     icon: Icon(_passwordVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20,),
                     onPressed: () => setState(() => _passwordVisible = !_passwordVisible),
                   ),
                 ),
                 textInputAction: TextInputAction.done,
                 onFieldSubmitted: (_) => _isLoading ? null : _performLogin(),
                  validator: (value) { /* ... validación contraseña ... */
                    if (value == null || value.isEmpty) { return 'Ingresa tu contraseña';} return null;
                  },
              ),
              const SizedBox(height: 25),
              // --- Botón Login ---
              _isLoading
                 ? const Center(child: SizedBox(height: 24, width: 24, child: CircularProgressIndicator(strokeWidth: 3)))
                 : ElevatedButton(
                     onPressed: _performLogin,
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 10)),
                     child: const Text('INICIAR SESIÓN'),
                   ),
              const SizedBox(height: 10),
              // --- Botón Crear Usuario ---
              TextButton(
                 onPressed: _isLoading ? null : _navigateToCreateUser,
                 child: const Text('Crear usuario'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}