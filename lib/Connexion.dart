import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projet_dev_b2/Accueil.dart';



Future<void> loginUser(String email, String password) async {
  // Récupérer la référence de la collection "users"
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  // Récupérer les données de l'utilisateur correspondant à l'email fourni
  QuerySnapshot querySnapshot = await users.where('email', isEqualTo: email).get();

  // Vérifier si l'utilisateur existe et si le mot de passe est correct
  if (querySnapshot.docs.length == 1) {
    Map<String, dynamic> userData = querySnapshot.docs.first.data() as Map<String, dynamic>;



    if (userData['password'] == password) {
      // L'utilisateur est connecté
      print('Connecté avec succès !');
    } else {
      // Le mot de passe est incorrect
      print('Mot de passe incorrect.');
    }
  } else {
    // L'utilisateur n'existe pas
    print('L\'utilisateur avec cet email n\'existe pas.');
  }
}




class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
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
                      const Text('Email: '),
                      Expanded(
                        child: TextFormField(
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          controller: _email,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Veuillez entrer votre email';
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
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context){
                        return Accueil();
                      },

                    ));

                  },
                  child: Text('Connexion'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}