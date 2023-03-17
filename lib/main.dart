import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'Connexion.dart';
import 'Inscription.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp( MyApp());
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
