// lib/main.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// --- IMPORTANTE: Añade esta importación ---
import 'package:intl/date_symbol_data_local.dart';
import 'package:kafen/bindings/citas.binding.dart';

// Importa tus dependencias y archivos de ruta como ya los tienes
import 'package:kafen/provider/authprovider.dart';
import 'package:kafen/ui/controller/regitration_controller.dart';
import 'package:kafen/ui/layout/main_layout.dart';
import 'package:kafen/ui/pages/not_found.dart';
import 'package:kafen/ui/views/citas.dart';
import 'package:kafen/ui/views/counter_provider_view.dart';
import 'package:kafen/ui/views/counter_view.dart';
import 'package:kafen/ui/views/create_user_view.dart';
import 'package:kafen/ui/views/home_view.dart';

// Asegúrate de tener esta importación

// --- PASO 1: Convierte 'main' en una función 'async' ---
void main() async {
  // --- PASO 2: Asegura que los bindings de Flutter estén listos ---
  // Esto es obligatorio si usas 'await' antes de 'runApp()'.
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // --- PASO 3: Inicializa los datos de formato de fecha para español ---
  // Esta es la línea que resuelve el error.
  await initializeDateFormatting('es_MX', null);

  // El resto de tu configuración de GetX
  Get.put(AuthProvider());
  Get.put(RegistrationController());

  runApp(const MyApp()); // Ejecuta tu aplicación
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KAFEN',
      initialRoute: '/home',
      getPages: [
        GetPage(
          name: '/citas',
          page: () => MainLayout(child: const CitasView()),
          binding: CitasBinding(), // Recordatorio de que el binding es necesario aquí
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 350),
        ),
        // ... el resto de tus rutas
        GetPage(
          name: '/counter',
          page: () => MainLayout(child: CounterProviderView()),
        ),
        GetPage(
          name: '/provider',
          page: () => MainLayout(child: CounterView()),
        ),
        GetPage(
          name: '/home',
          page: () => MainLayout(child: HomeView()),
        ),
        GetPage(
          name: '/register',
          page: () => MainLayout(child: CreateUserView()),
        ),
      ],
      unknownRoute: GetPage(
        name: '/404',
        page: () => NotFoundPage(),
      ),
    );
  }
}