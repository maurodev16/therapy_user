import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:therapy_user/IRepository/IRepositoryAppointment.dart';
import 'package:therapy_user/Models/AppointmentModel.dart';
import 'package:therapy_user/Models/ServiceTypeModel.dart';

import '../Models/PaymentModel.dart';
import '../Models/RelatedDocumentsModel.dart';
import '../Repository/RespositoryAuth.dart';
import '../Utils/Colors.dart';
import 'AuthController.dart';

class AppointmentController extends GetxController
    with StateMixin<AppointmentModel> {
  final IRepositoryAppointment _irepository;
  AppointmentController(this._irepository);
  final storage = GetStorage();
  @override
  void onInit() {
    
    super.onInit();
  }

  final List<String> daysOfWeek =
      ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'].obs;

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
  late final Rx<AppointmentModel> _appointmentData;
  Rx<AppointmentModel> get getAppointmentData => this._appointmentData;
  set setAppointmentData(Rx<AppointmentModel> appointmentData) {
    update();
    this._appointmentData = appointmentData;
  }

  ///
  final AuthController authController =
      Get.put<AuthController>(AuthController(RepositoryAuth()));
  RxString id = ''.obs;
  Rx<DateTime>? selectedData = DateTime.now().obs;
  Rx<DateTime>? selectedTime = DateTime.now().obs;
  RxString notes = ''.obs;
  RxList<ServiceTypeModel> serviceTypeModel = <ServiceTypeModel>[].obs;
  RxList<PaymentModel> paymentModel = <PaymentModel>[].obs;
  List<RelatedDocumentsModel> relatedDocumentsModel = <RelatedDocumentsModel>[];
  RxBool isCanceled = false.obs;
  Rx<DateTime>? createdAt;
  Rx<DateTime>? updatedAt;
  RxBool isLoading = false.obs;
  RxString appointStatus = 'open'.obs;

  Future<AppointmentModel> create() async {
    isLoading.value = true;
    try {
      final newAppointment = AppointmentModel(
        date: selectedData!.value,
        time: selectedTime!.value,
        notes: notes.value,
        userModel: authController.getUserData.value,
        isCanceled: isCanceled.value,
      ).obs;
      AppointmentModel response =
          await _irepository.create(newAppointment.value);
      if (response.id != null) {
        _appointmentData.update((appointment) {
          appointment!.id = response.id;
          appointment.date = response.date;
          appointment.time = response.time;
          appointment.notes = response.notes;
          appointment.userModel = response.userModel;
          appointment.isCanceled = response.isCanceled;
          appointment.createdAt = response.createdAt;
          appointment.updatedAt = response.updatedAt;
          appointment.paymentModel = response.paymentModel;
          appointment.relatedDocumentsModel = response.relatedDocumentsModel;
          appointment.serviceTypeModel = response.serviceTypeModel;
          appointment.status = response.status;
        });
            print("TOKEN:::${response.id}");
          print("GET USER DATA ::::::::::::$getAppointmentData");
       
          Fluttertoast.showToast(
            msg: 'Suppi, Deine Termin wurde erfolgreich gebucht!',
            backgroundColor: verde,
          );
          // Atualiza o estado com a resposta bem-sucedida
          change(response, status: RxStatus.success());
          Get.back();
        return _appointmentData.value;
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
    update();
    return _appointmentData.value;
  }
}
