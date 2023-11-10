import 'package:get/get.dart';

import '../Controller/AppointmentController.dart';
import '../Controller/BillsController.dart';
import '../Controller/BottomNavigationController.dart';
import '../Controller/HomeController.dart';

class MyBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => BillsController());
    Get.lazyPut(() => BottomNavigationController());
    Get.lazyPut(() => AppointmentController());
  }
}
