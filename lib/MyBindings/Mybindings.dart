import 'package:get/get.dart';
import 'package:therapy_user/IRepository/IRepositoryInvoice.dart';
import 'package:therapy_user/Repository/RepositoryInvoice.dart';
import '../Controller/AppointmentController.dart';
import '../Controller/InvoiceController.dart';
import '../Controller/BottomNavigationController.dart';
import '../Controller/UserController.dart';
import '../IRepository/IRepositoryAppointment.dart';
import '../IRepository/IRepositoryUser.dart';
import '../Repository/RepositoryAppointment.dart';
import '../Repository/RepositoryUser.dart';

class MyBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<IRepositoryUser>(RepositoryUser());
    Get.put<UserController>(UserController(Get.find()), permanent: true);
    Get.lazyPut<AppointmentController>(() => AppointmentController(Get.find()));
    Get.lazyPut<IRepositoryAppointment>(() => RepositoryAppointment());
    Get.lazyPut<BottomNavigationController>(() => BottomNavigationController());
    Get.lazyPut<InvoiceController>(() => InvoiceController(Get.find()));
    Get.lazyPut<IRepositoryInvoice>(() => RepositoryInvoice());

    /// REPOSITORIES
    Get.lazyPut<IRepositoryUser>(() => RepositoryUser());
  }
}
