import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:projet_dev_b2/Connexion.dart';

class InscriptionPage extends StatefulWidget {
  const InscriptionPage({Key? key}) : super(key: key);

  @override
  _InscriptionPageState createState() => _InscriptionPageState();
}

class _InscriptionPageState extends State<InscriptionPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _nom = TextEditingController();
  final _prenom = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _adressePostal = TextEditingController();

  void _submitForm() {
    final FormState form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      if (_password.text != _confirmPassword.text) {
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
        FirebaseFirestore.instance.collection('user').add({
          'first_name': _prenom.value.text,
          'last_name': _nom.value.text,
          'postal_address': _adressePostal.value.text,
          'email': _email.value.text,
          'password': _password.value.text,
        });
        // Afficher une boîte de dialogue pour confirmer l'inscription réussie
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Inscription réussie'),
              content: Text('Votre inscription a été enregistrée.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            );
          },
        );

        // Vider les champs de saisie
        _nom.clear();
        _prenom.clear();
        _email.clear();
        _password.clear();
        _confirmPassword.clear();
        _adressePostal.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Inscription'),
        ),
        body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(43),
                    side: const BorderSide(color: Colors.black38, width: 1.5),
                  ),
                  title: Row(
                    children: [
                      const Text('Nom: '),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          controller: _nom,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer votre nom';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(43),
                    side: const BorderSide(color: Colors.black38, width: 1.5),
                  ),
                  title: Row(
                    children: [
                      const Text('Prénom: '),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          controller: _prenom,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer votre prénom';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(43),
                    side: const BorderSide(color: Colors.black38, width: 1.5),
                  ),
                  title: Row(
                    children: [
                      const Text('email: '),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
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
                          controller: _email,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(43),
                    side: const BorderSide(color: Colors.black38, width: 1.5),
                  ),
                  title: Row(
                    children: [
                      const Text('adresse: '),
                      Expanded(
                        child: TextField(
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          controller: _adressePostal,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(43),
                    side: const BorderSide(color: Colors.black38, width: 1.5),
                  ),
                  title: Row(
                    children: [
                      const Text('password: '),
                      Expanded(
                        child: TextField(
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                          controller: _password,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(43),
                    side: const BorderSide(color: Colors.black38, width: 1.5),
                  ),
                  title: Row(
                    children: [
                      const Text('Confirmez votre mot de passe: '),
                      Expanded(
                        child: TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez confirmer votre mot de passe.';
                            } else if (value != _password.text) {
                              return 'Les mots de passe ne correspondent pas.';
                            }
                            return null;
                          },
                          controller: _confirmPassword,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
      if (_formKey.currentState!.validate()) {
        FirebaseFirestore.instance.collection('user').add({
          'first_name': _prenom.value.text,
          'last_name': _nom.value.text,
          'postal_address': _adressePostal.value.text,
          'email': _email.value.text,
          'password': _password.value.text,
        });
        // Navigator.pop(InscriptionPage);

                    }
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context){
                        return LoginForm();
                      },

                  ));

                  },
                  child: const Text('S\'inscrire'),
                ),
              ],
            ),
          ),
        ),
        ),
    );
  }
}

