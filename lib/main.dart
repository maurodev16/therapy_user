import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'BottomNavigationBar/BottomNavigationBar.dart';
import 'MyBindings/Mybindings.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: MyBinding(),
    
      home:BottomNavigationWidget(),
    );
  }
}
