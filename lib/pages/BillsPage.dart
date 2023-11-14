import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controller/BillsController.dart';
import '../Models/BillsModel.dart';
import '../Utils/Colors.dart';

class BillsPage extends StatelessWidget {
  final billsControler = Get.find<BillsController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rechnungsübersicht',
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            Container(
              constraints: BoxConstraints.expand(height: Get.height * 0.1),
              child: TabBar(
                tabs: [
                  Tab(
                      text: 'Offene',
                      icon: Hero(
                        tag: "tagVermelho",
                        child: Icon(
                          Icons.pending,
                          color: vermelho,
                          size: 15,
                        ),
                      )),
                  Tab(
                    text: 'Bezahlt',
                    icon: Hero(
                      tag: "tgVerde",
                      child: Icon(Icons.pending, color: verde, size: 15),
                    ),
                  ),
                  Tab(
                      text: 'Storniert',
                      icon: Hero(
                          tag: "tagAzul",
                          child: Icon(Icons.pending, color: azul, size: 15))),
                  Tab(
                      text: 'überfällig',
                      icon: Hero(
                        tag: "tagPreto",
                        child: Icon(Icons.pending, color: preto, size: 15),
                      )),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Content of "Open" tab
                  BillsList(status: 'Open'),

                  // Content of "Closed" tab
                  BillsList(status: 'Closed'),

                  // Content of "Pending" tab
                  BillsList(status: 'Pending'),

                  //Content of "Overduo" tab
                  BillsList(status: 'OverDuo'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BillsList extends StatelessWidget {
  final String status;

  BillsList({required this.status});

  @override
  Widget build(BuildContext context) {
  final billsControler = Get.find<BillsController>();

    List<BillModel> bills = billsControler.getBillsByStatus(status);

    return ListView.builder(
      itemCount: bills.length,
      itemBuilder: (context, index) {
        BillModel bill = bills[index];
        return BillCard(bill: bill);
      },
    );
  }
}

class BillCard extends StatelessWidget {
  final BillModel bill;

  BillCard({required this.bill});

  @override
  Widget build(BuildContext context) {
    late Icon icon;

    switch (bill.status) {
      case 'Open':
        icon = Icon(Icons.pending, color: vermelho);
        break;
      case 'Closed':
        icon = Icon(Icons.pending, color: verde);
        break;
      case 'Pending':
        icon = Icon(Icons.pending, color: azul);
        break;
      case 'OverDuo':
        icon = Icon(Icons.pending, color: preto);
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
              title: Text(bill.name),
              subtitle: Text("Sub title"),
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
                Text('?: ${bill.dueDate.toString()}'),
              ],
            ),
            Text('Total: ${bill.amount}'),
            Text('Status: ${bill.status}'),
          ],
        ),
      ),
    );
  }
}
