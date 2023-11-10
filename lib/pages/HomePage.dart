import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:therapy_user/pages/AppointmentPage.dart';
import '../Utils/Colors.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: appointmentsScreen(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(()=>AppointmentPage());
        },
        heroTag: "tgCalender",
        child: Icon(Icons.calendar_month),
      ),
    );
  }
}

Widget appointmentsScreen() {
  return DefaultTabController(
    length: 3, // Define o número de abas
    child: Scaffold(
      appBar: AppBar(
        title: Text(
          'Zeitpläne',
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          Row(
            children: [],
          ),

          ///NOTIFICATION ICON
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications,
            ),
          ),
        ],
        bottom: TabBar(
          tabs: [
            Tab(text: 'Aktual Termin'),
            Tab(text: 'Geschlossen'),
            Tab(text: 'Abgesagt'),
          ],
        ),
      ),
      body: TabBarView(
        children: [
          therapyInfoCard(
            'Zahlungsstatus: Offene',
            'Britta',
            0001,
            '20. Oktober 2023',
          ),
          therapyInfoCard(
            'Zahlungsstatus: Bezahlt ',
            'Kindermann',
            0002,
            '01. Oktober 2023',
          ),
          therapyInfoCard(
            'Zahlungsstatus: Storniert',
            'Petter',
            0003,
            '02. Oktober 2023',
          ),
        ],
      ),
    ),
  );
}

Widget therapyInfoCard(
  String statusText,
  String clientName,
  int clienteNumber,
  String payDate,
) {
  return Card(
    elevation: 3,
    margin: EdgeInsets.all(10),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kunder: $clientName',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            'Kunder Nummer: $clienteNumber',
            style: TextStyle(fontSize: 10),
          ),
          SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Icon(
                  Icons.pending,
                  color: verde,
                ),
                SizedBox(width: 5),
                Text('$statusText'),
              ],
            ),
          ),
          SizedBox(height: 10),
          ListTile(
            title: Text("Nächste Zahlung"),
            subtitle: Text(payDate),
          ),
        ],
      ),
    ),
  );
}
