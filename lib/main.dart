import 'package:flutter/material.dart';
import 'Connexion.dart';
import 'Inscription.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Ma page de connexion'),
        ),
        body: Center(
          // child: LoginForm(),
          child: InscriptionPage(),
        ),
      ),
    );
  }
}
