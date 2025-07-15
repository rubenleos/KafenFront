// packages_view.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kafen/models/paquetes_model.dart';

import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

import 'package:kafen/ui/controller/paquete_controller.dart';

class PackagesView extends StatelessWidget {
  const PackagesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PackagesController());

  return Container(
  color: const Color(0xFFFAF9F6),
  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30), // más espacio a los lados
  child: Obx(() {
    if (controller.isLoading.value) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.packages.isEmpty) {
      return const Center(
        child: Text(
          'No hay paquetes disponibles en este momento.',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Paquetes',
          style: GoogleFonts.lora(
            fontSize: 44,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 40),
        LayoutBuilder(
          builder: (context, constraints) {
            int crossAxisCount = constraints.maxWidth > 1200
                ? 3
                : constraints.maxWidth > 800
                    ? 2
                    : 1;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.packages.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 20, // más espacio entre columnas
                mainAxisSpacing: 20,
                childAspectRatio: 2.0, // más compactas
              ),
              itemBuilder: (context, index) {
                final package = controller.packages[index];
                return _PackageCard(package: package);
              },
            );
          },
        ),
      ],
    );
  }),
);  
  }
}

class _PackageCard extends StatefulWidget {
  final PackageModel package;
  const _PackageCard({required this.package, Key? key}) : super(key: key);

  @override
  State<_PackageCard> createState() => _PackageCardState();
}

class _PackageCardState extends State<_PackageCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final package = widget.package;
    final bool isSale = package.tipoDePaquete?.toUpperCase() == 'SALE';

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedScale(
        scale: _hovering ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(_hovering ? 0.12 : 0.05),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
                border: Border.all(color: Colors.grey[200]!),
              ),
              padding: const EdgeInsets.all(18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          package.nombrePaquete.toUpperCase(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.raleway(
                            fontSize: 13,
                            color: const Color(0xFFE0706B),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '\$${package.precio}',
                          style: GoogleFonts.lora(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF222222),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          package.duracion ?? 'Vencimiento de 30 días',
                          style: GoogleFonts.raleway(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          height: 1,
                          color: Colors.grey[300],
                          margin: const EdgeInsets.symmetric(vertical: 8),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                  onPressed: () {
                      // Navega a la vista de checkout y pasa el objeto 'package'
                      // como argumento para que el controlador lo pueda recibir.
                      Get.toNamed('/checkout', arguments: package);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSale ? Colors.black : Colors.white,
                      foregroundColor: isSale ? Colors.white : Colors.black,
                      elevation: 0,
                      minimumSize: const Size(double.infinity, 38),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                        side: BorderSide(
                          color: isSale ? Colors.black : Colors.grey[400]!,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      'COMPRAR',
                      style: GoogleFonts.raleway(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isSale)
              Positioned(
                top: -10,
                right: -10,
                child: Transform.rotate(
                  angle: 15 * math.pi / 180,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7BC96F), Color(0xFF5FB548)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'SALE',
                      style: GoogleFonts.raleway(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

  bool _hovering = false;

 