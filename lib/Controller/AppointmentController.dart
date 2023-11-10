import 'package:get/get.dart';

class AppointmentController extends GetxController {
  static AppointmentController get to => Get.find();
// final MyRepository repository;
// AppointmentController(this.repository);

  final List<String> daysOfWeek =
      ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'].obs;

  final List<String> availableTimes = [
    '08:00 AM',
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '13:00 PM',
    '14:00 PM',
    '15:00 PM',
    '16:00 PM',
    '17:00 PM',
    '18:00 PM',
  ].obs;

  final RxString selectedDay = ''.obs;
  final RxString selectedTime = ''.obs;

  // Simulação de datas já agendadas (em vermelho)
  final List<DateTime> bookedDates = [
    DateTime.now().add(Duration(days: 2)),
    DateTime.now().add(Duration(days: 10)),
    DateTime.now().add(Duration(days: 15)),
  ].obs;
}
