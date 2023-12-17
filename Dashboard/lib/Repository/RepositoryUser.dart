import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:therapy_dashboard/Models/UserModel.dart';

import '../IRepository/IRepositoryUser.dart';
import '../Utils/const_storage_keys.dart';

class RepositoryUser extends GetConnect implements IRepositoryUser {
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
  Future<UserModel> create(UserModel userModel) async {
    try {
      final response =
          await httpClient.post('user/create', body: userModel.toJson());

      if (response.status.isOk) {
        final Map<String, dynamic> responseData = await response.body;

        final UserModel newUser =
            UserModel.fromJson(responseData['newCreatedUser']);

        print("responseData::::: ${responseData['newCreatedUser']}");

        print("MEU authModel::::: ${newUser.adminId}");

        return newUser;
      } else {
        print("Signup error: ${response.body}");
        return throw Exception(response.body);
      }
    } catch (e) {
      print("Login error: $e");
      throw Exception('An error occurred during Signup: $e');
    }
  }
//JFPSJPFJPFSM
  @override
  Future<List<UserModel>> getAllUsers() async {
    try {
      final response = await httpClient.get("user/fetch");

      if (response.status.isOk) {
        var jsonResponse = await response.body;
        List<dynamic> postList = jsonResponse["userdata"];
        print(postList);
        return postList
            .map<UserModel>((item) => UserModel.fromJson(item))
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
      print("Body FEcth all Posts Response:::::::::::::${response.bodyString}");

      throw Exception(response.bodyString);
    } catch (e) {
      throw Exception(e.toString());
    }
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
