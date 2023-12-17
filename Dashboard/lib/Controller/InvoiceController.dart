import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:therapy_dashboard/IRepository/IRepositoryInvoice.dart';
import 'package:therapy_dashboard/Models/InvoiceModel.dart';
import 'package:therapy_dashboard/pages/BottonNavPages/InvoicePage.dart';

import '../Models/AppointmentModel.dart';
import '../Utils/Colors.dart';

class InvoiceController extends GetxController
    with StateMixin<List<InvoiceModel>> {
  final IRepositoryInvoice _repositoryInvoice;
  InvoiceController(this._repositoryInvoice);
  static InvoiceController get to => Get.find();
  List<InvoiceModel> allInvoices = <InvoiceModel>[].obs;
  List<InvoiceModel> openInvoices = <InvoiceModel>[].obs;
  List<InvoiceModel> paidInvoices = <InvoiceModel>[].obs;
  List<InvoiceModel> stornedInvoices = <InvoiceModel>[].obs;
  List<InvoiceModel> overdueInvoices = <InvoiceModel>[].obs;
  RxBool isAllInvoiceLoading = false.obs;
  RxBool isOpenInvoicesLoading = false.obs;
  RxBool isPaidInvoicesLoading = false.obs;
  RxBool isStornedInvoicesLoading = false.obs;
  RxBool isOverdueInvoicesLoading = false.obs;

  RxString pickedFilename = "".obs;
  Rx<DateTime> rxOverduo = DateTime.now().obs;
  RxString rxInvoiceStatus = "open".obs;
  RxBool isLoading = false.obs;
  late Rx<InvoiceModel> _invoiceModel = InvoiceModel().obs;
  Rx<InvoiceModel> get getInvoiceData => this._invoiceModel;
  set setInvoiceData(Rx<InvoiceModel> invoiceData) =>
      this._invoiceModel = invoiceData;
  final List<String> statusOptions = ["open", "paid", "refunded", "overduo"];

  @override
  void onInit() async {
    await getSeparateInvoice();
    super.onInit();
  }

  Rx<AppointmentModel> appointmentModel = AppointmentModel().obs;
// Método para receber os dados do agendamento
  void receiveAppointmentData(AppointmentModel appointment) {
    appointmentModel.value = appointment;
    print(
        "Dados do agendamento recebidos: ${appointment.userModel?.firstname}, ${appointment.id},");
    print("${appointmentModel.value.id}");
  }

  Future<InvoiceModel> createInvoice() async {
    isLoading.value = true;
    try {
      if (_pickedFile.value != null) {
        final invoiceModel = InvoiceModel(
          userObj: appointmentModel.value.userModel,
          appointmentObj: appointmentModel.value,
          overDuo: rxOverduo.value,
          invoiceStatus: rxInvoiceStatus.value,
        ).obs;
        InvoiceModel? createdInvoice = await _repositoryInvoice.create(
            invoiceModel.value, _pickedFile.value!);
        if (createdInvoice.id!.isNotEmpty) {
          change([], status: RxStatus.success());
          Fluttertoast.showToast(
            msg:
                "Rechnung erfolgreich an Benutzer ${createdInvoice.appointmentObj!.userModel!.lastname} gesendet.",
            gravity: ToastGravity.TOP,
            backgroundColor: preto,
            fontSize: 12,
            textColor: vermelho,
          );
          Get.to(() => InvoicePage());
          print('Novo invoice ID: ${createdInvoice.id}');
          _invoiceModel.update((invoice) {
            invoice!.id = createdInvoice.id;
            invoice.createBy = createdInvoice.createBy;
            invoice.invoiceUrl = createdInvoice.invoiceUrl;
            invoice.overDuo = createdInvoice.overDuo;
            invoice.invoiceStatus = createdInvoice.invoiceStatus;
            invoice.appointmentObj = createdInvoice.appointmentObj;
            invoice.userObj = createdInvoice.userObj;
          });
          print(createdInvoice);
          return createdInvoice;
        }
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.value = false;
    }

    return _invoiceModel.value;
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (pickedDate == null) {
      return;
    } else {
      rxOverduo.value = pickedDate;
    }

    update();
  }

  // Método para separar os pagamentos vencidos e os pedidos de estorno
  Future<List<InvoiceModel>> getSeparateInvoice() async {
    isAllInvoiceLoading.value = true;
    isOpenInvoicesLoading.value = true;
    isPaidInvoicesLoading.value = true;
    isStornedInvoicesLoading.value = true;
    isOverdueInvoicesLoading.value = true;

    try {
      var response = await _repositoryInvoice.getAllInvoice();
      if (response.isNotEmpty) {
        allInvoices.clear();
        openInvoices.clear();
        paidInvoices.clear();
        stornedInvoices.clear();
        overdueInvoices.clear();
        for (InvoiceModel invoice in response) {
          allInvoices.add(invoice);
          if (invoice.invoiceStatus!.contains("open")) {
            openInvoices.add(invoice);
          } else if (invoice.invoiceStatus!.contains("paid")) {
            paidInvoices.add(invoice);
          } else if (invoice.invoiceStatus!.contains("refunded")) {
            stornedInvoices.add(invoice);
          } else if (invoice.invoiceStatus!.contains("overduo")) {
            overdueInvoices.add(invoice);
          } else {
            allInvoices.add(invoice);
          }
        }
        change(response, status: RxStatus.success());
      } else {
        change([], status: RxStatus.empty());
        allInvoices = [];
        openInvoices = [];
        paidInvoices = [];
        stornedInvoices = [];
        overdueInvoices = [];
        return [];
      }
    } catch (e) {
      change([], status: RxStatus.error());
      print(e.toString());
    } finally {
      isAllInvoiceLoading.value = false;
      isOpenInvoicesLoading.value = false;
      isPaidInvoicesLoading.value = false;
      isStornedInvoicesLoading.value = false;
      isOverdueInvoicesLoading.value = false;
      update();
    }
    return allInvoices;
  }

  Rx<XFile?> _pickedFile = Rx<XFile?>(null);
  String? _base64File;

  XFile? get getPickedFile {
    return _pickedFile.value;
  }

  set setPickedFile(XFile? pickedFile) {
    this._pickedFile.value = pickedFile;
  }

  String? get base64File => _base64File;

  Future<void> pickFileFromGallery() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      final pickedFile = XFile(result.files.first.path!);
      _pickedFile.value = pickedFile;
      pickedFilename.value = pickedFile.name;
      print("${_pickedFile.value}");
      final fileBytes = await pickedFile.readAsBytes();
      _base64File = base64Encode(fileBytes);
    } else {
      update();
      return null;
    }

    update();
  }
}
