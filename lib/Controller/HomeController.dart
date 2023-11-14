import 'package:get/get.dart';

class HomeController extends GetxController {

   RxBool isPaymentOpen = true.obs;
  RxBool isPaymentDone = true.obs;
  RxBool isPaymentStorned = true.obs;
  RxBool isPaymentDue = true.obs;
}