import 'package:flutter/material.dart';
import 'package:projet_dev_b2/home_page.dart';
import 'package:projet_dev_b2/profile_page.dart'; // Ajoutez cette ligne

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'), // Ajoutez cette ligne
      ],
      onTap: (int index) {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()), // Ajoutez cette ligne
            );
            break;

        }
      },
    );
  }
}
