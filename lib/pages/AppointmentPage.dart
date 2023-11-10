import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../Controller/AppointmentController.dart';

class AppointmentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sitzungsbuchung'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Wählen Sie einen Tag aus:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // Monatskalender
            TableCalendar(
              focusedDay: DateTime
                  .now(), // Datum, das der Kalender zuerst anzeigen soll
              firstDay: DateTime(DateTime.now().year, DateTime.now().month - 1,
                  DateTime.now().day), // Erster sichtbarer Tag im Kalender
              lastDay: DateTime(DateTime.now().year, DateTime.now().month + 1,
                  DateTime.now().day), // Letzter sichtbarer Tag im Kalender
              selectedDayPredicate: (day) {
                // Überprüfen, ob der Tag gebucht ist und deaktivieren
                return AppointmentController.to.bookedDates.contains(day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                AppointmentController.to.selectedDay.value =
                    selectedDay.toLocal().toString().split(' ')[0];
              },
            ),

            SizedBox(height: 20),
            Text(
              'Wählen Sie eine Uhrzeit aus:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Obx(
              () => Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: AppointmentController.to.availableTimes
                    .map((time) => ElevatedButton(
                          onPressed: () {
                            AppointmentController.to.selectedTime.value = time;
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                AppointmentController.to.selectedTime.value ==
                                        time
                                    ? Colors.blue
                                    : Colors.grey,
                          ),
                          child: Text(time),
                        ))
                    .toList(),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Ihre Auswahl:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Obx(
              () => Text(
                  'Kunder Name: ${AppointmentController.to.selectedTime.value}'),
            ),
            Obx(
              () => Text(
                  'Service: ${AppointmentController.to.selectedTime.value}'),
            ),
            Obx(
              () =>
                  Text('Datum: ${AppointmentController.to.selectedDay.value}'),
            ),
            Obx(
              () => Text(
                  'Uhrzeit: ${AppointmentController.to.selectedTime.value}'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Führen Sie die Buchungsaktion hier aus
              },
              child: Text('Sitzung buchen'),
            ),
          ],
        ),
      ),
    );
  }
}
