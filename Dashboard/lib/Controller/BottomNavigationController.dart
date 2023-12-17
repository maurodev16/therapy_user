import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:therapy_dashboard/Pages/BottonNavPages/ClientListPage.dart';
import 'package:therapy_dashboard/pages/BottonNavPages/InvoicePage.dart';

import '../Pages/BottonNavPages/Home/HomePage.dart';
import '../Pages/BottonNavPages/SettingsPage.dart';

class BottomNavigationController extends GetxController {
  static BottomNavigationController get to => Get.find();
  var currentIndex = 0.obs;

  List<Widget> pages = [
    HomePage(),
    InvoicePage(),
    ClientListPage(),
    SettingsPage(),
  ].obs;

  void changePage(int index) {
    currentIndex.value = index;
  }
}
