import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:therapy_user/GlobalWidgets/loadingWidget.dart';
import 'package:therapy_user/Repository/RepositoryAppointment.dart';
import 'package:therapy_user/Utils/Colors.dart';

import '../Controller/AppointmentController.dart';

class AppointmentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    RxBool clikedDate = false.obs;
    RxBool clikedTime = false.obs;

    return GetBuilder<AppointmentController>(
      init: AppointmentController(RepositoryAppointment()),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () async {
                await controller.reloadAppointmentdata();
                Get.back();
              },
              icon: Icon(Icons.arrow_back_ios)),
          title: Text('Sitzungsbuchung'),
        ),
        body: controller.isLoading.value
            ? loadingWidget()
            : SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Wählen Sie einen Tag aus:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    // Monatskalender
                    TableCalendar(
                      locale: 'de_DE',
                      rowHeight: 35,
                      headerStyle: HeaderStyle(
                        formatButtonVisible: false,
                        titleCentered: true,
                      ),
                      focusedDay: DateTime
                          .now(), // Datum, das der Kalender zuerst anzeigen soll
                      firstDay: DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now()
                              .day), // Erster sichtbarer Tag im Kalender
                      lastDay: DateTime(
                          DateTime.now().year,
                          DateTime.now().month + 6,
                          DateTime.now()
                              .day), // Letzter sichtbarer Tag im Kalender
                      selectedDayPredicate: (day) {
                        isSameDay(day, DateTime.now());
                        // Überprüfen, ob der Tag gebucht ist und deaktivieren
                        return controller.bookedDates.contains(day);
                      },
                      availableGestures: AvailableGestures.all,
                      onDaySelected: (selectedData, focusedDay) {
                        clikedDate.value = true;
                        print(clikedDate);
                        controller.selectedData.value = selectedData.toLocal();
                        focusedDay = selectedData;
                      },
                    ),
                    Text(
                      'Ihre Auswahl Datum:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),

                    SizedBox(height: 5),

                    Container(
                      width: Get.width,
                      child: Card(
                        child: Obx(() {
                          DateTime formattedData =
                              controller.selectedData.value;
                          int day = formattedData.day;
                          int month = formattedData.month;
                          int year = formattedData.year;
                          print('Data: ${controller.selectedData.value}');

                          return ListTile(
                            title: clikedDate.value
                                ? Text(
                                    'Datum: $day.$month.$year',
                                    style: GoogleFonts.lato(fontSize: 22),
                                  )
                                : Text(
                                    "Datum:",
                                    style: GoogleFonts.lato(fontSize: 22),
                                  ),
                            dense: true,
                            leading: Icon(
                              Icons.calendar_month_outlined,
                              color: verde,
                            ),
                          );
                        }),
                      ),
                    ),

                    SizedBox(height: 20),
                    Text(
                      'Wählen Sie eine Uhrzeit aus:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: controller.timeStrings
                          .map((time) => ElevatedButton(
                                onPressed: () {
                                  clikedTime.value = true;
                                  controller.selectedTime.value =
                                      DateTime.parse('2023-11-16 $time');
                                },
                                child: Text(time),
                              ))
                          .toList(),
                    ),
                    Text(
                      'Ihre Auswahl Uhrzeit:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),

                    SizedBox(height: 5),

                    Container(
                      width: Get.width,
                      child: Card(
                        child: Obx(() {
                          String formattedTime = DateFormat.Hm()
                              .format(controller.selectedTime.value);
                          print('Uhrzeit: ${controller.selectedTime.value}');

                          return ListTile(
                            title: clikedTime.value
                                ? Text(
                                    'Uhrzeit: $formattedTime',
                                    style: GoogleFonts.lato(fontSize: 22),
                                  )
                                : Text(
                                    "Uhrzeit:",
                                    style: GoogleFonts.lato(fontSize: 22),
                                  ),
                            dense: true,
                            leading: Icon(
                              Icons.timer_outlined,
                              color: verde,
                            ),
                          );
                        }),
                      ),
                    ),

                    SizedBox(height: 20),
                    Container(
                      width: 0.95 * Get.width,
                      child: TextFormField(
                        style: GoogleFonts.lato(fontSize: 25, color: preto),
                        enabled: !controller.isLoading.value,
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
                              color: preto,
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
                          suffixIcon: Icon(Icons.info_outline,
                              size: 20, color: vermelho),
                          filled: true,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 16.0),
                        ),
                        onChanged: (value) {
                          controller.notes.value = value;
                        },
                      ),
                    ),

                    SizedBox(height: 20),
                    Obx(
                      () => ElevatedButton(
                        onPressed:
                            clikedDate.value == true && clikedTime.value == true
                                ? () async {
                                    await controller.create();
                                  }
                                : null,
                        child: Text('Sitzung buchen'),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
