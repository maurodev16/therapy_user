
import '../Models/UserModel.dart';

abstract class IRepositoryUser {
  Future<UserModel?> create(UserModel newUser);
  Future<List<UserModel>> getAllUsers();
  Future<UserModel> editUser(UserModel userModel);
  Future<void> deleteUser(String id);
}
