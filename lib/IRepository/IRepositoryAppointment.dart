
import 'package:therapy_user/Models/AppointmentModel.dart';


abstract class IRepositoryAppointment {
  Future<AppointmentModel> create(AppointmentModel newAppointment);
  Future<List<AppointmentModel>> getAppointByUserId(String id);
  Future<void> updateAppointment(String id);
  Future<void> deleteAppointment(String id);
}
