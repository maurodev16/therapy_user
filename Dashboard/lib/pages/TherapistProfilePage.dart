
import 'package:flutter/material.dart';

class TherapistProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mein Profil'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto des Therapeuten
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/images/doctor.jpg'),
            ),
            SizedBox(height: 16),

            // Name des Therapeuten
            Text(
              'Name des Therapeuten',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            // Qualifikationen und Spezialisierungen
            Text(
              'Qualifikationen und Spezialisierungen:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Klinischer Psychologe\nMaster in Pferdetherapie',
              style: TextStyle(fontSize: 16),
            ),

            // Kontaktinformationen
            Text(
              'Kontaktinformationen:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'E-Mail: therapeut@email.com\nTelefon: (123) 456-7890',
              style: TextStyle(fontSize: 16),
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
    );
  }
}
