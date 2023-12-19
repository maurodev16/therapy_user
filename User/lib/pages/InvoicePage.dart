import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../Controller/InvoiceController.dart';
import '../../Models/InvoiceModel.dart';
import '../GlobalWidgets/loadingWidget.dart';
import '../Utils/Colors.dart';

final RxDouble _progress = 0.0.obs;

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
          : invoiceController.status.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/images/open.png",
                        height: 50,
                        width: 50,
                        color: cinza,
                      ),
                    ),
                    Text(
                      "Sie haben keine offene Rechnung",
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
                      ? ListView.builder(
                          itemCount: invoiceController.openInvoices.length,
                          itemBuilder: (context, index) {
                            InvoiceModel invoice =
                                invoiceController.openInvoices[index];
                            return InvoiceCard(invoice: invoice);
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
      () => invoiceController.isPaidInvoicesLoading.value
          ? Center(
              child: loadingWidget(),
            )
          : invoiceController.paidInvoices.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/images/paid.png",
                        height: 50,
                        width: 50,
                        color: cinza,
                      ),
                    ),
                    Text(
                      "Nichts zu sehen",
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
                      ? ListView.builder(
                          itemCount: invoiceController.paidInvoices.length,
                          itemBuilder: (context, index) {
                            InvoiceModel invoice =
                                invoiceController.paidInvoices[index];
                            return InvoiceCard(invoice: invoice);
                          },
                        )
                      : SizedBox.shrink(),
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
      () => invoiceController.isStornedInvoicesLoading.value
          ? Center(
              child: loadingWidget(),
            )
          : invoiceController.stornedInvoices.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/images/storned.png",
                        height: 50,
                        width: 50,
                        color: cinza,
                      ),
                    ),
                    Text(
                      "Nichts zu sehen",
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
                      ? ListView.builder(
                          itemCount: invoiceController.stornedInvoices.length,
                          itemBuilder: (context, index) {
                            InvoiceModel invoice =
                                invoiceController.stornedInvoices[index];
                            return InvoiceCard(invoice: invoice);
                          },
                        )
                      : SizedBox.shrink(),
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
    return Obx(
      () => invoiceController.isOverdueInvoicesLoading.value
          ? Center(
              child: loadingWidget(),
            )
          : invoiceController.overdueInvoices.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/images/storned.png",
                        height: 50,
                        width: 50,
                        color: cinza,
                      ),
                    ),
                    Text(
                      "Nichts zu sehen",
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
                      ? ListView.builder(
                          itemCount: invoiceController.overdueInvoices.length,
                          itemBuilder: (context, index) {
                            InvoiceModel invoice =
                                invoiceController.overdueInvoices[index];
                            return InvoiceCard(invoice: invoice);
                          },
                        )
                      : SizedBox.shrink(),
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

    return GestureDetector(
      onTap: () async {
        await _showPdfPopup(
          context,
          invoice.userObj!.firstname!,
          invoice.userObj!.lastname!,
          invoice.invoiceStatus!,
          invoice.invoiceUrl!, //Pegando apenas o nome do arquivo
          invoice.invoiceUrl!,
        );
      },
      child: Card(
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
      ),
    );
  }
}

Future<void> _showPdfPopup(
  BuildContext context,
  String firstName,
  String lastName,
  String status,
  String _invoiceName,
  String pdfUrl,
) async {
  _invoiceName = pdfUrl;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Rechnung Viewer"),
        content: Container(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            children: [
              Text("$firstName $lastName"),
              Text(status),
              Expanded(child: SfPdfViewer.network("$pdfUrl")),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Schließen"),
          ),
          Obx(
            () => IconButton(
              icon: _progress.value == 0.0
                  ? Icon(Icons.download)
                  : CircularProgressIndicator(
                      value: _progress.value,
                      strokeWidth: _progress.value,
                      strokeAlign: _progress.value,
                      color: Colors.pink,
                    ),
              onPressed: () async {
                await FileDownloader.downloadFile(
                  url: pdfUrl,
                  onProgress: (_invoiceName, progress) {
                    _progress.value = progress;

                    print(_progress.value);
                  },
                  onDownloadCompleted: (value) {
                    print('path: $value');
                    Fluttertoast.showToast(
                      msg: "$value",
                      gravity: ToastGravity.CENTER,
                      fontSize: 32,
                    );
                    _progress.value = 0.0;
                  },
                  name: extractFileName(_invoiceName),
                  notificationType: NotificationType.progressOnly,
                  onDownloadError: (error) {
                    Fluttertoast.showToast(msg: "Error Downloading.: $error");
                  },
                  downloadDestination: DownloadDestinations.publicDownloads,
                );
                Fluttertoast.showToast(msg: "PDF wurde heruntergeladen.");
              },
            ),
          ),
        ],
      );
    },
  );
}

String extractFileName(String url) {
  int lastIndex = url.lastIndexOf("-");
  if (lastIndex != -1) {
    return url.substring(lastIndex + 1);
  } else {
    return url;
  }
}
