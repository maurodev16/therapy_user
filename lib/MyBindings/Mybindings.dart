import 'package:get/get.dart';

import '../Controller/AppointmentController.dart';
import '../Controller/BillsController.dart';
import '../Controller/BottomNavigationController.dart';
import '../Controller/HomeController.dart';
import '../IRepository/IRepositoryUser.dart';
import '../Repository/RepositoryUser.dart';

class MyBinding implements Bindings {
  @override
  void dependencies() {
  
    Get.put(AppointmentController());
    Get.lazyPut<BottomNavigationController>(() => BottomNavigationController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<BillsController>(() => BillsController());

    /// REPOSITORIES
    Get.lazyPut<IRepositoryUser>(() => RepositoryUser());
  }
}


