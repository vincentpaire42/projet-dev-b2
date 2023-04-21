// Ajout de la classe NavBar avec la modification nécessaire pour récupérer le nom de l'auteur
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projet_dev_b2/profile_page.dart';

import 'home_page.dart';
import 'message_page.dart';

class NavBar extends StatelessWidget {
  final String authorName;

  NavBar({required this.authorName});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
        BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Message'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
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
              MaterialPageRoute(builder: (context) => MessagePage()),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
            break;
        }
      },
    );
  }
}