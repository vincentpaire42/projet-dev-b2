import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class CreatePostPage extends StatefulWidget {
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> savePost({
    required String title,
    required String description,
    required String userId,
  }) async {
    CollectionReference posts = FirebaseFirestore.instance.collection('posts');
    return posts
        .add({
      'title': title,
      'description': description,
      'user_id': userId,
      'created_at': FieldValue.serverTimestamp(),
    })
        .then((value) => print("Post ajouté"))
        .catchError((error) => print("Erreur lors de l'ajout du post: $error"));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer un post'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Titre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un titre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Récupérer l'ID de l'utilisateur actuel
                    final user = FirebaseAuth.instance.currentUser;
                    if (user != null) {
                      // Enregistrer le post dans Cloud Firestore
                      await savePost(
                        title: _titleController.text.trim(),
                        description: _descriptionController.text.trim(),
                        userId: user.uid,
                      );
                      // Revenir à la page d'accueil
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Erreur: utilisateur non connecté")),
                      );
                    }
                  }
                },
                child: Text("Publier"),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
