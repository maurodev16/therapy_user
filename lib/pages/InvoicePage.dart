import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Models/InvoiceModel.dart';
import '../Controller/InvoiceController.dart';
import '../Utils/Colors.dart';

class InvoicePage extends StatelessWidget {
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
                  InvoiceList(status: 'Open'),

                  // Content of "completed" tab
                  InvoiceList(status: 'Completed'),

                  // Content of "Pending" tab
                  InvoiceList(status: 'Pending'),

                  //Content of "Overduo" tab
                  InvoiceList(status: 'OverDuo'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InvoiceList extends StatelessWidget {
  final String status;

  InvoiceList({required this.status});

  @override
  Widget build(BuildContext context) {
    List<InvoiceModel> invoices = InvoiceController.to.overdueInvoice;

    return ListView.builder(
      itemCount: invoices.length,
      itemBuilder: (context, index) {
        InvoiceModel invoice = invoices[index];
        return InvoiceCard(invoice: invoice);
      },
    );
  }
}

class InvoiceCard extends StatelessWidget {
  final InvoiceModel invoice;

  InvoiceCard({required this.invoice});

  @override
  Widget build(BuildContext context) {
    late Icon icon;

    switch (invoice.invoiceStatus) {
      case 'open':
        icon = Icon(Icons.pending, color: vermelho);
        break;
      case 'completed':
        icon = Icon(Icons.pending, color: verde);
        break;
      case 'pending':
        icon = Icon(Icons.pending, color: azul);
        break;
      case 'overduo':
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
            Row(
              children: [
                icon,
                SizedBox(width: 5),
                Text(invoice.invoiceUrl!),
              ],
            ),
            Text('OverDuo: ${invoice.overDuo}'),
          ],
        ),
      ),
    );
  }
}
