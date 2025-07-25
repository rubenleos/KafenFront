// lib/ui/views/citas.dart (o la ruta donde tengas este archivo)
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; 
import 'package:get_storage/get_storage.dart';

// --- IMPORTACIONES DE TU PROYECTO ---
// Asegúrate de que estas rutas sean correctas
import 'package:kafen/models/user.dart';
import 'package:kafen/ui/controller/citas_controlador.dart';
import 'package:kafen/ui/shared/abouts_us.dart'; 
import 'package:kafen/ui/shared/foot.dart';       
import 'package:kafen/ui/widget/call_action_banner.dart'; 
import 'package:kafen/ui/widget/card.dart';
import 'package:kafen/ui/widget/calendario.dart'; // Tu widget de calendario

class CitasView extends GetView<CitasController> {
  const CitasView({Key? key}) : super(key: key);

  // Método para obtener el nombre del usuario directamente desde GetStorage
  String _getNombreUsuarioDesdeStorage() {
    final box = GetStorage();
    final userData = box.read('user');

    if (userData != null && userData is Map<String, dynamic>) {
      try {
        final User usuario = User.fromJson(userData);
        return usuario.nombreCompleto;
      } catch (e) {
        print("CitasView: Error al parsear datos de usuario desde GetStorage: $e");
        return "Invitado (error)";
      }
    }
    return "Invitado";
  }

  @override
  Widget build(BuildContext context) {
    final String nombreUsuario = _getNombreUsuarioDesdeStorage();
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // --- SECCIÓN DEL CALENDARIO ---
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  "Hola, $nombreUsuario",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                "Selecciona una fecha disponible en el calendario para ver los horarios y reservar tu próxima sesión.",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: MiCalendarioWidget(), // Tu widget de calendario que llama a controller.onDaySelected
                ),
              ),
              const SizedBox(height: 24),
              // --- WIDGET ACTUALIZADO PARA MOSTRAR LA INFORMACIÓN DEL DÍA ---
              _buildDetallesDiaSeleccionado(), 
            ],
          ),
        ),
        
        // ... (resto de tus widgets de la página: AboutUsSection, AppFooter, etc.) ...
      ],
    );
  }

  // Widget principal que muestra los detalles del día seleccionado
  Widget _buildDetallesDiaSeleccionado() {
    // Obx reacciona a los cambios en las variables observables del controlador
    return Obx(() {
      final selectedDay = controller.selectedDay.value;
      if (selectedDay == null) {
        // Muestra un mensaje si no se ha seleccionado ningún día
        return const Center(
          child: Text(
            'Selecciona un día en el calendario.',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        );
      }

      // Si se seleccionó un día, muestra el título y la lista de horarios
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Horarios para: ${controller.dateFormat.format(selectedDay)}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey),
          ),
          const SizedBox(height: 16),
          // Llama al widget que construye la lista de horarios
          _buildListaDeHorarios(),
        ],
      );
    });
  }
  
  // Widget que construye la lista de horarios o los estados de carga/vacío
  Widget _buildListaDeHorarios() {
    return Obx(() {
      // Muestra un indicador de carga mientras se buscan los horarios
      if (controller.horariosCargando.value) {
        return const Center(child: CircularProgressIndicator());
      }
      
      // Muestra un mensaje si no se encontraron horarios para ese día
      if (controller.horariosDelDia.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'No hay clases programadas para este día.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
        );
      }

      // Si hay horarios, construye una lista de ellos
      return ListView.builder(
        shrinkWrap: true, // Para que el ListView ocupe solo el espacio necesario dentro de la Column
        physics: const NeverScrollableScrollPhysics(), // Deshabilita el scroll del ListView (ya está en un scroll principal)
        itemCount: controller.horariosDelDia.length,
        itemBuilder: (context, index) {
          final clase = controller.horariosDelDia[index];
          // Formatea las horas para que se vean amigables (ej. 09:00 AM)
          final horaInicioFormateada = _formatTime(clase.horaInicio);
          final horaFinFormateada = _formatTime(clase.horaFin);
          
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              leading: const Icon(Icons.watch_later_outlined, color: Colors.blueGrey),
              title: Text(
                'Clase de $horaInicioFormateada a $horaFinFormateada',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text('Cupos disponibles: ${clase.cupoDisponible} de ${clase.cupoMaximo}'),
              trailing: ElevatedButton(
                onPressed: clase.cupoDisponible > 0 ? () {
                  // TODO: Implementar lógica de reserva
                  print('Reservando clase con ID: ${clase.calendarioId}');
                  Get.snackbar('Reserva', 'Funcionalidad de reserva pendiente.');
                } : null, // Deshabilita el botón si no hay cupo
                child: const Text('Reservar'),
              ),
            ),
          );
        },
      );
    });
  }
  
  // Función de ayuda para formatear el string de tiempo
  String _formatTime(String timeString) {
    try {
      // Asume que el formato de entrada es HH:MM:SS
      final time = TimeOfDay(
        hour: int.parse(timeString.split(':')[0]),
        minute: int.parse(timeString.split(':')[1])
      );
      // Usa el contexto de la app para formatear a AM/PM
      return time.format(Get.context!);
    } catch (e) {
      // Si el formato es inesperado, devuelve el string original
      return timeString;
    }
  }
}
