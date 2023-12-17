import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:therapy_user/BottomNavigationBar/BottomNavigationBar.dart';
import 'package:therapy_user/GlobalWidgets/loadingWidget.dart';

import '../IRepository/IRepositoryAuth.dart';
import '../Models/UserModel.dart';

class AuthController extends GetxController with StateMixin<UserModel> {
  final IRepositoryAuth _iRepositoryAuth;
  AuthController(this._iRepositoryAuth);

  ///STORAGE
  final storage = GetStorage();

  bool isCurrentUser(UserModel userModel) {
    String? currentUserId = storage.read<String>('userId');
    return userModel.userId == currentUserId;
  }

  late final Rx<UserModel> _userData;
  Rx<UserModel> get getUserData => this._userData;
  set setAuthData(Rx<UserModel> userData) => this._userData = userData;

  RxBool isLoggedIn = false.obs;
  RxBool isLoadingLogin = false.obs;
  RxBool isPasswordVisible = false.obs;
  @override
  void onInit() {
    super.onInit();
    // Verifique se há um usuário autenticado no armazenamento local

    final storedUserToken = storage.read<String>('token');
    if (storedUserToken != null) {
      isLoggedIn.value = true;
      // Carregue os dados do usuário a partir do armazenamento local
      _userData = UserModel(
        token: storedUserToken,
        userId: storage.read<String>('userId') ?? '',
        clientNumber: storage.read<int>('clientNumber'),
        firstname: storage.read<String>('firstname') ?? '',
        phone: storage.read<String>('phone') ?? '',
        lastname: storage.read<String>('lastname') ?? '',
        email: storage.read<String>('email') ?? '',
        userType: storage.read<String>('userType') ?? '',
      ).obs;
    } else {
      // Se não houver usuário autenticado, inicialize _userData como um Rx<UserModel> vazio
      _userData = Rx<UserModel>(UserModel());
    }

    print("AUTH MODEL DATA:::::::::::::::::: ${_userData.value}");

    print("STORAGE ID:::${storage.read('userId')}");
    print("STORAGE clientNumber:::${storage.read('clientNumber')}");
    print("STORAGE FIRSTNAME:::${storage.read('firstname')}");
    print("STORAGE LASTNAME:::${storage.read('lastname')}");
    print("STORAGE PHONE:::${storage.read('phone')}");
    print("STORAGE EMAIL:::${storage.read('email')}");
    print("STORAGE TOKEN:::${storage.read('token')}");
    print("STORAGE userType:::${storage.read('userType')}");
  }

  RxString? userId;
  RxInt? clientNumber = 0.obs;
  RxString? firstname = ''.obs;
  RxString? lastname = ''.obs;
  RxString? phone = ''.obs;
  RxString? email = ''.obs;
  RxString? token = ''.obs;
  RxString? userType = "client".obs;
  RxString? password = ''.obs;
  RxString? confirmPassword = ''.obs;

  Future<void> login() async {
    isLoadingLogin.value = true;
    if (isValid()) {
      try {
        UserModel response =
            await _iRepositoryAuth.login(email!.value, password!.value);
        print("response:::${response.token}");

        if (response.token != null) {
          // Atualiza o estado com a resposta bem-sucedida
          change(response, status: RxStatus.success());

          Fluttertoast.showToast(msg: "'Success, you are logged-In'".tr);

          Get.offAll(() => BottomNavigationWidget());
          isLoadingLogin.value = false;

          _userData.update((user) {
            user!.userId = response.userId;
            user.clientNumber = response.clientNumber;
            user.firstname = response.firstname;
            user.lastname = response.lastname;
            user.phone = response.phone;
            user.email = response.email;
            user.userType = response.userType;
            user.token = response.token;
            user.createdAt = response.createdAt;
            user.updatedAt = response.updatedAt;
          });
          print("TOKEN:::${response.token}");
          print("GET USER DATA ::::::::::::$getUserData");

          // Armazena os dados do usuário no storage
          storage.write('userId', _userData.value.userId);
          storage.write('clientNumber', _userData.value.clientNumber);
          storage.write('firstname', _userData.value.firstname);
          storage.write('lastname', _userData.value.lastname);
          storage.write('phone', _userData.value.phone);
          storage.write('email', _userData.value.email);
          storage.write('userType', _userData.value.userType);
          storage.write('token', _userData.value.token);

          // Atualiza as variáveis de estado com os dados do usuário autenticado
          userId!.value = _userData.value.userId!;
          clientNumber!.value = _userData.value.clientNumber!;
          firstname!.value = _userData.value.firstname!;
          lastname!.value = _userData.value.lastname!;
          phone!.value = _userData.value.phone!;
          email!.value = _userData.value.email!;
          userType!.value = _userData.value.userType!;
          token!.value = _userData.value.token!;
        }
      } catch (error) {
        print(error.toString());
        await handleLoginError(error.toString());
      } finally {
        isLoadingLogin.value = false;
      }
    }
    update();
  }

