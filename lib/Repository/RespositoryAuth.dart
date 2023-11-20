import 'package:get/get.dart';

import '../IRepository/IRepositoryAuth.dart';
import '../Models/UserModel.dart';
import '../Utils/const_storage_keys.dart';

class RepositoryAuth extends GetConnect implements IRepositoryAuth {
  @override
  void onInit() async {
   // httpClient.baseUrl = dotenv.env['API_URL'];
     final accessToken = StorageKeys.storagedToken;  
     
    httpClient.addRequestModifier<dynamic>((request) {
      httpClient.timeout = Duration(seconds: 18);
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
    final response = await httpClient
        .post('https://therapy-bv4t.onrender.com/api/v1/auth/login', body: {'email': email, 'password': password});
    print(response);

    if (response.status.isOk) {
      Map<String, dynamic> responseData = await response.body;
      print("LoogedIn: $responseData");
      return  UserModel.fromJson(responseData);
    } else {
      return throw Exception(response.statusText);
    }

     } catch (e) {
     print("Login error: $e");
     throw Exception('An error occurred during Login: $e');
     }
  }
}
