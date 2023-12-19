import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:therapy_user/Controller/AuthController.dart';
import '../IRepository/IRepositoryAppointment.dart';
import '../Models/AppointmentModel.dart';
import '../Models/RelatedDocumentsModel.dart';
import '../Models/ServiceTypeModel.dart';
import '../Utils/Colors.dart';

class AppointmentController extends GetxController
    with StateMixin<List<AppointmentModel>> {
  final IRepositoryAppointment _irepository;
  AppointmentController(this._irepository);
  final storage = GetStorage();
  final auth = Get.find<AuthController>();
  RxList<AppointmentModel> allAppoint = <AppointmentModel>[].obs;
  RxList<AppointmentModel> openAppoint = <AppointmentModel>[].obs;
  RxList<AppointmentModel> doneAppoint = <AppointmentModel>[].obs;
  RxList<AppointmentModel> canceledAppoint = <AppointmentModel>[].obs;

  ////
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
  Rx<AppointmentModel> _appointmentData = AppointmentModel().obs;
  AppointmentModel get appointmentData => this._appointmentData.value;

  set appointmentData(AppointmentModel value) =>
      this._appointmentData.value = value;

  @override
  void onInit() async {
    await getSeparateAppoints(auth.getUserData.value.userId!);
    super.onInit();
  }

  Future<List<AppointmentModel>> getSeparateAppoints(String userId) async {
    isLoading.value = true;
    try {
      var response = await _irepository.getAppointByUserId(userId);

      if (response.isNotEmpty) {
        // Limpe as listas existentes.
        allAppoint.clear();
        openAppoint.clear();
        doneAppoint.clear();
        canceledAppoint.clear();

        for (AppointmentModel appointment in response) {
          allAppoint.add(appointment);
          // Verifique se o usuário atual é o criador do compromisso
          if (appointment.userModel!.userId == userId) {
            appointment.status!.contains("open")
                ? openAppoint.add(appointment)
                : appointment.status!.contains("done")
                    ? doneAppoint.add(appointment)
                    : appointment.status!.contains("canceled")
                        ? canceledAppoint.add(appointment)
                        : allAppoint.add(appointment);
          }
        }

        change(response, status: RxStatus.success());
      } else {
        allAppoint.value = [];
        openAppoint.value = [];
        doneAppoint.value = [];
        canceledAppoint.value = [];
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
      _appointmentData.value = AppointmentModel(
        date: selectedData.value,
        time: selectedTime.value,
        notes: notes.value,
        userModel: auth.getUserData.value,
        status: appointStatus.value,
      );
      AppointmentModel response =
          await _irepository.create(_appointmentData.value);
      _appointmentData.value.id = response.id;
      _appointmentData.value.serviceTypeModel = response.serviceTypeModel;

      if (response.id != null) {
        print("Appointment ID response:::${response.id}");
        change([], status: RxStatus.success());
        Fluttertoast.showToast(
          msg: 'Suppi, Deine Termin wurde erfolgreich gebucht!',
          backgroundColor: verde,
        );

        Get.back();
        reloadAppointmentdata();
        update();

        return response;
      }
    } catch (e) {
      print(e.toString());

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

  Future<AppointmentModel> cancelAppointment(
      String appointmentId, String userId) async {
    // try {
    AppointmentModel response =
        await _irepository.cancelAppointment(appointmentId, userId);
    if (response.id!.isEmpty) {
      change([], status: RxStatus.success());
    } else {}
    return response;
    // } catch (error) {
    // Tratamento de erro, se necessário
    //print('Erro no cancelamento: $error');
    //}
  }

  Future<void> reloadAppointmentdata() async {
    await getSeparateAppoints(auth.getUserData.value.userId!);
  }
}
