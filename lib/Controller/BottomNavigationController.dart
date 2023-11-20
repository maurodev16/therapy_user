import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:therapy_user/pages/InvoicePage.dart';
import 'package:therapy_user/pages/ProfilePage.dart';

import '../pages/HomePage.dart';
import '../pages/SettingsPage.dart';

class BottomNavigationController extends GetxController {

  var currentIndex = 0.obs;

   List<Widget> pages = [
    HomePage(),
    InvoicePage(),
    ProfilePage(),
    SettingsPage(),
  ].obs;

  void changePage(int index) {
    currentIndex.value = index;
  }
}
