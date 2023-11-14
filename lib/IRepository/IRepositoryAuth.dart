import '../Models/UserModel.dart';

 abstract class IRepositoryAuth {
  Future<UserModel> login(String email, int clientNumber, String password);
}
