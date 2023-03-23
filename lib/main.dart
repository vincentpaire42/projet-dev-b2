import 'package:projet_dev_b2/Connexion.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:projet_dev_b2/Inscription.dart';
import 'package:provider/provider.dart';
import 'package:projet_dev_b2/authentication_service.dart';
import 'package:projet_dev_b2/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
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
              // Ajoutez les routes pour SignInPage et SignUpPage
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
  @override
  void initState() {
    super.initState();
    context.read<AuthenticationService>().authStateChanges.listen((User? user) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    if (firebaseUser != null) {
      return HomePage();
    }
    return SignInPage();
  }
}
