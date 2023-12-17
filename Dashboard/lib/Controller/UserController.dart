import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:therapy_dashboard/pages/Authentication/Pages/LoginPage.dart';
import 'package:therapy_dashboard/pages/Authentication/Pages/Register/CreateUserPage.dart';

import '../IRepository/IRepositoryUser.dart';
import '../Models/UserModel.dart';
import '../Utils/Colors.dart';

class UserController extends GetxController with StateMixin<UserModel> {
  final IRepositoryUser _iRepositoryUser;
  UserController(this._iRepositoryUser);
  late final Rx<UserModel> _userData;
  Rx<UserModel> get getUserData => this._userData;
  set setAuthData(Rx<UserModel> userData) => this._userData = userData;
  final storage = GetStorage();

  @override
  void onInit() async {
    super.onInit();
    _userData = UserModel(
      adminId: storage.read<String>('adminId') ?? '',
      firstname: storage.read<String>('firstname') ?? '',
      lastname: storage.read<String>('lastname') ?? '',
      email: storage.read<String>('email') ?? '',
      userType: storage.read<String>('userType'),
      clientNumber: storage.read<int>('clientNumber'),
    ).obs;
    print("AUTH MODEL:::::::::::::::::: ${_userData.value}");

    print("STORAGE ID:::${storage.read('adminId')}");
    print("STORAGE firstname:::${storage.read('firstname')}");
    print("STORAGE lastname:::${storage.read('lastname')}");
    print("STORAGE userType:::${storage.read('userType')}");
    print("STORAGE EMAIL:::${storage.read('email')}");
    print("STORAGE clientNumber:::${storage.read<int>('clientNumber')}");
  }

  RxString adminId = ''.obs;
  RxInt? clientNumber = 0.obs;
  RxString firstname = ''.obs;
  RxString lastname = ''.obs;
  RxString phone = ''.obs;
  RxString email = ''.obs;
  RxString password = ''.obs;
  RxString confirmPassword = ''.obs;
  RxString userType = 'admin'.obs;
  RxBool isPasswordVisible = false.obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  ///
  bool get validateFirstName =>
      firstname.value.trim().isNotEmpty &&
      firstname.value.length <= 90 &&
      firstname.value.length > 1;
  String? get errorFirstName {
    if (validateFirstName)
      return null;
    else if (firstname.value.isEmpty) {
      return null;
    } else if (firstname.value.length < 2) {
      return "First name is to short!";
    }
    return "Frist name is to long!";
  }

  ///
  bool get validateLastname =>
      lastname.value.trim().isNotEmpty &&
      lastname.value.length <= 90 &&
      lastname.value.length > 1;
  String? get errorLastName {
    if (validateLastname)
      return null;
    else if (lastname.value.isEmpty) {
      return null;
    } else if (lastname.value.length < 2) {
      return "Last name is to short!";
    }
    return "Last name is to long!";
  }

  ///
  bool get validatePhone =>
      phone.value.trim().isNotEmpty &&
      phone.value.length <= 18 &&
      phone.value.length > 5;
  String? get errorPhone {
    if (validatePhone)
      return null;
    else if (phone.value.isEmpty) {
      return null;
    } else if (phone.value.length < 5) {
      return "Phone number is invalid!";
    }
    return "Phone number is to invalid!";
  }

  ///
  bool get validateEmail => email.value.isEmail;
  String? get errorEmail {
    if (validateEmail)
      return null;
    else if (email.value.isEmpty) {
      return null;
    } else if (!email.value.isEmail) {
      return "Email format invalid";
    }
    return "";
  }

  ///
  bool get validatePassword =>
      password.value.trim().isNotEmpty && password.value.length >= 7;
  String? get errorPasswordSignup {
    if (validatePassword)
      return null;
    else if (password.value.isEmpty) {
      return null;
    }
    return "Password should be 7 at least, please verify";
  }

  String? get errorConfPasswordSignup {
    if (validateConfPassword)
      return null;
    else if (confirmPassword.value.isEmpty) {
      return null;
    }
    return "Passwords do not match, please verify";
  }

  bool get validateConfPassword => confirmPassword.value == password.value;
  bool isValid() {
    update();
    if (!validateFirstName) {
      return false;
    }
    if (!validateLastname) {
      return false;
    }
    if (!validatePhone) {
      return false;
    }
    if (!validateEmail) {
      return false;
    }
    if (!validatePassword) {
      return false;
    }
    if (!validateConfPassword) {
      return false;
    }
    return true;
  }

  bool get enableButton => isValid() == true;

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  //METODOS
  Future<UserModel> signupUser() async {
    if (isValid()) {
      isLoading.value = true;
      try {
        final newUser = UserModel(
          firstname: firstname.value,
          lastname: lastname.value,
          email: email.value,
          password: password.value,
          phone: phone.value,
          userType: userType.value,
        ).obs;

        UserModel? createdUser = await _iRepositoryUser.create(newUser.value);
        print('Novo adminId: ${createdUser!.adminId}');
        if (createdUser.adminId != null) {
          change(createdUser, status: RxStatus.success());

          Fluttertoast.showToast(
              msg: "Ihr Konto wurde erfolgreich erstellt.".tr);
          Get.to(() => LoginPage());

          isLoading.value = false;
          _userData.update((user) {
            user!.adminId = createdUser.adminId;
            user.clientNumber = createdUser.clientNumber;
            user.firstname = createdUser.firstname;
            user.lastname = createdUser.lastname;
            user.phone = createdUser.phone;
            user.email = createdUser.email;
            user.password = createdUser.password;
            user.userType = createdUser.userType;
            user.createdAt = createdUser.createdAt;
            user.updatedAt = createdUser.updatedAt;
          });
          print('_UserData: ${_userData.value}');
          return createdUser;
        }
      } catch (error) {
        Get.to(() => CreateUserPage());
        await handleRegisterError(error.toString());
        error.printError();
      } finally {
        isLoading.value = false;
        update();
      }
    }

    return _userData.value;
  }

  Future<void> handleRegisterError(String error) async {
    String errorMessage;
    if (error.contains("EmailAlreadyExistsException")) {
      errorMessage = 'Diese Email existiert bereits';
    } else if (error.contains("ErroSignupOnDatabaseException")) {
      errorMessage =
          'Serveraktualisierung, versuchen Sie es später noch einmal';
    } else if (error.contains("PhoneAlreadyExistsException")) {
      errorMessage = 'Dieses Telefon existiert bereits';
    } else {
      errorMessage =
          "Serveraktualisierung, versuchen Sie es später noch einmal";
    }

    isLoading.value = false;
    Fluttertoast.showToast(msg: errorMessage, backgroundColor: branco);
    change(null, status: RxStatus.error(errorMessage));
  }

  void cleanInputs() {
    firstname.value = '';
    lastname.value = '';
    phone.value = '';
    email.value = '';
    password.value = '';
    userType.value = '';
    confirmPassword.value = '';
  }
}
