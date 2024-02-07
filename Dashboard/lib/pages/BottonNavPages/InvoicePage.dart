import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:therapy_dashboard/GlobalWidgets/loadingWidget.dart';
import 'package:therapy_dashboard/Utils/Colors.dart';

import '../../Controller/InvoiceController.dart';
import '../../Models/InvoiceModel.dart';

class InvoicePage extends StatelessWidget {
  final InvoiceController invoiceController = Get.find();
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
                      text: '${invoiceController.openInvoices.length} Offene',
                      icon: Hero(
                          tag: "tagVermelho",
                          child: Icon(Icons.pending, color: verde, size: 25))),
                  Tab(
                    text: '${invoiceController.paidInvoices.length} Bezahlt',
                    icon: Hero(
                      tag: "tgVerde",
                      child: Icon(Icons.pending, color: amarelo, size: 25),
                    ),
                  ),
                  Tab(
                      text:
                          '${invoiceController.stornedInvoices.length} Storniert',
                      icon: Hero(
                          tag: "tagAzul",
                          child: Icon(Icons.pending, color: azul, size: 25))),
                  Tab(
                      text:
                          '${invoiceController.overdueInvoices.length} überfällig',
                      icon: Hero(
                          tag: "tagPreto",
                          child: Icon(Icons.pending, color: preto, size: 25))),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Content of "Open" tab
                  OpenInvoiceListView(status: 'Open'),

                  // Content of "completed" tab
                  PaidInvoiceListView(status: 'Paid'),

                  // Content of "Pending" tab
                  RefundedInvoiceListView(status: 'Refunded'),

                  //Content of "Overduo" tab
                  OverDuoInvoiceListView(status: 'OverDuo'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///
class OpenInvoiceListView extends StatelessWidget {
  final InvoiceController invoiceController = Get.find();
  final String status;

  OpenInvoiceListView({required this.status});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => invoiceController.isOpenInvoicesLoading.value
          ? Center(
              child: loadingWidget(),
            )
          : invoiceController.status.isError
              ? Center(
                  child: Icon(Icons.error_outline_rounded),
                )
              : invoiceController.status.isSuccess
                  ? ListView.builder(
                      itemCount: invoiceController.openInvoices.length,
                      itemBuilder: (context, index) {
                        InvoiceModel invoice =
                            invoiceController.openInvoices[index];
                        return invoiceController.status.isEmpty
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
                            : InvoiceCard(invoice: invoice);
                      },
                    )
                  : SizedBox.shrink(),
    );
  }
}

///
class PaidInvoiceListView extends StatelessWidget {
  final InvoiceController invoiceController = Get.find();
  final String status;

  PaidInvoiceListView({required this.status});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        itemCount: invoiceController.paidInvoices.length,
        itemBuilder: (context, index) {
          InvoiceModel invoice = invoiceController.paidInvoices[index];
          return invoiceController.isPaidInvoicesLoading.value
              ? Center(
                  child: loadingWidget(),
                )
              : invoiceController.paidInvoices.isEmpty
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
                  : invoiceController.status.isError
                      ? Center(
                          child: Icon(Icons.error_outline_rounded),
                        )
                      : invoiceController.status.isSuccess
                          ? InvoiceCard(invoice: invoice)
                          : SizedBox.shrink();
        },
      ),
    );
  }
}

//////
class RefundedInvoiceListView extends StatelessWidget {
  final InvoiceController invoiceController = Get.find();
  final String status;

  RefundedInvoiceListView({required this.status});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListView.builder(
        itemCount: invoiceController.stornedInvoices.length,
        itemBuilder: (context, index) {
          InvoiceModel invoice = invoiceController.stornedInvoices[index];
          return invoiceController.isStornedInvoicesLoading.value
              ? Center(
                  child: loadingWidget(),
                )
              : invoiceController.stornedInvoices.isEmpty
                  ? Center(child: Icon(Icons.document_scanner))
                  : invoiceController.status.isError
                      ? Center(
                          child: Icon(Icons.error_outline_rounded),
                        )
                      : invoiceController.status.isSuccess
                          ? InvoiceCard(invoice: invoice)
                          : SizedBox.shrink();
        },
      ),
    );
  }
}

//////
class OverDuoInvoiceListView extends StatelessWidget {
  final InvoiceController invoiceController = Get.find();
  final String status;

  OverDuoInvoiceListView({required this.status});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: invoiceController.overdueInvoices.length,
      itemBuilder: (context, index) {
        InvoiceModel invoice = invoiceController.overdueInvoices[index];
        return invoiceController.isOverdueInvoicesLoading.value
            ? Center(
                child: loadingWidget(),
              )
            : invoiceController.overdueInvoices.isEmpty
                ? Center(
                    child: Icon(
                    Icons.document_scanner,
                  ))
                : invoiceController.status.isError
                    ? Center(
                        child: Icon(Icons.error_outline_rounded),
                      )
                    : invoiceController.status.isSuccess
                        ? InvoiceCard(invoice: invoice)
                        : SizedBox.shrink();
      },
    );
  }
}

///
class InvoiceCard extends StatelessWidget {
  final InvoiceModel invoice;

  InvoiceCard({required this.invoice});

  @override
  Widget build(BuildContext context) {
    late Icon icon;

    switch (invoice.invoiceStatus) {
      case 'open':
        icon = Icon(Icons.pending, color: verde);
        break;
      case 'paid':
        icon = Icon(Icons.pending, color: amarelo);
        break;
      case 'refunded':
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
                        icon,
                        SizedBox(width: 5),
                      ],
                    ),
                  )
                ],
              ),
              Text(
                  'Kunder: ${invoice.userObj!.firstname} ${invoice.userObj!.lastname}'),
              Text('Status: ${invoice.invoiceStatus}'),
              Text(
                "${extractFileName(invoice.invoiceUrl!)}",
                style: GoogleFonts.lato(fontSize: 12),
              ),
              Text(
                  'Fälligkeitsdatum: ${invoice.overDuo!.day}.${invoice.overDuo!.month}.${invoice.overDuo!.year}'),
            ],
          ),
        ),
      ),
    );
  }
}

String extractFileName(String url) {
  int lastIndex = url.lastIndexOf("-");
  if (lastIndex != -1) {
    return url.substring(lastIndex + 1);
  } else {
    return url;
  }
}
