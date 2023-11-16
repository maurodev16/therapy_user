import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:therapy_user/Controller/AppointmentController.dart';
import 'package:therapy_user/Models/AppointmentModel.dart';



import '../Utils/Colors.dart';

class HomePage extends StatelessWidget {
  final appointControler = Get.find<AppointmentController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Mein Zeitpläne',
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Container(
              constraints: BoxConstraints.expand(height: Get.height * 0.1),
              child: TabBar(
                tabs: [
                  Tab(text: 'Aktual Termin'),
                  Tab(text: 'Geschlossen'),
                  Tab(text: 'Abgesagt'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Content of "Open" tab
                  AppointmentsList(status: 'Open'),

                  // Content of "Closed" tab
                  AppointmentsList(status: 'Closed'),

                  // Content of "Pending" tab
                  AppointmentsList(status: 'Reversal'),

                 
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppointmentsList extends StatelessWidget {
  final String status;

  AppointmentsList({required this.status});

  @override
  Widget build(BuildContext context) {
    final appointControler = Get.find<AppointmentController>();

    List<AppointmentModel> appointments = appointControler.getAppointByStatus(status);

    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        AppointmentModel appointmentModel = appointments[index];
        return AppointmentCard(appointmentModel: appointmentModel);
      },
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final AppointmentModel appointmentModel;

  AppointmentCard({required this.appointmentModel});

  @override
  Widget build(BuildContext context) {
    late Icon icon;

    switch (appointmentModel.status) {
      case 'Open':
        icon = Icon(Icons.pending, color: vermelho);
        break;
      case 'Closed':
        icon = Icon(Icons.pending, color: verde);
        break;
      case 'Reversal':
        icon = Icon(Icons.pending, color: azul);
        break;
   
    }

    return Card(
      elevation: 3,
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              dense: true,
              title: Text(appointmentModel.date!.toString()),
              subtitle: Text("Date"),
              trailing: IconButton(
                onPressed: () {},
                icon: Icon(Icons.download),
                color: preto,
              ),
            ),
            Row(
              children: [
                icon,
                SizedBox(width: 5),
                Text('${appointmentModel.time}'),
              ],
            ),
            Text('Status: ${appointmentModel.status}'),
            Text('Notas: ${appointmentModel.notes}'),
          ],
        ),
      ),
    );
  }
}
