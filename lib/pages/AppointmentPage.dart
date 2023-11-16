import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:therapy_user/Repository/RepositoryAppointment.dart';
import 'package:therapy_user/Utils/Colors.dart';

import '../Controller/AppointmentController.dart';

class AppointmentPage extends StatelessWidget {
  final appointmentController = Get.put<AppointmentController>(
      AppointmentController(RepositoryAppointment()));

  @override
  Widget build(BuildContext context) {
    RxString data =
        "${appointmentController.selectedData!.value.day}.${appointmentController.selectedData!.value.month}.${appointmentController.selectedData!.value.year}".obs;
    RxString hour =
        " ${appointmentController.selectedTime!.value.hour}:${appointmentController.selectedTime!.value.minute}".obs;
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
                return appointmentController.bookedDates.contains(day);
              },
              availableGestures: AvailableGestures.all,
              onDaySelected: (selectedData, focusedDay) {
                appointmentController.selectedData!.value =
                    selectedData.toLocal();
                Fluttertoast.showToast(
                  msg: "Ausgewählter Datum: ${data.value}",
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
                children: appointmentController.timeStrings
                    .map((time) => ElevatedButton(
                          onPressed: () {
                            appointmentController.selectedTime!.value =
                                DateTime.parse('2023-11-16 $time');

                            Fluttertoast.showToast(
                              msg: "Ausgewählte Zeit: $time",
                              gravity: ToastGravity.TOP,
                              toastLength: Toast.LENGTH_LONG,
                              backgroundColor: verde,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                appointmentController.selectedTime!.string ==
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
            Container(
              width: 0.95 * Get.width,
              child: Obx(
                () => TextFormField(
                  style: GoogleFonts.lato(fontSize: 25, color: cinza),
                  enabled: !appointmentController.isLoading.value,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    fillColor: branco,
                    hintMaxLines: 200,
                    labelText: 'Extra infos'.tr,
                    labelStyle: GoogleFonts.lato(
                      fontSize: 25,
                      color: preto,
                      fontWeight: FontWeight.w400,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: cinza,
                        width: 1.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: preto,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: vermelho,
                        width: 1,
                      ),
                    ),
                    suffixIcon:
                        Icon(Icons.info_outline, size: 20, color: vermelho),
                    filled: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                  ),
                  onChanged: (value) {
                    appointmentController.notes.value = value;
                  },
                ),
              ),
            ),
            Text(
              'Ihre Auswahl:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 5),
            
                 Container(
                  width: Get.width,
                  child: Card(
                    child:Obx(
              () => ListTile(
                      title: Text(
                        'Datum: ${data.value}',
                        style: GoogleFonts.lato(
                          fontSize: 22,
                        ),
                      ),
                      subtitle: Text(
                        'Uhrzeit: ${hour.value}',
                        style: GoogleFonts.lato(
                          fontSize: 22,
                        ),
                      ),
                    ),   ),
                  ),
                ),
              
         
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await appointmentController.create();
              },
              child: Text('Sitzung buchen'),
            ),
          ],
        ),
      ),
    );
  }
}
