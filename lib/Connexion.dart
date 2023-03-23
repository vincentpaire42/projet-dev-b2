import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'authentication_service.dart';
import 'package:projet_dev_b2/Inscription.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Connexion")),
        body: Padding(
        padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  String? signInError = await context
                      .read<AuthenticationService>()
                      .signIn(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  );

                  if (signInError != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(signInError)),
                    );
                  }
                },
                child: Text("Se connecter"),
              ),
              SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                child: Text("S'inscrire"),
              ),
            ],
          ),
        ),
    );
  }
}

