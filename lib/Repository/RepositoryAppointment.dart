import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:therapy_user/Models/AppointmentModel.dart';

import '../IRepository/IRepositoryAppointment.dart';
import '../Models/UserModel.dart';

class RepositoryAppointment extends GetConnect
    implements IRepositoryAppointment {
  @override
  void onInit() async {
    httpClient.baseUrl = dotenv.env['API_URL'];
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Authorization'] = 'Bearer';
      request.headers['Accept'] = 'application/json';
      defaultContentType = "application/json; charset=utf-8";
      httpClient.timeout = Duration(seconds: 18);

      return request;
    });
    super.onInit();
  }
  
  @override
  Future<AppointmentModel> create(AppointmentModel newAppointment) async {
    try {
      final response = await httpClient.post('appointment/create',
          body: newAppointment.toJson());

      if (response.status.isOk) {
        final Map<String, dynamic> responseData = await response.body;

        final newAppointment =
            AppointmentModel.fromJson(responseData['newAppointment']);

        print("responseData::::: ${responseData['newAppointment']}");

        print("Appointment::::: ${newAppointment.id}");

        return newAppointment;
      } else {
        print("Signup error: ${response.statusText}");
        return throw Exception(response.body);
      }
    } catch (e) {
      print("Login error: $e");
      throw Exception('An error occurred during Signup: $e');
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
