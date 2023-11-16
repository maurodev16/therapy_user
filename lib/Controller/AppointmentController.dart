import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:therapy_user/IRepository/IRepositoryAppointment.dart';
import 'package:therapy_user/Models/AppointmentModel.dart';
import 'package:therapy_user/Models/ServiceTypeModel.dart';

import '../Models/PaymentModel.dart';
import '../Models/RelatedDocumentsModel.dart';
import '../Repository/RespositoryAuth.dart';
import 'AuthController.dart';

class AppointmentController extends GetxController
    with StateMixin<AppointmentModel> {
  final IRepositoryAppointment _irepository;
  AppointmentController(this._irepository);
  final storage = GetStorage();

  ///

  @override
  void onInit() {
    super.onInit();
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
  final AuthController authController =
      Get.put<AuthController>(AuthController(RepositoryAuth()));
  RxString id = ''.obs;
  Rx<DateTime> selectedData = DateTime.now().obs;
  Rx<DateTime> selectedTime = DateTime.now().obs;
  RxString notes = ''.obs;
  RxList<ServiceTypeModel> serviceTypeModel = <ServiceTypeModel>[].obs;
  RxList<PaymentModel> paymentModel = <PaymentModel>[].obs;
  List<RelatedDocumentsModel> relatedDocumentsModel = <RelatedDocumentsModel>[];
  RxBool isCanceled = false.obs;
  Rx<DateTime>? createdAt;
  Rx<DateTime>? updatedAt;
  RxBool isLoading = false.obs;
  RxString appointStatus = 'open'.obs;
  late AppointmentModel appointmentData;

  Future<AppointmentModel?> create() async {
    isLoading.value = true;
    try {
      appointmentData = AppointmentModel(
        date: selectedData.value,
        time: selectedTime.value,
        notes: notes.value,
        userModel: authController.getUserData.value,
        status: appointStatus.value,
      );
      AppointmentModel response = await _irepository.create(appointmentData);
      if (response.id != null) {
        print("TOKEN:::${response.id}");
        print("GET USER DATA ::::::::::::$response");
        // Atualiza o estado com a resposta bem-sucedida
        change(response, status: RxStatus.success());
        return response;
      }
    } catch (e) {
      print(e.toString());
      handleLoginError(e.toString());
    }finally{
      isLoading.value = false;
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
    }  else {
      errorMessage = "Ein unbekannter Fehler ist aufgetreten";
    }
    Fluttertoast.showToast(msg: errorMessage);
    change(null, status: RxStatus.error(errorMessage));
  }
}
