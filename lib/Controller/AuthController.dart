import 'dart:async';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:therapy_user/GlobalWidgets/loadingWidget.dart';
import 'package:therapy_user/Utils/Colors.dart';

import '../IRepository/IRepositoryAuth.dart';
import '../Models/UserModel.dart';

class AuthController extends GetxController with StateMixin<UserModel> {
  final IRepositoryAuth _iRepositoryAuth;
  AuthController(this._iRepositoryAuth);
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
        clientNumberOrEmail: storage.read<int>('clientNumberOrEmail'),
        firstname: storage.read<String>('firstName') ?? '',
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
    print(
        "STORAGE clientNumberOrEmail:::${storage.read('clientNumberOrEmail')}");
    print("STORAGE FIRSTNAME:::${storage.read('firstName')}");
    print("STORAGE LASTNAME:::${storage.read('lastname')}");
    print("STORAGE EMAIL:::${storage.read('email')}");
    print("STORAGE TOKEN:::${storage.read('token')}");
    print("STORAGE userType:::${storage.read('userType')}");
  }

  RxString? userId;
   RxInt? clientNumber;
  dynamic clientNumberOrEmail;
  RxString? firstName = ''.obs;
  RxString? lastname = ''.obs;
  RxString? email = ''.obs;
  RxString? token = ''.obs;
  RxString? userType = "client".obs;
  RxString? password = ''.obs;
  RxString? confirmPassword = ''.obs;

  ///STORAGE
  final storage = GetStorage();

  bool isCurrentUser(UserModel userModel) {
    String? currentUserId = storage.read<String>('userId');
    return userModel.userId == currentUserId;
  }

  late final Rx<UserModel> _userData;
  Rx<UserModel> get getUserData => this._userData;
  set setAuthData(Rx<UserModel> userData) => this._userData = userData;

  Future<void> login() async {
    if (isValid()) {
      isLoadingLogin.value = true;
      try {
        UserModel response = await _iRepositoryAuth.login(
          email!.value,
          clientNumber!.value,
          password!.value,
        );

        if (response.token!.isNotEmpty) {
          _userData.update((user) {
            user!.userId = response.userId;
            user.clientNumber = response.clientNumber;
            user.clientNumberOrEmail = response.clientNumber?? response.email;
            user.firstname = response.firstname;
            user.lastname = response.lastname;
            user.email = response.email;
            user.userType = response.userType;
            user.token = response.token;
          });

          // Armazena os dados do usuário no storage
          storage.write('userId', _userData.value.userId);
          storage.write('clientNumber', _userData.value.clientNumber);
          storage.write('clientNumberOrEmail', _userData.value.clientNumberOrEmail);
          storage.write('firstname', _userData.value.firstname);
          storage.write('lastname', _userData.value.lastname);
          storage.write('email', _userData.value.email);
          storage.write('userType', _userData.value.userType);
          storage.write('token', _userData.value.token);

          // Atualiza as variáveis de estado com os dados do usuário autenticado
          userId!.value = _userData.value.userId!;
          clientNumber!.value = _userData.value.clientNumber!;
          clientNumberOrEmail = _userData.value.clientNumber?? _userData.value.email;
          firstName!.value = _userData.value.firstname!;
          lastname!.value = _userData.value.lastname!;
          email!.value = _userData.value.email!;
          userType!.value = _userData.value.userType!;
          token!.value = _userData.value.token!;

          print("GET USER DATA ::::::::::::$getUserData");
          // Exibe uma mensagem de sucesso e navega para a página de container
          isLoggedIn.value = true;
          Fluttertoast.showToast(
            msg: 'Success, you are logged-In',
            backgroundColor: verde,
          );
          Get.offAllNamed('/home_page');

          // Atualiza o estado com a resposta bem-sucedida
          change(response, status: RxStatus.success());
        }
      } catch (error) {
        handleLoginError(error);
      } finally {
        isLoadingLogin.value = false;
      }
    }
    update();
  }

  void showSuccessMessageAndNavigate() {}

  void handleLoginError(error) {
    String errorMessage;
    if (error.toString().contains("No User found with this email!")) {
      errorMessage = "No User found with this email!";
    } else if (error.toString().contains("Password is required!")) {
      errorMessage = "Password is required!";
    } else if (error.toString().contains("Incorrect password")) {
      errorMessage = "Incorrect password";
    } else if (error.toString().contains("An error occurred during login.")) {
      errorMessage = "An error occurred during login.";
    } else {
      errorMessage = "An unknown error occurred";
    }

    isLoggedIn.value = false;
    Fluttertoast.showToast(msg: errorMessage);
    change(null, status: RxStatus.error(errorMessage));
  }

// Método para atualizar o estado e notificar o GetX
  void updateFormState() {
    password!.refresh();
    firstName!.refresh();
    lastname!.refresh();
    confirmPassword!.refresh();
    email!.refresh();
    update();
  }

  void cleanInputs() {
    firstName!.value = '';
    lastname!.value = '';
    userType!.value = '';
    email!.value = '';
    token!.value = '';
    userType!.value = '';
    password!.value = '';
    confirmPassword!.value = '';
  }

  RxBool isLogoutLoading = false.obs;
  Future<void> logout() async {
    await storage.erase();

    if (storage.read<String>('token') == "" ||
        storage.read<String>('token') == null) {
      LoadingWidget();
      Future.delayed(
          Duration(seconds: 3),
          () => {
                Get.offAll('/login_page'),
                isLogoutLoading.value = false,
                Fluttertoast.showToast(msg: "Voce nao esta mais logado no app"),
              });
    } else {
      Fluttertoast.showToast(msg: "Erro ao deslogar");
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
  bool get validateFirstname =>
      firstName!.trim().isNotEmpty &&
      firstName!.value.length <= 90 &&
      firstName!.value.length > 1;
  String? get errorFirstname {
    if (validateFirstname)
      return null;
    else if (firstName!.value.isEmpty) {
      return null;
    } else if (firstName!.value.length < 2) {
      return "First Name is to short!";
    }
    return "First Name is to long!";
  }

  ///
  bool get validateLastname =>
      lastname!.trim().isNotEmpty &&
      lastname!.value.length <= 90 &&
      lastname!.value.length > 1;
  String? get errorLastname {
    if (validateLastname)
      return null;
    else if (lastname!.value.isEmpty) {
      return null;
    } else if (lastname!.value.length < 2) {
      return "Last name is to short!";
    }
    return "Last name is to long!";
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
    if (!validateFirstname) {
      return false;
    }
    if (!validateLastname) {
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

  bool? get loginButtonEnabled {
    if (validateEmailLogin && validatePasswordLogin) {
      return true;
    } else {
      return false;
    }
  }
}
