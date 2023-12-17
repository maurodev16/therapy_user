import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Therapeutin \nFrau Lara Berg', style: GoogleFonts.lato(fontSize: 15),),
      leading:  Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/avatar.jpg'),
           radius: 20,
          ),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
        
        ),
      ),
    );
  }
}