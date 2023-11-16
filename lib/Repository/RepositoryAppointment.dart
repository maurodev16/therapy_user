import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:therapy_user/Models/AppointmentModel.dart';

import '../IRepository/IRepositoryAppointment.dart';
import '../Models/UserModel.dart';
import '../Utils/const_storage_keys.dart';

class RepositoryAppointment extends GetConnect
    implements IRepositoryAppointment {
  @override
  void onInit() async {
    // httpClient.baseUrl = dotenv.env['API_URL'];
    final accessToken = StorageKeys.storagedToken;
    httpClient.timeout = Duration(seconds: 18);
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Authorization'] = 'Bearer $accessToken';
      request.headers['Accept'] = 'application/json';
      defaultContentType = "application/json; charset=utf-8";
      return request;
    });
    super.onInit();
  }

  @override
  Future<AppointmentModel> create(AppointmentModel appointmentModel) async {
    try {
      final response = await httpClient.post(
          'http://localhost:3001/api/v1/appointment/create-appointment',
          body: appointmentModel.toJson());

      if (response.status.isOk) {
        final Map<String, dynamic> responseData = await response.body;

        final newAppointment = AppointmentModel.fromJson(responseData);

        print("responseData::::: $responseData");

        print("Appointment::::: ${newAppointment.id}");

        return newAppointment;
      } else {

        return throw Exception(response.body);
      }
    } catch (e) {
      return throw Exception(e.toString());
    }
  }

  @override
  // ignore: override_on_non_overriding_member
  Future<void> deleteUser(String id) async {}

  @override
  // ignore: override_on_non_overriding_member
  Future<UserModel> editUser(UserModel userModel) async {
    return UserModel();
  }

  @override
  Future<void> deleteAppointment(String id) async {}

  @override
  Future<List<AppointmentModel>> fetchAppointmentByUserId(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<void> updateAppointment(String id) async {
    throw UnimplementedError();
  }
}
