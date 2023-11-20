import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:therapy_user/IRepository/IRepositoryAppointment.dart';
import 'package:therapy_user/Models/AppointmentModel.dart';
import 'package:therapy_user/Models/ServiceTypeModel.dart';
import 'package:therapy_user/Utils/Colors.dart';

import '../Models/RelatedDocumentsModel.dart';
import '../Repository/RespositoryAuth.dart';
import 'AuthController.dart';

class AppointmentController extends GetxController
    with StateMixin<List<AppointmentModel>> {
  final IRepositoryAppointment _irepository;
  AppointmentController(this._irepository);
  final storage = GetStorage();
  final AuthController authController =
      Get.put<AuthController>(AuthController(RepositoryAuth()));
  late final RxList<AppointmentModel> allAppoint=<AppointmentModel>[].obs;
  final RxList<AppointmentModel> openAppoint = <AppointmentModel>[].obs;
  RxList<AppointmentModel> closedAppoint = <AppointmentModel>[].obs;
  RxList<AppointmentModel> reversalAppoint = <AppointmentModel>[].obs;

  ///

  @override
  void onInit() async {
  allAppoint.value=  await getAppointByUserId(authController.getUserData.value.userId!);
    await separateAppoints();
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

  RxString id = ''.obs;
  Rx<DateTime> selectedData = DateTime.now().obs;
  Rx<DateTime> selectedTime = DateTime.now().obs;
  RxString notes = ''.obs;
  RxList<ServiceTypeModel> serviceTypeModel = <ServiceTypeModel>[].obs;
  List<RelatedDocumentsModel> relatedDocumentsModel = <RelatedDocumentsModel>[];
  RxBool isCanceled = false.obs;
  Rx<DateTime>? createdAt;
  Rx<DateTime>? updatedAt;
  RxBool isLoading = false.obs;
  RxString appointStatus = 'open'.obs;
  late AppointmentModel appointmentData;

  Future<AppointmentModel?> create() async {
    isLoading.value = true;
    update();

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

  ///
  RxString errorMessage = "".obs;
  Future<List<AppointmentModel>> getAppointByUserId(String id) async {
    try {
      isLoading.value = true;
      var response = await _irepository.getAppointByUserId(id);
      if (response.isEmpty) {
        change([], status: RxStatus.empty());
        allAppoint.refresh();
        allAppoint.value = [];
        errorMessage.value = "No Appointment for this User";
        change(null, status: RxStatus.empty());
        update();
        return [];
      } else {
        allAppoint.refresh();
        allAppoint.assignAll(response);
        change(response, status: RxStatus.success());
        update();

        print("ALL POSTS::::::::::::::::::::$response");
        return allAppoint;
      }
    } catch (e) {
      change(null, status: RxStatus.error("${e.toString()}"));

      print("ERROR::::::.*********${e.toString()}");
      return [];
    } finally {
      isLoading.value = false;
    }
  }

  List<AppointmentModel> getAppointByStatus(String status) {
    return [
      
      AppointmentModel(
          time: DateTime(2023, 11, 14),
          date: DateTime(2023, 11, 14),
          status: status),
      AppointmentModel(
          time: DateTime(2023, 11, 14),
          date: DateTime(2023, 11, 14),
          status: status),
      AppointmentModel(
          time: DateTime(2023, 11, 14),
          date: DateTime(2023, 11, 14),
          status: status),
      AppointmentModel(
          time: DateTime(2023, 11, 14),
          date: DateTime(2023, 11, 14),
          status: status),
      AppointmentModel(
          time: DateTime(2023, 11, 14),
          date: DateTime(2023, 11, 14),
          status: status),
      AppointmentModel(
          time: DateTime(2023, 11, 14),
          date: DateTime(2023, 11, 14),
          status: status),
      AppointmentModel(
          time: DateTime(2023, 11, 14),
          date: DateTime(2023, 11, 14),
          status: status),
      AppointmentModel(
          time: DateTime(2023, 11, 14),
          date: DateTime(2023, 11, 14),
          status: status),
      AppointmentModel(
          time: DateTime(2023, 11, 14),
          date: DateTime(2023, 11, 14),
          status: status),
    ].obs;
  }

  bool isAppointOpen(AppointmentModel appointmentModel) {
    // Verifica se ainda vai passar do prazo
    return appointmentModel.date!.isAfter(DateTime.now());
  }

  // Método para separar os Abertos Fechados e os pedidos de Cancelado
  Future<void> separateAppoints() async {
    for (AppointmentModel appointment in openAppoint) {
      bool isOpen = isAppointOpen(appointment);
      if (isOpen) {
        // Adicionar à lista de pagamentos vencidos
        closedAppoint.add(appointment);
      } else {
        // Adicionar à lista de pedidos de estorno (se necessário)
        if (appointment.status == 'Reversal') {
          reversalAppoint.add(appointment);
        }
      }
      update();
    }
  }
}
