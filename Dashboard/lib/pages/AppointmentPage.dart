import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

import '../Controller/AppointmentController.dart';

class AppointmentPage extends GetView<AppointmentController> {
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
                return controller.bookedDates.contains(day);
              },
              onDaySelected: (selectedDay, focusedDay) {
               controller.selectedData.value =
                    selectedDay;
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
                children:controller.timeStrings
                    .map((time) => ElevatedButton(
                          onPressed: () {
                           controller.selectedTime.value =DateTime.parse(time) ;
                          },
                        
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
                  'Kunder Name: ${controller.selectedTime.value}'),
            ),
            Obx(
              () => Text(
                  'Service: ${controller.selectedTime.value}'),
            ),
            Obx(
              () =>
                  Text('Datum: ${controller.selectedData.value}'),
            ),
            Obx(
              () => Text(
                  'Uhrzeit: ${controller.selectedTime.value}'),
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
