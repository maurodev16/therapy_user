import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:therapy_user/Utils/Colors.dart';

import '../Controller/AppointmentController.dart';

class AppointmentPage extends StatelessWidget {
  final appointControler = Get.find<AppointmentController>();

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
              //  locale: "de_DE",
              rowHeight: 35,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              ),
              focusedDay: DateTime
                  .now(), // Datum, das der Kalender zuerst anzeigen soll
              firstDay: DateTime(DateTime.now().year, DateTime.now().month,
                  DateTime.now().day), // Erster sichtbarer Tag im Kalender
              lastDay: DateTime(DateTime.now().year, DateTime.now().month + 6,
                  DateTime.now().day), // Letzter sichtbarer Tag im Kalender
              selectedDayPredicate: (day) {
                isSameDay(day, DateTime.now());
                // Überprüfen, ob der Tag gebucht ist und deaktivieren
                return appointControler.bookedDates.contains(day);
              },
              availableGestures: AvailableGestures.all,
              onDaySelected: (selectedDay, focusedDay) {
                appointControler.selectedDay.value =
                    selectedDay.toLocal().toString().split(' ')[0];
                Fluttertoast.showToast(
                    msg:"Ausgewählter Tag: ${ appointControler.selectedDay.value}",
                    gravity: ToastGravity.TOP,
                    toastLength: Toast.LENGTH_LONG,
                    backgroundColor: verde,

                    );
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
                children: appointControler.availableTimes
                    .map((time) => ElevatedButton(
                          onPressed: () {
                            appointControler.selectedTime.value = time;
                               Fluttertoast.showToast(
                    msg:"Ausgewählte Zeit: ${ appointControler.selectedTime.value}",
                    gravity: ToastGravity.TOP,
                    toastLength: Toast.LENGTH_LONG,
                    backgroundColor: verde,

                    );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                appointControler.selectedTime.value == time
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
              () => Text('Kunder Name: ${appointControler.selectedTime.value}'),
            ),
            Obx(
              () => Text('Service: ${appointControler.selectedTime.value}'),
            ),
            Obx(
              () => Text('Datum: ${appointControler.selectedDay.value}'),
            ),
            Obx(
              () => Text('Uhrzeit: ${appointControler.selectedTime.value}'),
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
