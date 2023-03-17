
import 'package:flutter/material.dart';
class InscriptionPage extends StatefulWidget {
  const InscriptionPage({Key? key}) : super(key: key);

  @override
  _InscriptionPageState createState() => _InscriptionPageState();
}
class _InscriptionPageState extends State<InscriptionPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late String _nom;
  late String _prenom;
  late String _email;
   String _password = '';
   String _confirmPassword= '' ;

  late String _adressePostal;

  void _submitForm() {
    final FormState form = _formKey.currentState!;

    if (form.validate()) {
      form.save();

      if (_password != _confirmPassword) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Erreur'),
              content: Text('Les mots de passe ne correspondent pas.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );
      } else {
        // Votre code pour inscrire l'utilisateur ici
        print(
            'Nom: $_nom, Prénom: $_prenom, Email: $_email, AdressePostal: $_adressePostal, Password: $_password,confirmPassword: $_confirmPassword ');
      }
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
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: 'Nom',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez saisir votre nom';
              }
              return null;
            },
            onSaved: (String? value) {
              _nom = value!;
            },
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: 'Prénom',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez saisir votre prénom';
              }
              return null;
            },
            onSaved: (String? value) {
              _prenom = value!;
            },
          ),
          
TextFormField(
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: 'Adrresse',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez saisir votre adresse';
              }
              return null;
            },
            onSaved: (String? value) {
              _adressePostal = value!;
            },
          ),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Adresse email',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez saisir une adresse e-mail valide';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                  .hasMatch(value)) {
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
              // if (!RegExp(r'^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$&*~]).{8,}$')
              //     .hasMatch(value)) {
              //   return 'Veuillez saisir un mot de passe valide';
              // }
              return null;
            },
            onSaved: (String? value) {
              _password = value!;
            },
          ),
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Confirmer le mot de passe',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Veuillez confirmer votre mot de passe';
              }

              // if (value != _password) {
              //   return 'Les mots de passe ne correspondent pas';
              // }
              // return null;
            },
            onSaved: (String? value) {
              _confirmPassword = value!;
            },
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _submitForm,
            child: const Text('S\'inscrire'),
          ),
        ],
      ),
    );
  }
}
                  