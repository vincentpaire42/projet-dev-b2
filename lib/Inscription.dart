import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authentication_service.dart';
import 'package:projet_dev_b2/Connexion.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) => Scaffold(
        appBar: AppBar(title: Text("Inscription")),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
              ),
              ElevatedButton(
                onPressed: () async {
                  final String signUpStatus =
                      await context.read<AuthenticationService>().signUp(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          );
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(signUpStatus)));
                  if (signUpStatus == "Inscription réussie") {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SignInPage()),
                    );
                  }
                },
                child: Text("S'inscrire"),
              ),
              ElevatedButton(
                onPressed: () {
                  // Naviguer vers SignInPage
                  Navigator.pushNamed(context, '/sign-in');
                },
                child: Text('Se connecter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