  Future<String> handleLoginError(String error) async {
    RxString errorMessage = "".obs;
    if (error.contains("No User found with this email!")) {
      isLoggedIn.value = false;
      Fluttertoast.showToast(msg: errorMessage.value);
      change(null, status: RxStatus.error(errorMessage.value));
      return errorMessage.value = "No User found with this email!";
    }
    if (error.contains("Password is required!")) {
      isLoggedIn.value = false;
      Fluttertoast.showToast(msg: errorMessage.value);
      change(null, status: RxStatus.error(errorMessage.value));

      return errorMessage.value = "Password is required!";
    }
    if (error.contains("Incorrect password")) {
      isLoggedIn.value = false;
      Fluttertoast.showToast(msg: errorMessage.value);
      change(null, status: RxStatus.error(errorMessage.value));

      return errorMessage.value = "Incorrect password";
    }
    if (error.contains("An error occurred during login.")) {
      isLoggedIn.value = false;
      Fluttertoast.showToast(msg: errorMessage.value);
      change(null, status: RxStatus.error(errorMessage.value));

      return errorMessage.value = "An error occurred during login.";
    } else {
      isLoggedIn.value = false;
      Fluttertoast.showToast(msg: errorMessage.value);
      change(null, status: RxStatus.error(errorMessage.value));
      return errorMessage.value =
          "Serveraktualisierung, versuchen Sie es später noch einmal";
    }
  }

// Método para atualizar o estado e notificar o GetX
  void updateFormState() {
    password!.refresh();
    firstname!.refresh();
    lastname!.refresh();
    phone!.refresh();
    confirmPassword!.refresh();
    email!.refresh();
    update();
  }

  void cleanInputs() {
    firstname!.value = '';
    lastname!.value = '';
    phone!.value = '';
    userType!.value = '';
    email!.value = '';
    token!.value = '';
    userType!.value = '';
    password!.value = '';
    confirmPassword!.value = '';
  }

  RxBool isLogoutLoading = false.obs;

  Future<void> logout() async {
    isLogoutLoading.value = true;
    try {
      await storage.erase();

      if (storage.read<String>('token') == "" ||
          storage.read<String>('token') == null) {
        loadingWidget();
        Future.delayed(
            Duration(seconds: 3),
            () => {
                  Get.offAll('/login_page'),
                  isLogoutLoading.value = false,
                  Fluttertoast.showToast(
                      msg: "Voce nao esta mais logado no app"),
                });
      } else {
        Fluttertoast.showToast(msg: "Erro ao deslogar");
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLogoutLoading.value = false;
    }

    update();
  }

  bool get validateEmail => email!.value.isEmail;
  String? get errorEmail {
    if (validateEmail)
      return null;
    else if (email!.value.isEmpty) {
      return null;
    } else if (!email!.value.isEmail) {
      return "Email format invalid";
    }
    return "";
  }

  ///
  bool get validatePassword =>
      password!.value.trim().isNotEmpty && password!.value.length >= 7;
  String? get errorPassword {
    if (validatePassword)
      return null;
    else if (password!.value.isEmpty) {
      return null;
    }
    return "Password should be 7 at least, please verify";
  }

  String? get errorConfPassword {
    if (validateConfPassword)
      return null;
    else if (confirmPassword!.value.isEmpty) {
      return null;
    }
    return "Passwords do not match, please verify";
  }

  bool get validateConfPassword => confirmPassword!.value == password!.value;
  bool isValid() {
    update();

    if (!validateEmail) {
      return false;
    } else if (!validatePassword) {
      return false;
    } else {
      return true;
    }
  }

  bool? get loginButtonEnabled {
    if (validateEmailLogin && validatePasswordLogin) {
      return true;
    } else {
      return false;
    }
  }

  bool get enableButton => isValid() == true;

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  ///VALIDATIONS
  bool get validateEmailLogin => email!.value.isEmail;

  String? get errorEmailLogin {
    if (validateEmailLogin)
      return null;
    else if (email!.value.isEmpty) {
      return null;
    }
    return "invalid Email format, please verify!";
  }

  bool get validatePasswordLogin =>
      password!.value.isNotEmpty && password!.value.length >= 7;

  String? get errorPasswordLogin {
    if (validatePasswordLogin)
      return null;
    else if (password!.value.isEmpty) {
      return null;
    }
    return "Invalid password, please verify";
  }
}
