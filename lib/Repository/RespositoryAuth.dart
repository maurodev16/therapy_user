import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import '../IRepository/IRepositoryAuth.dart';
import '../Models/UserModel.dart';

class RepositoryAuth extends GetConnect implements IRepositoryAuth {
  @override
  void onInit() async {
    httpClient.baseUrl = dotenv.env['API_URL'];
    httpClient.timeout = Duration(seconds: 35);
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Authorization'] = 'Bearer';
      request.headers['Accept'] = 'application/json';

      return request;
    });

    super.onInit();
  }

  @override
  Future<UserModel> login(
      String email, int clientNumber, String password) async {
    try {
      final response = await httpClient.post('user/login', body: {
        'email': email,
        'clientNumber': clientNumber,
        'password': password
      });

      if (response.status.isOk) {
        Map<String, dynamic> responseData = await response.body;

        UserModel user = UserModel.fromJson(responseData);
        return user;
      } else
        return throw Exception(response.body);
    } catch (e) {
      print("Login error: $e");
      throw Exception('An error occurred during Login: $e');
    }
  }
}
