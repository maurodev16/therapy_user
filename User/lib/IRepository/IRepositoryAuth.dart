import '../Models/UserModel.dart';

 abstract class IRepositoryAuth {
  Future<UserModel> login(String email, String password);
}
