import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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


  // void _submitForm() {
  //   final FormState form = _formKey.currentState!;

  //   if (form.validate()) {
  //     form.save();

  //     if (_password != _confirmPassword) {
  //       showDialog(
  //         context: context,
  //         builder: (BuildContext context) {
  //           return AlertDialog(
  //             title: Text('Erreur'),
  //             content: Text('Les mots de passe ne correspondent pas.'),
  //             actions: <Widget>[
  //               TextButton(
  //                 child: Text('OK'),
  //                 onPressed: () => Navigator.of(context).pop(),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     } else {
  //       // Votre code pour inscrire l'utilisateur ici
  //       print(
  //           'Nom: $_nom, Prénom: $_prenom, Email: $_email, AdressePostal: $_adressePostal, Password: $_password,confirmPassword: $_confirmPassword ');
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: const Text('Inscription'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
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
            child: TextField(
              decoration: const InputDecoration(
                  border: InputBorder.none
              ),
              controller: _nom,
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
            child: TextField(
              decoration: const InputDecoration(
                  border: InputBorder.none
              ),
              controller: _prenom,
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
            child: TextField(
              decoration: const InputDecoration(
                  border: InputBorder.none
              ),
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
              decoration: const InputDecoration(
                  border: InputBorder.none
              ),
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
              decoration: const InputDecoration(
                  border: InputBorder.none
              ),
              controller: _password,
            ),
          ), 
        ],
      ),
    ),
    
    ElevatedButton(
    onPressed: (){
    FirebaseFirestore.instance.collection('user').add({
    'first_name': _prenom.value.text,
    'last_name': _nom.value.text,
    'postal_address': _adressePostal.value.text,
    'email': _email.value.text,
    'password': _password.value.text,

    });
    // Navigator.pop(InscriptionPage);
            },
            child: const Text('S\'inscrire'),
           ),
            ],
          ),
        ),
    );
  }
    
  
}              