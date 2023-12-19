import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../Controller/InvoiceController.dart';
import '../../../../Utils/Colors.dart';

Widget widgetTherapyInfoCard(
  Color? color,
  String firstname,
  String lastname,
  DateTime date,
  DateTime time,
  int clienteNumber,
  String status,
  String phone,
  String notes,
  DateTime createdAt,
  String? canceledBy,
  Widget invoiceUploadWidget,
) {
  return GetBuilder<InvoiceController>(builder: (invoiceController) {
    return Card(
      color: color,
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
                          'Kunder(in): $firstname $lastname',
                          style: GoogleFonts.lato(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  invoiceUploadWidget,
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
              Container(
                height: 40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Kn: $clienteNumber',
                          style: GoogleFonts.lato(fontSize: 10),
                        ),
                        Text(
                          'Erstellt am: ${createdAt.day}.${createdAt.month}.${createdAt.year}',
                          style: GoogleFonts.lato(fontSize: 10),
                        ),
                      ],
                    ),
                    canceledBy == null || canceledBy.isEmpty
                        ? SizedBox.shrink()
                        : Text(
                            'Termin vom $canceledBy abgesagt',
                            style:
                                GoogleFonts.lato(fontSize: 10, color: vermelho),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  });
}
