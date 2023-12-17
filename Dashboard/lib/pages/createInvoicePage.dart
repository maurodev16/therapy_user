import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:therapy_dashboard/Controller/InvoiceController.dart';
import 'package:therapy_dashboard/GlobalWidgets/loadingWidget.dart';
import 'package:therapy_dashboard/Models/AppointmentModel.dart';
import 'package:therapy_dashboard/Utils/Colors.dart';

import '../Controller/AppointmentController.dart';
import '../Models/InvoiceModel.dart';

class CreateInvoicePage extends StatelessWidget {
  final AppointmentModel appointment = Get.arguments;
  final invoiceController = Get.find<InvoiceController>();
  final appointmentController = Get.find<AppointmentController>();
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => invoiceController.isLoading.value
          ? Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  loadingWidget(),
                  Text("Rechunug is uploadind, plese wait..")
                ],
              ),
            )
          : Scaffold(
              appBar: AppBar(
                  title: Text('Rechnung erstellen'),
                  leading: IconButton(
                    onPressed: () async {
                      await appointmentController.getSeparateAppoints();
                      await invoiceController.getSeparateInvoice();
                      Get.back();
                    },
                    icon: Icon(Icons.arrow_back_ios_new_outlined),
                  )),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Rechnungsdetails",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      Text(appointment.id!),
                      SizedBox(height: 16),
                      TextFormField(
                        readOnly: true,
                        enabled: false,
                        initialValue:
                            appointment.userModel!.clientNumber.toString(),
                        decoration: InputDecoration(
                          labelText: 'ID',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.assignment_ind_outlined),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        readOnly: true,
                        enabled: false,
                        initialValue:
                            "${appointment.userModel!.firstname} ${appointment.userModel!.lastname}",
                        decoration: InputDecoration(
                          labelText: "Kundenname",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        // Você pode usar um controlador para lidar com os dados de entrada
                        // controller: seuControlador,
                      ),
                      SizedBox(height: 16),
                      Obx(
                        () => InkWell(
                          onTap: InvoiceController.to.isLoading.value == false
                              ? () {
                                  InvoiceController.to.selectDate(context);
                                }
                              : null,
                          child: TextFormField(
                            readOnly: true,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText:
                                  '${InvoiceController.to.rxOverduo.value.day}.${InvoiceController.to.rxOverduo.value.month}.${InvoiceController.to.rxOverduo.value.year}'
                                      .split(' ')[0],
                              border: OutlineInputBorder(),
                              hintText:
                                  '${InvoiceController.to.rxOverduo.value}'
                                      .split(' ')[0],
                              prefixIcon: Icon(Icons.calendar_month),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),

                      Row(
                        children: [
                          Text("Rechnungsstatus:"),
                          SizedBox(width: 10),
                          Obx(
                            () => DropdownButton<String>(
                              value: invoiceController.rxInvoiceStatus.value,
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  invoiceController.rxInvoiceStatus.value =
                                      newValue;
                                  print(
                                      invoiceController.rxInvoiceStatus.value);
                                }
                              },
                              items: invoiceController.statusOptions
                                  .map((String status) {
                                return DropdownMenuItem<String>(
                                  value: status,
                                  child: status == "open"
                                      ? Text("Open")
                                      : status == "paid"
                                          ? Text("Bezahlt")
                                          : status == "refunded"
                                              ? Text("Zurückerstattet")
                                              : status == "overduo"
                                                  ? Text("Überfällig")
                                                  : Text("Open"),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Obx(
                            () => TextButton.icon(
                              label: Text(
                                'Rechnung auswählen',
                                style: GoogleFonts.lato(
                                    fontSize: 15, color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: vermelho),
                              icon: Icon(Icons.upload_file_rounded),
                              onPressed:
                                  InvoiceController.to.isLoading.value == false
                                      ? () {
                                          InvoiceController.to
                                              .pickFileFromGallery();
                                        }
                                      : null,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 5),
                      Obx(
                        () => Text(
                          '${InvoiceController.to.pickedFilename.value}',
                          style: GoogleFonts.lato(fontSize: 10),
                        ),
                      ),
                      SizedBox(height: 25),
                      Obx(
                        () => ElevatedButton(
                          onPressed: InvoiceController.to.getPickedFile !=
                                      null &&
                                  InvoiceController.to.isLoading.value == false
                              ? () {
                                  InvoiceController.to.createInvoice();
                                }
                              : null,
                          child: Text(
                            'Rechnung senden',
                            style: GoogleFonts.lato(fontSize: 15, color: preto),
                          ),
                        ),
                      ),
                      //*************************** */
                      Column(
                        children: [
                          Badge.count(
                            count: appointment.invoiceQnt ?? 0,
                            backgroundColor: vermelho,
                            child: ExpansionTile(
                              title: Text(
                                'Rechnungen von Kunden: ${appointment.userModel!.lastname}',
                                style: GoogleFonts.lato(
                                  fontSize: 12,
                                ),
                              ),
                              children: [
                                // Lista de Faturas
                                ListView.builder(
                                  primary: false,
                                  shrinkWrap: true,
                                  itemCount: appointment.invoicesModel!.length,
                                  itemBuilder: (context, index) {
                                    InvoiceModel invoice =
                                        appointment.invoicesModel![index];
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            // Ícone para o status da fatura (open, completed, etc.)
                                            invoice.overDuo!
                                                    .isAfter(DateTime.now())
                                                ? Icon(Icons.pending,
                                                    color: preto)
                                                : Icon(Icons.pending,
                                                    color: verde),
                                            SizedBox(width: 5),
                                            Expanded(
                                              child: Text(
                                                "${extractFileName(invoice.invoiceUrl!)}",
                                                style: GoogleFonts.lato(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        invoice.overDuo!
                                                    .isAfter(DateTime.now()) ||
                                                invoice.invoiceStatus == "open"
                                            ? Text(
                                                'Diese Rechnung is ab geläuft ',
                                                style: GoogleFonts.lato(
                                                  fontSize: 12,
                                                ),
                                              )
                                            : Text(
                                                'Diese Rechnung läuft am ${invoice.overDuo!.day}.${invoice.overDuo!.month}.${invoice.overDuo!.year} ab: ',
                                                style: GoogleFonts.lato(
                                                  fontSize: 12,
                                                ),
                                              ),
                                        // Botão de Download
                                        ElevatedButton(
                                          onPressed: () async {
                                            await _showPdfPopup(
                                                context, invoice.invoiceUrl!);
                                          },
                                          child: Text('Rechnung Viewer'),
                                        ),
                                        Divider(), // Adicione uma linha de divisão entre as faturas
                                      ],
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
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

Future<void> _showPdfPopup(BuildContext context, String pdfUrl) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Rechnung Viewer"),
        content: Container(
          width: double.maxFinite,
          height: Get.width,
          child: SfPdfViewer.network("$pdfUrl"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Schließen"),
          ),
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () async {},
          )
        ],
      );
    },
  );
}

class StatusDropdown extends StatefulWidget {
  final String initialValue;
  final Function(String) onChanged;

  StatusDropdown({required this.initialValue, required this.onChanged});

  @override
  _StatusDropdownState createState() => _StatusDropdownState();
}

class _StatusDropdownState extends State<StatusDropdown> {
  late String _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _selectedStatus,
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedStatus = newValue;
            widget.onChanged(newValue);
          });
        }
      },
      items: ["open", "paid", "refunded", "overduo"].map((String status) {
        return DropdownMenuItem<String>(
          value: status,
          child: Text(status),
        );
      }).toList(),
    );
  }
}
