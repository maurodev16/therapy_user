
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:therapy_user/Controller/AuthController.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (controller)=>Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Adicione aqui as configurações desejadas

            // Botão para fazer logout
            ElevatedButton(
              onPressed: () async{
              await  controller.logout();
             
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    ),); 
  }
}
