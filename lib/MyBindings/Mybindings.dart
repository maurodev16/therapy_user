import 'package:get/get.dart';
import 'package:therapy_user/Controller/AuthController.dart';
import 'package:therapy_user/IRepository/IRepositoryAppointment.dart';
import 'package:therapy_user/IRepository/IRepositoryAuth.dart';
import 'package:therapy_user/Repository/RepositoryAppointment.dart';
import 'package:therapy_user/Repository/RespositoryAuth.dart';

import '../Controller/AppointmentController.dart';
import '../Controller/BillsController.dart';
import '../Controller/BottomNavigationController.dart';
import '../Controller/UserController.dart';
import '../IRepository/IRepositoryUser.dart';
import '../Repository/RepositoryUser.dart';

class MyBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<IRepositoryUser>(RepositoryUser());
    Get.put<UserController>(UserController(Get.find()), permanent: true);

    ///
    Get.lazyPut<AppointmentController>(() => AppointmentController(Get.find()));
    Get.lazyPut<IRepositoryAppointment>(()=>RepositoryAppointment());

    ///
    Get.put<IRepositoryAuth>(RepositoryAuth());
    Get.put<AuthController>(AuthController(Get.find()), permanent: true);
    Get.lazyPut<BottomNavigationController>(() => BottomNavigationController());

    Get.lazyPut<BillsController>(() => BillsController());

    /// REPOSITORIES
    Get.lazyPut<IRepositoryUser>(() => RepositoryUser());
  }
}
