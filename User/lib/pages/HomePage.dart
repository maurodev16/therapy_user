import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:therapy_user/Controller/AuthController.dart';
import 'package:therapy_user/GlobalWidgets/loadingWidget.dart';
import '../../../Controller/AppointmentController.dart';
import '../../../Controller/InvoiceController.dart';
import '../GlobalWidgets/customAppBar.dart';
import '../Utils/Colors.dart';

final AppointmentController appointmentController = Get.find();

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: appointmentsScreen(),
    );
  }
}

Widget appointmentsScreen() {
  final AuthController auth = Get.find();

  return DefaultTabController(
    length: 3, // Define o número de abas
    child: Scaffold(
      appBar: AppBar(
        title: Text(
          'Zeitpläne',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          ///NOTIFICATION ICON
          IconButton(
            onPressed: () async {
              await appointmentController
                  .getSeparateAppoints(auth.getUserData.value.userId!);
            },
            icon: Icon(
              Icons.refresh_rounded,
            ),
          ),
        ],
        bottom: TabBar(
          tabs: [
            Obx(
              () => Tab(
                  text:
                      '${appointmentController.openAppoint.length} Nächste Termin'),
            ),
            Obx(() => Tab(
                text:
                    '${appointmentController.doneAppoint.length} Geschlossen')),
            Obx(() => Tab(
                text:
                    '${appointmentController.canceledAppoint.length} Abgesagt')),
          ],
        ),
      ),
      body: TabBarView(
        children: [
          // ABA OPEN

          Obx(
            () => Container(
                height: Get.height,
                child: appointmentController.isLoading.value
                    ? loadingWidget()
                    : appointmentController.openAppoint.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Image.asset(
                                  "assets/images/coffee-cup.png",
                                  height: 50,
                                  width: 50,
                                  color: cinza,
                                ),
                              ),
                              Text(
                                "Sie haben keine neuen Termine",
                                style: GoogleFonts.lato(
                                  fontSize: 10,
                                ),
                              )
                            ],
                          )
                        : appointmentController.status.isError
                            ? Center(child: Icon(Icons.error_outline))
                            : appointmentController.status.isSuccess
                                ? ListView.builder(
                                    itemCount: appointmentController
                                        .openAppoint.length,
                                    itemBuilder: (context, index) {
                                      var appointment = appointmentController
                                          .openAppoint[index];
                                      return therapyInfoCard(
                                        appointment.userModel!.firstname!,
                                        appointment.userModel!.lastname!,
                                        appointment.date!,
                                        appointment.time!,
                                        appointment.userModel!.clientNumber!,
                                        appointment.status!,
                                        appointment.userModel!.phone!,
                                        appointment.notes!,
                                        appointment.createdAt!,
                                        appointment.id!,
                                        auth.getUserData.value.userId!,
                                      );
                                    },
                                  )
                                : SizedBox()),
          ),

          ///ABA DONE
          GetBuilder<AppointmentController>(
            builder: (doneAppointmentController) => Container(
              height: Get.height,
              child: doneAppointmentController.isLoading.value
                  ? loadingWidget()
                  : doneAppointmentController.doneAppoint.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Image.asset(
                                "assets/images/no-task.png",
                                height: 50,
                                width: 50,
                                color: cinza,
                              ),
                            ),
                            Text(
                              "Keine geschlossenen Termine",
                              style: GoogleFonts.lato(
                                fontSize: 10,
                              ),
                            )
                          ],
                        )
                      : doneAppointmentController.status.isError
                          ? Center(child: Icon(Icons.error_outline))
                          : doneAppointmentController.status.isSuccess
                              ? ListView.builder(
                                  itemCount: doneAppointmentController
                                      .doneAppoint.length,
                                  itemBuilder: (context, index) {
                                    var appointment = doneAppointmentController
                                        .doneAppoint[index];

                                    return therapyInfoCard(
                                      appointment.userModel!.firstname!,
                                      appointment.userModel!.lastname!,
                                      appointment.date!,
                                      appointment.time!,
                                      appointment.userModel!.clientNumber!,
                                      appointment.status!,
                                      appointment.userModel!.phone!,
                                      appointment.notes!,
                                      appointment.createdAt!,
                                      appointment.id!,
                                      auth.getUserData.value.userId!,
                                      // invoiceController.getInvoiceData.value.invoiceUrl == null
                                    );
                                  },
                                )
                              : SizedBox(),
            ),
          ),

          //ABA CANCELED
          ///ABA DONE
          GetBuilder<AppointmentController>(
            builder: (canceledAppointmentController) => Container(
                height: Get.height,
                child: canceledAppointmentController.isLoading.value
                    ? loadingWidget()
                    : canceledAppointmentController.canceledAppoint.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Image.asset(
                                  "assets/images/cancelled.png",
                                  height: 50,
                                  width: 50,
                                  color: cinza,
                                ),
                              ),
                              Text(
                                "Keine abgesagten Termine",
                                style: GoogleFonts.lato(
                                  fontSize: 10,
                                ),
                              )
                            ],
                          )
                        : canceledAppointmentController.status.isError
                            ? Center(child: Icon(Icons.error_outline))
                            : canceledAppointmentController.status.isSuccess
                                ? ListView.builder(
                                    itemCount: canceledAppointmentController
                                        .canceledAppoint.length,
                                    itemBuilder: (context, index) {
                                      var appointment =
                                          canceledAppointmentController
                                              .canceledAppoint[index];
                                      return therapyInfoCard(
                                        appointment.userModel!.firstname!,
                                        appointment.userModel!.lastname!,
                                        appointment.date!,
                                        appointment.time!,
                                        appointment.userModel!.clientNumber!,
                                        appointment.status!,
                                        appointment.userModel!.phone!,
                                        appointment.notes!,
                                        appointment.createdAt!,
                                        appointment.id!,
                                        auth.getUserData.value.userId!,
                                      );
                                    },
                                  )
                                : SizedBox()),
          ),
        ],
      ),
    ),
  );
}

