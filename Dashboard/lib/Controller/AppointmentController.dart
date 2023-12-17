import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../IRepository/IRepositoryAppointment.dart';
import '../Models/AppointmentModel.dart';
import '../Models/ServiceTypeModel.dart';
import '../Utils/Colors.dart';
import 'AuthController.dart';
import 'InvoiceController.dart';

class AppointmentController extends GetxController
    with StateMixin<List<AppointmentModel>> {
  final IRepositoryAppointment _irepository;
  AppointmentController(this._irepository);
  final storage = GetStorage();
  RxList<AppointmentModel> allAppoint = <AppointmentModel>[].obs;
  RxList<AppointmentModel> openAppoint = <AppointmentModel>[].obs;
  RxList<AppointmentModel> doneAppoint = <AppointmentModel>[].obs;
  RxList<AppointmentModel> canceledAppoint = <AppointmentModel>[].obs;
  final auth = Get.find<AuthController>();
  final InvoiceController invoiceController = Get.find();

  ////
  RxString id = ''.obs;
  Rx<DateTime> selectedData = DateTime.now().obs;
  Rx<DateTime> selectedTime = DateTime.now().obs;
  RxString notes = ''.obs;
  RxList<ServiceTypeModel> serviceTypeModel = <ServiceTypeModel>[].obs;
  RxBool isCanceled = false.obs;
  Rx<DateTime>? createdAt;
  Rx<DateTime>? updatedAt;
  RxBool isLoading = false.obs;
  RxString appointStatus = 'open'.obs;
  late AppointmentModel appointmentData;

  @override
  void onInit() async {
    await getSeparateAppoints();
    await invoiceController.getSeparateInvoice();
    super.onInit();
  }

  Future<List<AppointmentModel>> getSeparateAppoints() async {
    isLoading.value = true;
    try {
      var response = await _irepository.getAllAppoint();

      if (response.isNotEmpty) {
        // Limpe as listas existentes.
        allAppoint.clear();
        openAppoint.clear();
        doneAppoint.clear();
        canceledAppoint.clear();

        for (AppointmentModel appointment in response) {
          allAppoint.add(appointment);
          appointment.status!.contains("open")
              ? openAppoint.add(appointment)
              : appointment.status!.contains("done")
                  ? doneAppoint.add(appointment)
                  : appointment.status!.contains("canceled")
                      ? canceledAppoint.add(appointment)
                      : allAppoint.add(appointment);
        }

        change(response, status: RxStatus.success());
      } else {
        change([], status: RxStatus.empty());
        // Limpe as listas existentes.
        return [];
      }
    } catch (e) {
      change([], status: RxStatus.error());
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
    return allAppoint;
  }

  final List<String> timeStrings = [
    '08:00',
    '09:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
    '18:00',
  ];

  // Simulação de datas já agendadas (em vermelho)
  final List<DateTime> bookedDates = [
    DateTime.now().add(Duration(days: 2)),
    DateTime.now().add(Duration(days: 10)),
    DateTime.now().add(Duration(days: 15)),
  ].obs;

  ///

  Future<AppointmentModel?> create() async {
    isLoading.value = true;
    update();

    try {
      appointmentData = AppointmentModel(
        date: selectedData.value,
        time: selectedTime.value,
        notes: notes.value,
        userModel: auth.getUserData.value,
        status: appointStatus.value,
      );
      AppointmentModel response = await _irepository.create(appointmentData);
      if (response.id != null) {
        print("TOKEN:::${response.id}");
        print("GET USER DATA ::::::::::::$response");
        // Atualiza o estado com a resposta bem-sucedida
        change([], status: RxStatus.success());
        update();

        return response;
      }
    } catch (e) {
      print(e.toString());
      handleLoginError(e.toString());
      update();
    } finally {
      isLoading.value = false;
      update();
    }
    update();
    return appointmentData;
  }

  Future<void> handleLoginError(error) async {
    String errorMessage;
    if (error.toString().contains("DATA_END_TIME_NOT_AVAIABLE")) {
      errorMessage = "Datum und Uhrzeit nicht verfügbar!";
    } else if (error.toString().contains("ERROR_CREATE_APPOINT")) {
      errorMessage = "Fehler bei der Terminvereinbarung";
    } else {
      errorMessage = "Ein unbekannter Fehler ist aufgetreten";
    }

    Fluttertoast.showToast(
      msg: errorMessage,
      gravity: ToastGravity.TOP,
      backgroundColor: preto,
      fontSize: 12,
      textColor: vermelho,
    );
    change(null, status: RxStatus.error(errorMessage));
    update();
  }
}
