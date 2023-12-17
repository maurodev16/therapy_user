import 'package:get/get.dart';
import 'package:therapy_dashboard/Models/UserModel.dart';

import '../IRepository/IRepositoryUser.dart';

class ClientListController extends GetxController
    with StateMixin<List<UserModel>> {
  final IRepositoryUser _repositoryUser;
  ClientListController(this._repositoryUser);
  static ClientListController get to => Get.find();
  final RxList<UserModel> listOfAllUsers = <UserModel>[].obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = "".obs;

  @override
  void onInit() async {
    await fetchUsers();
    super.onInit();
  }

  Future<List<UserModel>> fetchUsers() async {
    isLoading.value = true;
    try {
      List<UserModel> response = await _repositoryUser.getAllUsers();
      if (response.isEmpty) {
        change([], status: RxStatus.empty());
        listOfAllUsers.value = [];
        errorMessage.value = "No user";
        print("EMPYT:::$response");
        isLoading.value = false;
        return [];
      } else {
        listOfAllUsers.refresh();
        listOfAllUsers.assignAll(response);
        change(response, status: RxStatus.success());
        print("ALL USERS::::$response");
        isLoading.value = false;
        return listOfAllUsers;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      change([], status: RxStatus.error(errorMessage.value));
      listOfAllUsers.value = [];
    } finally {
      isLoading.value = false;
    }
      return listOfAllUsers;

  }
}
