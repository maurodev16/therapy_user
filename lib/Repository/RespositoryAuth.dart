import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import '../IRepository/IRepositoryAuth.dart';
import '../Models/UserModel.dart';

class RepositoryAuth extends GetConnect implements IRepositoryAuth {
  @override
  void onInit() async {
   // httpClient.baseUrl=dotenv.env['API_URL'];
   
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Authorization'] = 'Bearer';
      request.headers['Accept'] = 'application/json';
    httpClient.timeout = Duration(seconds: 18);

      return request;
    });

    super.onInit();
  }

  @override
  Future<UserModel> login(String email, String password) async {
try {
    final response = await httpClient
        .post('https://therapy-bv4t.onrender.com/api/v1/auth/login', body: {'email': email, 'password': password});
    print(response);

    if (response.status.isOk) {
      Map<String, dynamic> responseData = await response.body;
      print("LoogedIn: $responseData");
      return UserModel.fromJson(responseData);
    } else {
      return throw Exception(response.statusText);
    }

     } catch (e) {
     print("Login error: $e");
     throw Exception('An error occurred during Login: $e');
     }
  }
}
