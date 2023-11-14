import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

import '../IRepository/IRepositoryUser.dart';
import '../Models/UserModel.dart';

class RepositoryUser extends GetConnect implements IRepositoryUser {
  @override
  void onInit() async {
   /// httpClient.baseUrl = dotenv.env['API_URL'];
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers['Authorization'] = 'Bearer';
      request.headers['Accept'] = 'application/json';
      defaultContentType="application/json; charset=utf-8";
      return request;
    });

    super.onInit();
  }

  @override
  Future<UserModel> create(UserModel userModel) async {
   // try {
      final response =
          await httpClient.post('http://192.168.178.24:3001/api/v1/user/create', body: userModel.toJson());

      if (response.status.isOk) {
        final Map<String, dynamic> responseData = await response.body;

        final UserModel newUser =
            UserModel.fromJson(responseData['newCreatedUser']);

        print("responseData::::: ${responseData['newCreatedUser']}");

        print("MEU authModel::::: ${newUser.userId}");

        return newUser;
      } else {
        print("Signup error: ${response.statusText}");
        return throw Exception(response.body);
      }
    // } catch (e) {
    //   print("Login error: $e");
    //   throw Exception('An error occurred during Signup: $e');
    // }
  }

  @override
  Future<void> deleteUser(String id) {
    throw UnimplementedError();
  }

  @override
  Future<UserModel> editUser(UserModel userModel) {
    throw UnimplementedError();
  }
}
