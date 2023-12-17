import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Controller/BottomNavigationController.dart';
import '../Utils/Colors.dart';

class BottomNavigationWidget extends GetView<BottomNavigationController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Get.toNamed('/appointment_age');
            },
            heroTag: "tgCalender",
            child: Icon(Icons.calendar_month),
          ),
          body: controller.pages[controller.currentIndex.value],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.currentIndex.value,
            onTap: (index) {
              controller.changePage(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_outlined,
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    Icon(
                      Icons.attach_email_outlined,
                    ),
                  ],
                ),
                label: 'Rechnungen',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.person_2_outlined,
                ),
                label: 'Profil',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.settings,
                ),
                label: 'Einstellungen',
              ),
            ],
            selectedItemColor: azul,
            unselectedItemColor: Colors.grey,
            elevation: 0,
            showSelectedLabels: true,
          ),
        );
      },
    );
  }
}
