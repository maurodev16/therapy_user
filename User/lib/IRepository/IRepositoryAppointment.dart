import 'package:therapy_user/Models/AppointmentModel.dart';

abstract class IRepositoryAppointment {
  Future<AppointmentModel> create(AppointmentModel newAppointment);
  Future<List<AppointmentModel>> getAppointByUserId(String id);
  Future<AppointmentModel> updateAppointment(String appointmentID);
  Future<AppointmentModel> cancelAppointment(
      String appointmentID, String userId);
}
