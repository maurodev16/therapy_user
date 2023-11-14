import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:therapy_user/IRepository/IRepositoryUser.dart';

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
      userId: storage.read<String>('userId') ?? '',
      firstname: storage.read<String>('firstname') ?? '',
      lastname: storage.read<String>('lastname') ?? '',
      email: storage.read<String>('email') ?? '',
      userType: storage.read<String>('userType'),
      clientNumber: storage.read<int>('clientNumber'),
    ).obs;
    print("AUTH MODEL:::::::::::::::::: ${_userData.value}");

    print("STORAGE ID:::${storage.read('userId')}");
    print("STORAGE firstname:::${storage.read('firstname')}");
    print("STORAGE lastname:::${storage.read('lastname')}");
    print("STORAGE userType:::${storage.read('userType')}");
    print("STORAGE EMAIL:::${storage.read('email')}");
    print("STORAGE clientNumber:::${storage.read<int>('clientNumber')}");
    print(
        "STORAGE clientNumberOrEmail:::${storage.read('clientNumberOrEmail')}");
  }

  RxString userId = ''.obs;
  RxInt? clientNumber = 0.obs;
  RxString firstname = ''.obs;
  RxString lastname = ''.obs;
  RxString email = ''.obs;
  RxString password = ''.obs;
  RxString confirmPassword = ''.obs;
  RxString userType = 'client'.obs;
  RxBool isPasswordVisible = false.obs;
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

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
        ).obs;

        UserModel? createdUser = await _iRepositoryUser.create(newUser.value);
        print('Novo usuário ID: ${createdUser!.userId}');

        change(createdUser, status: RxStatus.success());
        isLoading.value = false;
        _userData.update((user) {
          user!.userId = createdUser.userId;
          user.clientNumber = createdUser.clientNumber;
          user.firstname = createdUser.firstname;
          user.lastname = createdUser.lastname;
          user.email = createdUser.email;
          user.password = createdUser.password;
          user.userType = createdUser.userType;
          user.createdAt = createdUser.createdAt;
          user.updatedAt = createdUser.updatedAt;
        });
        print('_UserData: ${_userData.value}');

        return createdUser;
      } catch (e) {
        e.printError();

        errorMessage.value = e.toString();
        if (errorMessage.value.contains("EmailAlreadyExistsException")) {
          Fluttertoast.showToast(msg: 'Email Already Exist');
        } else if (errorMessage.value
            .contains("ErroSignupOnDatabaseException")) {
          Fluttertoast.showToast(
              msg: 'Erro Signup On Database, try again later',
              backgroundColor: branco);
        }
        change(null, status: RxStatus.error(errorMessage.value));
      } finally {
        isLoading.value = false;
      }
    }
    update();
    return _userData.value;
  }

  void cleanInputs() {
    firstname.value = '';
    lastname.value = '';
    email.value = '';
    password.value = '';
    userType.value = '';
    confirmPassword.value = '';
  }
}
