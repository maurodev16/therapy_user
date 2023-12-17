
import '../Models/AppointmentModel.dart';


abstract class IRepositoryAppointment {
  Future<AppointmentModel> create(AppointmentModel newAppointment);
  Future<List<AppointmentModel>> getAllAppoint();
  Future<void> updateAppointment(String id);
  Future<void> deleteAppointment(String id);
}
