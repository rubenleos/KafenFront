import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kafen/bindings/citas.binding.dart';

import 'package:kafen/provider/authprovider.dart';
import 'package:kafen/ui/controller/regitration_controller.dart';
import 'package:kafen/ui/layout/main_layout.dart';
import 'package:kafen/ui/pages/not_found.dart';
import 'package:kafen/ui/views/ClientPaymentView.dart';
import 'package:kafen/ui/views/citas.dart';
import 'package:kafen/ui/views/client_checkout_view.dart';
import 'package:kafen/ui/views/contacto_view.dart';
import 'package:kafen/ui/views/counter_provider_view.dart';
import 'package:kafen/ui/views/create_user_view.dart';
import 'package:kafen/ui/views/home_view.dart';
import 'package:kafen/ui/views/nosotros_view.dart';
import 'package:kafen/ui/views/paquetes_view.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await initializeDateFormatting('es_MX', null);
  Get.put(AuthProvider());
  Get.put(RegistrationController());
  runApp(const MyApp());
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
          binding: CitasBinding(),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 350),
        ),
        GetPage( // <-- AÑADE ESTA NUEVA RUTA
          name: '/paquetes',
          page: () => MainLayout(child:  PackagesView()),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 350),
        ),
        GetPage(
          name: '/counter',
          page: () => MainLayout(child: CounterProviderView()),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 350),
        ),
        GetPage(
          name: '/home',
          page: () => MainLayout(child: HomeView()),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 350),
        ),
        GetPage(
          name: '/register',
          page: () => MainLayout(child: CreateUserView()),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 350),
        ),
         GetPage(
          name: '/pagos',
          page: () => MainLayout(child:ClientPaymentsView() ),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 350),
        ),
        GetPage(
          name: '/nosotros',
          page: () => MainLayout(child:NosotrosView() ),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 350),
        ),
        GetPage(
          name: '/contacto',
          page: () => MainLayout(child:ContactoView() ),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 350),
        ),
        GetPage(
          name: '/checkout',
          page: () => MainLayout(child: const ClientCheckoutView()),
          transition: Transition.fadeIn,
          transitionDuration: const Duration(milliseconds: 350),
        ),
      ],
      unknownRoute: GetPage(
        name: '/404',
        page: () => NotFoundPage(),
      ),
    );
  }
}