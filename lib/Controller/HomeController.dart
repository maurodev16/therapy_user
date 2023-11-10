import 'package:get/get.dart';

class HomeController extends GetxController {
static HomeController get to => Get.find();
   RxBool isPaymentOpen = true.obs;
  RxBool isPaymentDone = true.obs;
  RxBool isPaymentStorned = true.obs;
  RxBool isPaymentDue = true.obs;
}