import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/AppointmentPage.dart';
import '../pages/BillsPage.dart';
import '../pages/HomePage.dart';
import '../pages/SettingsPage.dart';

class BottomNavigationController extends GetxController {
  static BottomNavigationController  get to  => Get.find();
  var currentIndex = 0.obs;

   List<Widget> pages = [
    HomePage(),
    BillsPage(),
    AppointmentPage(),
    SettingsPage(),
  ].obs;

  void changePage(int index) {
    currentIndex.value = index;
  }
}
