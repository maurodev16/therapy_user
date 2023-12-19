import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:therapy_dashboard/GlobalWidgets/customAppBar.dart';
import 'package:therapy_dashboard/GlobalWidgets/loadingWidget.dart';
import 'package:therapy_dashboard/Utils/Colors.dart';
import 'package:therapy_dashboard/pages/BottonNavPages/Home/Widgets/widgetDotsHome.dart';
import '../../../Controller/AppointmentController.dart';
import '../../../Controller/InvoiceController.dart';
import '../../createInvoicePage.dart';
import 'Widgets/widgetTherapyInfoCard.dart';

class HomePage extends StatelessWidget {
  final AppointmentController appointmentController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: widgetAppointmentsHome(),
    );
  }
}

Widget widgetAppointmentsHome() {
  final AppointmentController appointmentController = Get.find();
  final InvoiceController invoiceController = Get.find();

  return DefaultTabController(
    length: 3, // Define o número de abas
    child: Scaffold(
      appBar: AppBar(
        title: Text(
          'Zeitpläne',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          Expanded(
            child: ActionsDotWidget(),
          ),

          ///NOTIFICATION ICON
          IconButton(
            onPressed: () async {
              await appointmentController.getSeparateAppoints();
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
                                  itemCount:
                                      appointmentController.openAppoint.length,
                                  itemBuilder: (context, index) {
                                    var appointment = appointmentController
                                        .openAppoint[index];

                                    return widgetTherapyInfoCard(
                                      null,
                                      appointment.userModel!.firstname!,
                                      appointment.userModel!.lastname!,
                                      appointment.date!,
                                      appointment.time!,
                                      appointment.userModel!.clientNumber!,
                                      appointment.status!,
                                      appointment.userModel!.phone!,
                                      appointment.notes!,
                                      appointment.createdAt!,
                                      "",
                                      Container(
                                        child: Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                Icons.file_present,
                                                color: appointment
                                                        .invoicesModel!
                                                        .isNotEmpty
                                                    ? azul
                                                    : vermelho,
                                              ),
                                              onPressed: () async {
                                                InvoiceController.to
                                                    .receiveAppointmentData(
                                                        appointment);
                                                Get.to(
                                                    () => CreateInvoicePage(),
                                                    arguments: appointment);
                                              },
                                            ),
                                            // Adicione aqui o widget do badge (por exemplo, um círculo vermelho com um número)
                                            appointment
                                                    .invoicesModel!.isNotEmpty
                                                ? Container(
                                                    padding:
                                                        EdgeInsets.all(4.0),
                                                    decoration: BoxDecoration(
                                                      color: azul,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Text(
                                                      '${appointment.invoiceQnt}',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : SizedBox(),
            ),
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
                                    return widgetTherapyInfoCard(
                                      Colors.amber[50],
                                      appointment.userModel!.firstname!,
                                      appointment.userModel!.lastname!,
                                      appointment.date!,
                                      appointment.time!,
                                      appointment.userModel!.clientNumber!,
                                      appointment.status!,
                                      appointment.userModel!.phone!,
                                      appointment.notes!,
                                      appointment.createdAt!,
                                      "",

                                      // invoiceController.getInvoiceData.value.invoiceUrl == null
                                      Container(
                                        child: Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            IconButton(
                                              icon: Icon(
                                                Icons.file_present,
                                                color: appointment
                                                        .invoicesModel!
                                                        .isNotEmpty
                                                    ? azul
                                                    : vermelho,
                                              ),
                                              onPressed: () async {
                                                InvoiceController.to
                                                    .receiveAppointmentData(
                                                        appointment);
                                                Get.to(
                                                    () => CreateInvoicePage(),
                                                    arguments: appointment);
                                              },
                                            ),
                                            // Adicione aqui o widget do badge (por exemplo, um círculo vermelho com um número)
                                            appointment
                                                    .invoicesModel!.isNotEmpty
                                                ? Container(
                                                    padding:
                                                        EdgeInsets.all(4.0),
                                                    decoration: BoxDecoration(
                                                      color: azul,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Text(
                                                      '${appointment.invoiceQnt}',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  )
                                                : Container(),
                                          ],
                                        ),
                                      ),
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
                                      return widgetTherapyInfoCard(
                                        null,
                                        appointment.userModel!.firstname!,
                                        appointment.userModel!.lastname!,
                                        appointment.date!,
                                        appointment.time!,
                                        appointment.userModel!.clientNumber!,
                                        appointment.status!,
                                        appointment.userModel!.phone!,
                                        appointment.notes!,
                                        appointment.createdAt!,
                                        appointment.canceledBy,
                                        Obx(
                                          () => invoiceController
                                                      .getPickedFile ==
                                                  null
                                              ? Container(
                                                  child: IconButton(
                                                    icon: Icon(
                                                        Icons.upload_file,
                                                        color: vermelho),
                                                    onPressed: () async {
                                                      InvoiceController.to
                                                          .receiveAppointmentData(
                                                              appointment);
                                                      Get.to(
                                                        () =>
                                                            CreateInvoicePage(),
                                                        arguments: appointment,
                                                      );
                                                    },
                                                  ),
                                                )
                                              : Container(
                                                  child: IconButton(
                                                    icon: Icon(
                                                      Icons
                                                          .file_present_rounded,
                                                      color: azul,
                                                    ),
                                                    onPressed: () async {},
                                                  ),
                                                ),
                                        ),
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
