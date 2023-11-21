import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:therapy_user/Controller/AuthController.dart';
import 'package:therapy_user/GlobalWidgets/loadingWidget.dart';

import '../../Controller/AppointmentController.dart';
import '../GlobalWidgets/customAppBar.dart';
import '../Utils/Colors.dart';

class HomePage extends StatelessWidget {
  final AppointmentController appointmentController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: appointmentsScreen(),
    );
  }
}

Widget appointmentsScreen() {
  final AppointmentController appointmentController = Get.find();
  final AuthController authController = Get.find();

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
              await appointmentController.getSeparateAppoints(
                  authController.getUserData.value.userId!);
            },
            icon: Icon(
              Icons.refresh_rounded,
            ),
          ),
        ],
        bottom: TabBar(
          tabs: [
            Tab(text: 'Nächste Termin'),
            Tab(text: 'Geschlossen'),
            Tab(text: 'Abgesagt'),
          ],
        ),
      ),
      body: TabBarView(
        children: [
          // ABA OPEN

          Container(
            height: Get.height,
            child: Obx(() => appointmentController.isLoading.value
                ? LoadingWidget()
                : appointmentController.status.isEmpty
                    ? Center(
                        child: Icon(
                          Icons.alarm_off_rounded,
                          size: 40,
                        ),
                      )
                    : appointmentController.status.isError
                        ? Center(child: Icon(Icons.error_outline))
                        : appointmentController.status.isSuccess
                            ? ListView.builder(
                                itemCount:
                                    appointmentController.openAppoint.length,
                                itemBuilder: (context, index) {
                                  var appointment =
                                      appointmentController.openAppoint[index];
                                  return therapyInfoCard(
                                    appointment.userModel!.phone!,
                                    appointment.userModel!.email!,
                                    appointment.date!,
                                    appointment.time!,
                                    appointment.userModel!.clientNumber!,
                                    appointment.status!,
                                  );
                                },
                              )
                            : SizedBox()),
          ),

          ///ABA DONE
          Obx(
            () => Container(
              height: Get.height,
              child: appointmentController.isLoading.value
                  ? LoadingWidget()
                  : appointmentController.status.isEmpty
                      ? Center(
                          child: Icon(Icons.alarm_off_rounded),
                        )
                      : appointmentController.status.isError
                          ? Center(child: Icon(Icons.error_outline))
                          : appointmentController.status.isSuccess
                              ? ListView.builder(
                                  itemCount:
                                      appointmentController.doneAppoint.length,
                                  itemBuilder: (context, index) {
                                    var appointment = appointmentController
                                        .doneAppoint[index];
                                    return therapyInfoCard(
                                      appointment.userModel!.phone!,
                                      appointment.userModel!.email!,
                                      appointment.date!,
                                      appointment.time!,
                                      appointment.userModel!.clientNumber!,
                                      appointment.status!,
                                    );
                                  },
                                )
                              : SizedBox(),
            ),
          ),

          //ABA CANCELED
          ///ABA DONE
          Container(
            height: Get.height,
            child: Obx(() => appointmentController.isLoading.value
                ? LoadingWidget()
                : appointmentController.status.isEmpty
                    ? Center(
                        child: Icon(Icons.alarm_off_rounded),
                      )
                    : appointmentController.status.isError
                        ? Center(child: Icon(Icons.error_outline))
                        : appointmentController.status.isSuccess
                            ? ListView.builder(
                                itemCount: appointmentController
                                    .canceledAppoint.length,
                                itemBuilder: (context, index) {
                                  var appointment = appointmentController
                                      .canceledAppoint[index];
                                  return therapyInfoCard(
                                    appointment.userModel!.phone!,
                                    appointment.userModel!.email!,
                                    appointment.date!,
                                    appointment.time!,
                                    appointment.userModel!.clientNumber!,
                                    appointment.status!,
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
  String phone,
  String email,
  DateTime date,
  DateTime time,
  int clienteNumber,
  String status,
) {
  final AppointmentController appointmentController = Get.find();

  return Card(
    elevation: 3,
    margin: EdgeInsets.all(10),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Email: $email',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            'Phone: $phone',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            'Termin datum: ${date.day}.${date.month}.${date.year}',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            'Time: ${DateFormat.Hm().format(time)}',
            style: TextStyle(fontSize: 22),
          ),
          Text(
            'Nummer: $clienteNumber',
            style: TextStyle(fontSize: 10),
          ),
          Text(
            'KN: $clienteNumber',
            style: TextStyle(fontSize: 10),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.pending,
                color: verde,
              ),
              SizedBox(width: 5),
              appointmentController.appointStatus.value.contains("open")
                  ? TextButton.icon(
                      onPressed: () {
                        Get.defaultDialog(
                          title: "ABSAGEN",
                          middleText: "Möchten Sie diesen Termin absagen?",
                        );
                      },
                      label: Text("Termin absagen?"),
                      icon: Icon(Icons.cancel),
                    )
                  : Container()
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    ),
  );
}
