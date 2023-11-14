
import '../Models/UserModel.dart';

abstract class IRepositoryUser {
  Future<UserModel?> create(UserModel newUser);
  Future<UserModel> editUser(UserModel userModel);
  Future<void> deleteUser(String id);
}
