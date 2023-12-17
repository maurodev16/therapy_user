import 'package:get/get.dart';
import 'package:therapy_dashboard/Controller/InvoiceController.dart';
import 'package:therapy_dashboard/IRepository/IRepositoryInvoice.dart';
import 'package:therapy_dashboard/IRepository/IRepositoryUser.dart';
import 'package:therapy_dashboard/Repository/RepositoryInvoice.dart';
import 'package:therapy_dashboard/Repository/RepositoryUser.dart';

import '../Controller/AppointmentController.dart';
import '../Controller/BottomNavigationController.dart';
import '../Controller/ClientListPageController.dart';
import '../Controller/HomeController.dart';
import '../Controller/UserController.dart';
import '../IRepository/IRepositoryAppointment.dart';
import '../Repository/RepositoryAppointment.dart';

class MyBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<IRepositoryUser>(RepositoryUser());
    Get.put<UserController>(UserController(Get.find()), permanent: true);
    Get.lazyPut<AppointmentController>(() => AppointmentController(Get.find()));
    Get.lazyPut<IRepositoryAppointment>(() => RepositoryAppointment());
    Get.lazyPut<BottomNavigationController>(() => BottomNavigationController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<InvoiceController>(() => InvoiceController(Get.find()));
    Get.lazyPut<IRepositoryInvoice>(() => RepositoryInvoice());
    Get.lazyPut<ClientListController>(() => ClientListController(Get.find()));

    /// REPOSITORIES
    Get.lazyPut<IRepositoryUser>(() => RepositoryUser());
  }
}
