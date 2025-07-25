// lib/ui/controller/citas_controlador.dart
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart'; // <--- IMPORTACIÓN AÑADIDA

// Asegúrate de importar los nuevos modelos y proveedores
import 'package:kafen/models/calendario_clase_model.dart';
import 'package:kafen/provider/calendario_provider.dart';

// Constantes para los límites del calendario
final kFirstDay = DateTime(DateTime.now().year, DateTime.now().month - 3, 1);
final kLastDay = DateTime(DateTime.now().year, DateTime.now().month + 3, 0);


class CitasController extends GetxController {
  // --- Estado del Calendario ---
  final Rx<DateTime?> selectedDay = Rx<DateTime?>(null);
  final Rx<DateTime> focusedDay = Rx<DateTime>(DateTime.now());
  final Rx<CalendarFormat> calendarFormat = Rx<CalendarFormat>(CalendarFormat.month); // <--- AÑADIDO

  // --- Estado para los Horarios de las Clases ---
  final CalendarioProvider _calendarioProvider = CalendarioProvider();
  final RxList<CalendarioClase> horariosDelDia = <CalendarioClase>[].obs;
  final RxBool horariosCargando = false.obs;

  // Formateador de fecha para usar en la UI
  final DateFormat dateFormat = DateFormat.yMMMMd('es_MX');

  // Método que se llama desde la UI cuando se selecciona un día
  void onDaySelected(DateTime selected, DateTime focused) {
    if (!isSameDay(selectedDay.value, selected)) {
      selectedDay.value = selected;
      focusedDay.value = focused;
      fetchHorarios(selected);
    }
  }

  // --- MÉTODOS AÑADIDOS PARA TABLE_CALENDAR ---
  void onFormatChanged(CalendarFormat format) {
    if (calendarFormat.value != format) {
      calendarFormat.value = format;
    }
  }

  void onPageChanged(DateTime focused) {
    focusedDay.value = focused;
  }
  // --- FIN DE MÉTODOS AÑADIDOS ---

  // Método para buscar los horarios de un día específico en la API
  Future<void> fetchHorarios(DateTime dia) async {
    try {
      horariosCargando.value = true;
      horariosDelDia.clear();
      
      final List<CalendarioClase> clases = await _calendarioProvider.getClasesPorFecha(dia);
      
      horariosDelDia.assignAll(clases);

    } catch (e) {
      print("CitasController: Error al buscar horarios - $e");
      Get.snackbar(
        "Error",
        "No se pudieron cargar los horarios para el día seleccionado.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      horariosCargando.value = false;
    }
  }
}
