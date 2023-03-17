import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String _email;
  late String _password;

  void _submitForm() {
    final FormState form = _formKey.currentState!;

    if (form.validate()) {
      form.save();
      // Votre code pour connecter l'utilisateur ici
      print('Email: $_email, Password: $_password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Adresse email',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez saisir une adresse e-mail valide';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Veuillez saisir une adresse e-mail valide';
              }
              return null;
            },
            onSaved: (String? value) {
              _email = value!;
            },
          ),
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Mot de passe',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez saisir un mot de passe valide';
              }
              // if (!RegExp(r'^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$&*~]).{8,}$').hasMatch(value)) {
              //   return 'Veuillez saisir un mot de passe valide';
              // }
              // return null;
            },
            onSaved: (String? value) {
              _password = value!;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Se connecter'),
            ),
          ),
        ],
      ),
    );
  }
}
