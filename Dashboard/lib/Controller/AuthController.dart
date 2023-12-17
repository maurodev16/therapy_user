import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:therapy_dashboard/GlobalWidgets/loadingWidget.dart';
import 'package:therapy_dashboard/pages/Authentication/Pages/LoginPage.dart';
import '../BottomNavigationBar/BottomNavigationBar.dart';
import '../IRepository/IRepositoryAuth.dart';
import '../Models/UserModel.dart';
import '../Utils/Colors.dart';

class AuthController extends GetxController with StateMixin<UserModel> {
  final IRepositoryAuth _iRepositoryAuth;
  AuthController(this._iRepositoryAuth);

  ///STORAGE
  final storage = GetStorage();

  bool isCurrentUser(UserModel userModel) {
    String? currentUserId = storage.read<String>('adminId');
    return userModel.adminId == currentUserId;
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
        adminId: storage.read<String>('adminId') ?? '',
        email: storage.read<String>('email') ?? '',
        userType: storage.read<String>('userType') ?? '',
      ).obs;
    } else {
      // Se não houver usuário autenticado, inicialize _userData como um Rx<UserModel> vazio
      _userData = Rx<UserModel>(UserModel());
    }

    print("AUTH MODEL DATA:::::::::::::::::: ${_userData.value}");

    print("STORAGE ID:::${storage.read('adminId')}");
    print("STORAGE EMAIL:::${storage.read('email')}");
    print("STORAGE TOKEN:::${storage.read('token')}");
    print("STORAGE userType:::${storage.read('userType')}");
  }

  RxString? adminId;
  RxString? email = ''.obs;
  RxString? firstname = ''.obs;
  RxString? lastname = ''.obs;
  RxString? token = ''.obs;
  RxString? userType = "admin".obs;
  RxString? password = ''.obs;
  RxString? confirmPassword = ''.obs;

  Future<void> login() async {
    isLoadingLogin.value = true;
    if (isValid()) {
      try {
        UserModel response =
            await _iRepositoryAuth.login(email!.value, password!.value);
        print("response:::${response.token}");

        if (response.token!.isNotEmpty) {
          // Atualiza o estado com a resposta bem-sucedida
          change(response, status: RxStatus.success());

          Fluttertoast.showToast(
              msg:
                  "Hallo Frau ${response.lastname}, willkommen in der App.".tr);
          Get.offAll(() => BottomNavigationWidget());
          _userData.update((user) {
            user!.adminId = response.adminId;
            user.email = response.email;
            user.firstname = response.firstname;
            user.lastname = response.lastname;
            user.userType = response.userType;
            user.token = response.token;
            user.createdAt = response.createdAt;
            user.updatedAt = response.updatedAt;
          });
          print("TOKEN:::${response.token}");
          print("GET USER DATA ::::::::::::$getUserData");

          // Armazena os dados do usuário no storage
          storage.write('adminId', _userData.value.adminId);
          storage.write('email', _userData.value.email);
          storage.write('userType', _userData.value.userType);
          storage.write('token', _userData.value.token);

          // Atualiza as variáveis de estado com os dados do usuário autenticado
          adminId!.value = _userData.value.adminId!;
          email!.value = _userData.value.email!;
          firstname!.value = _userData.value.firstname!;
          lastname!.value = _userData.value.lastname!;
          userType!.value = _userData.value.userType!;
          token!.value = _userData.value.token!;
        }
      } catch (error) {
        print(error.toString());
        await handleLoginError(error.toString());
      } finally {
        isLoadingLogin.value = false;
        update();
      }
    }
  }

  Future<void> handleLoginError(String error) async {
    String errorMessage;
    if (error.contains("No User found with this email!")) {
      errorMessage = "No User found with this email!";
    } else if (error.contains("Password is required!")) {
      errorMessage = "Password is required!";
    } else if (error.contains("Incorrect password")) {
      errorMessage = "Incorrect password";
    } else if (error.contains("An error occurred during login.")) {
      errorMessage = "An error occurred during login.";
    } else {
      isLoggedIn.value = true;
      errorMessage = 'Success, you are logged-In';
      // Exibe uma mensagem de sucesso e navega para a página de container
      isLoggedIn.value = true;
      Fluttertoast.showToast(
        msg: errorMessage,
        backgroundColor: verde,
      );
    }

    isLoggedIn.value = false;
    Fluttertoast.showToast(msg: errorMessage);
    change(null, status: RxStatus.error(errorMessage));
  }

// Método para atualizar o estado e notificar o GetX
  void updateFormState() {
    password!.refresh();
    confirmPassword!.refresh();
    email!.refresh();
    update();
  }

  void cleanInputs() {
    email!.value = '';
    firstname!.value = '';
    lastname!.value = '';
    token!.value = '';
    password!.value = '';
    confirmPassword!.value = '';
    userType!.value = '';
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
                  Get.offAll(() => LoginPage()),
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