Widget therapyInfoCard(
  String firstname,
  String lastname,
  DateTime date,
  DateTime time,
  int clienteNumber,
  String status,
  String phone,
  String notes,
  DateTime createdAt,
  String appointmentId,
  String userId,
) {
  return GetBuilder<InvoiceController>(builder: (invoiceController) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Icon(Icons.person, size: 12),
                        SizedBox(width: 5),
                        Text(
                          'Kundin(e): $firstname $lastname',
                          style: GoogleFonts.lato(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem<String>(
                        value: 'login',
                        child: ListTile(
                          title: Text(
                            'Termin absagen',
                            style: GoogleFonts.lato(
                              fontSize: 18,
                              color: cinza,
                            ),
                          ),
                          trailing: Icon(
                            Icons.cancel_presentation_rounded,
                            color: cinza,
                            size: 25,
                          ),
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      // Ação ao selecionar uma opção do menu
                      if (value == 'login') {
                        Get.defaultDialog(
                          title: "Termin stornieren",
                          onConfirm: () {
                            print(appointmentId);
                            print(userId);
                            appointmentController.cancelAppointment(
                                appointmentId, userId);
                          },
                          onCancel: () {},
                        );

                        print('Login selecionado');
                      } else if (value == 'logout') {
                        // Lógica de logout
                        print('Logout selecionado');
                      }
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.calendar_month, size: 12),
                  SizedBox(width: 5),
                  Text(
                    'Datum: ${date.day}.${date.month}.${date.year}',
                    style: GoogleFonts.lato(fontSize: 15, color: vermelho),
                  ),
                  SizedBox(width: 5),
                  Icon(Icons.alarm, size: 12),
                  SizedBox(width: 5),
                  Text(
                    'Uhr: ${DateFormat.Hm().format(time)}',
                    style: GoogleFonts.lato(fontSize: 15, color: vermelho),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.phone_android_rounded, size: 12),
                  Text(
                    ' $phone',
                    style: GoogleFonts.lato(fontSize: 15, color: vermelho),
                  ),
                ],
              ),
              SizedBox(height: 10),
              notes.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.note_alt_outlined, size: 12),
                            SizedBox(width: 5),
                            Text(
                              "Notiz",
                              style: GoogleFonts.lato(color: vermelho),
                            ),
                          ],
                        ),
                        SizedBox(width: 5),
                        ExpandableText(
                          '$notes',
                          expandText: 'zeig mehr',
                          collapseText: 'zeige weniger',
                          maxLines: 1,
                          linkColor: azul,
                        ),
                      ],
                    )
                  : Text(""),
              SizedBox(height: 15),
              Text(
                'Kn: $clienteNumber',
                style: TextStyle(fontSize: 10),
              ),
              // Text(
              //   'Erstellt am: ${createdAt.day}.${createdAt.month}.${createdAt.year}',
              //   style: TextStyle(fontSize: 10),
              // ),
              Text(appointmentId),
              Text(userId),
            ],
          ),
        ),
      ),
    );
  });
}
