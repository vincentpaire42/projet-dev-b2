import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projet_dev_b2/Connexion.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projet_dev_b2/Inscription.dart';
import 'package:provider/provider.dart';
import 'package:projet_dev_b2/authentication_service.dart';
import 'package:projet_dev_b2/home_page.dart';
import 'package:projet_dev_b2/authentication_model.dart';
import 'package:projet_dev_b2/nav_bar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AuthenticationModel(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, AsyncSnapshot<FirebaseApp> snapshot) {
        if (snapshot.hasError) {
          return MaterialApp(
              home: Scaffold(body: Text("Erreur d'initialisation Firebase")));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              Provider<AuthenticationService>(
                create: (_) => AuthenticationService(FirebaseAuth.instance),
              ),
              StreamProvider(
                create: (context) =>
                context.read<AuthenticationService>().authStateChanges,
                initialData: null,
              ),
            ],
            child: MaterialApp(
              title: 'ProMatch',
              routes: {
                '/sign-in': (context) => SignInPage(),
                '/sign-up': (context) => SignUpPage(),
              },
              home: AuthWrapper(),
            ),
          );
        }

        return MaterialApp(home: Scaffold(body: CircularProgressIndicator()));
      },
    );
  }
}

class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  StreamSubscription<User?>? _authStateSubscription;

  @override
  void initState() {
    super.initState();
    _authStateSubscription = FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    if (firebaseUser != null) {
      return MainApp(); // Modifié pour retourner MainApp au lieu de HomePage
    }
    return SignInPage();
  }
}

// Ajout de la classe MainApp
class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  String authorName = '';

  @override
  void initState() {
    super.initState();
    getAuthorName();
  }

  Future<void> getAuthorName() async {
    // Remplacez cette ligne par le code pour récupérer le nom de l'auteur depuis Firebase
    String name = await fetchAuthorNameFromFirebase();
    setState(() {
      authorName = name;
    });
  }

  // Définir la méthode fetchAuthorNameFromFirebase pour récupérer le nom de l'auteur depuis Firebase
  Future<String> fetchAuthorNameFromFirebase() async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUserId).get();
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    return '${userData['first_name']} ${userData['last_name']}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavBar(authorName: authorName),
    );
  }
}


