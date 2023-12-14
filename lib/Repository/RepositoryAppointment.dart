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
    httpClient.baseUrl = dotenv.env['API_URL'];
    final accessToken = StorageKeys.storagedToken;
    httpClient.timeout = Duration(seconds: 30);
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
      final response = await httpClient.post('appointment/create-appointment',
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
  Future<List<AppointmentModel>> getAppointByUserId(String id) async {
    final response =
        await httpClient.get('appointment/fetch-appointments-by-user/$id');
    if (response.status.isOk) {
      var jsonResponse = await response.body;
      List<dynamic> postList = jsonResponse;
      return postList
          .map<AppointmentModel>((item) => AppointmentModel.fromJson(item))
          .toList();
    }

    if (response.status.hasError) {
      return [];
    }
    if (response.status.isNotFound) {
      return [];
    }
    if (response.status.connectionError) {
      return [];
    }
    print("Body fetch by user id Response:::::::::::::${response.bodyString}");

    throw Exception(response.bodyString);
    // } catch (e) {
    //   throw Exception(e.toString());
    // }
  }

  @override
  Future<AppointmentModel> cancelAppointment(
      String appointmentID, String userId) async {
    final response = await httpClient.post(
        'appointment/fetch-appointments-by-user/$appointmentID',
        body: {"user_id": userId});
    if (response.isOk) {
      var jsonResponse = await response.body;
      print('Compromisso cancelado com suce  sso');
      return jsonResponse;
    } else if (response.statusCode == 403) {
      var jsonResponse = await response.body;
      print('Permissão negada para cancelar o compromisso');
      return jsonResponse;
    } else if (response.statusCode == 404) {
      var jsonResponse = await response.body;
      // Compromisso não encontrado
      print('Compromisso não encontrado');
      return jsonResponse;
    } else {
      var jsonResponse = await response.body;
      print('Erro desconhecido');
      return jsonResponse;
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
  Future<AppointmentModel> updateAppointment(String id) async {
    throw UnimplementedError();
  }
}
