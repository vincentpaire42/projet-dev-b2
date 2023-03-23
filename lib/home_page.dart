import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authentication_service.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              context.read<AuthenticationService>().signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Text('Bienvenue à la page d\'accueil!'),
      ),
    );
  }
}
