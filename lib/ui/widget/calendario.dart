// lib/widgets/mi_calendario_widget.dart
// lib/widgets/mi_calendario_widget.dart
// lib/widgets/mi_calendario_widget.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

// Importa tu controlador. Esto también te da acceso a kFirstDay y kLastDay.
import 'package:kafen/ui/controller/citas_controlador.dart'; 


class MiCalendarioWidget extends GetView<CitasController> {
  const MiCalendarioWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Para que los nombres de los meses y días salgan en español.
    // Es mejor llamar a initializeDateFormatting('es_MX', null) en tu main.dart.
    
    return Obx(
      () => TableCalendar(
        locale: 'es_MX', // Configura el idioma español para el calendario
        
        // --- CORRECCIÓN AQUÍ ---
        // Se accede a kFirstDay y kLastDay directamente, sin 'controller.'
        firstDay: kFirstDay,
        lastDay: kLastDay,
        // --- FIN DE LA CORRECCIÓN ---

        focusedDay: controller.focusedDay.value,
        calendarFormat: controller.calendarFormat.value,
        selectedDayPredicate: (day) {
          // isSameDay es una función de la librería table_calendar
          return isSameDay(controller.selectedDay.value, day);
        },
        onDaySelected: controller.onDaySelected,
        onFormatChanged: controller.onFormatChanged,
        onPageChanged: controller.onPageChanged,
        
        // Estilos
        calendarStyle: CalendarStyle(
          selectedDecoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          outsideDaysVisible: false,
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: true,
          titleCentered: true,
          formatButtonShowsNext: false,
          formatButtonDecoration: BoxDecoration(
            color: Colors.blueGrey[100],
            borderRadius: BorderRadius.circular(20.0),
          ),
          formatButtonTextStyle: const TextStyle(color: Colors.black54),
          leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.black54),
          rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.black54),
        ),
      ),
    );
  }
}
