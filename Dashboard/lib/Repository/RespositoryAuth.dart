import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import '../IRepository/IRepositoryAuth.dart';
import '../Models/UserModel.dart';
import '../Utils/const_storage_keys.dart';

class RepositoryAuth extends GetConnect implements IRepositoryAuth {
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
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await httpClient.post(
          'https://therapy-bv4t.onrender.com/api/v1/auth/login',
          body: {'email': email, 'password': password});
      print(response);

      if (response.status.isOk) {
        Map<String, dynamic> responseData = await response.body;
        UserModel userData = UserModel.fromJson(responseData);
        print("userData: $userData");

        return userData;
      } else {
        return throw Exception(response.bodyString);
      }
    } catch (e) {
      print("Login error: $e");
      throw Exception('An error occurred during Login: $e');
    }
  }
}
