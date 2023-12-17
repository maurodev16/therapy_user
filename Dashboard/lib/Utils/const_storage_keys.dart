import 'package:get_storage/get_storage.dart';

class StorageKeys {
  static final GetStorage _storage = GetStorage();

  static String get storagedToken => _storage.read('token') ?? '';
}
