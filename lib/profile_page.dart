import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Future<DocumentSnapshot> getUserData() async {
    return await FirebaseFirestore.instance.collection('users').doc(userId).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: getUserData(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('Erreur lors de la récupération des données'));
            }

            Map<String, dynamic> userData = snapshot.data!.data() as Map<String, dynamic>;

            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Prénom: ${userData['first_name']}'),
                  Text('Nom: ${userData['last_name']}'),
                  Text('Âge: ${userData['age']}'),
                  Text('Numéro de téléphone: ${userData['phone_number']}'),
                  Text('Email: ${FirebaseAuth.instance.currentUser!.email}'),
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
