import 'package:flutter/material.dart';
import 'package:projet_dev_b2/profile_page.dart'; // Ajoutez cette ligne
import 'package:projet_dev_b2/home_page.dart';
import 'package:projet_dev_b2/message_page.dart';



class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Message'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'), // Ajoutez cette ligne
      ],
      onTap: (int index) {
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MessagePage()), // Ajoutez cette ligne
            );
            break;
          case 2:
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
