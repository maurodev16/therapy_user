import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:therapy_user/Controller/AuthController.dart';
import 'package:therapy_user/Utils/Colors.dart';

import '../Repository/RespositoryAuth.dart';

class ProfilePage extends StatelessWidget {
  final AuthController authController =
      Get.put<AuthController>(AuthController(RepositoryAuth()));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mein Profil'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Container(
          width: Get.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: Get.width,
                child: Card(
                  child: Column(children: [
                    Text(
                      "Name: ${authController.getUserData.value.lastname}",
                      style: GoogleFonts.lato(color: preto, fontSize: 16),
                    ),
                    Text(
                      'KN: ${authController.getUserData.value.clientNumber}',
                      style: GoogleFonts.lato(color: preto, fontSize: 12),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Kontaktinformationen:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${authController.getUserData.value.email}\nTelefon: ${authController.getUserData.value.phone}',
                      style: GoogleFonts.lato(fontSize: 16),
                    ),
                  ]),
                ),
              ),

              // Profilinformationen bearbeiten
              ElevatedButton(
                onPressed: () {
                  // Navigieren Sie zur Therapeutenprofil-Bearbeitungsseite.
                  // Ermöglichen Sie dem Therapeuten, seine Informationen zu bearbeiten.
                },
                child: Text('Profil bearbeiten'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
