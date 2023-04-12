import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authentication_service.dart';
import 'conversation_page.dart';
import 'conversation_service.dart';
import 'post.dart';

class PostDetailPage extends StatelessWidget {
  final Post post;

  const PostDetailPage({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController responseController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Détails du post'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(post.description),
            SizedBox(height: 8),
            Text('Auteur: ${post.authorFirstName} ${post.authorLastNameInitial}.'),
            SizedBox(height: 16),
            TextFormField(
              controller: responseController, // Ajoutez le contrôleur
              decoration: InputDecoration(labelText: 'Réponse'),
            ),
            SizedBox(height: 8),
            // Ajoutez le bouton "Répondre" à la page de détail du post
            ElevatedButton(
              onPressed: () async {
                // Créez une nouvelle conversation ou récupérez une conversation existante
                final conversationRef = await createConversation(
                  context.read<AuthenticationService>().getCurrentUser()!.uid,
                  // L'utilisateur actuel
                  post.authorFirstName, // L'auteur du post
                );

                // Envoyez le message dans la conversation
                await sendMessage(
                  conversationRef.id,
                  context.read<AuthenticationService>().getCurrentUser()!.uid,
                  // L'utilisateur actuel
                  post.authorFirstName, // L'auteur du post
                  'J\'ai répondu à votre post : ${post.title}\n\n${responseController.text}', // Incluez la réponse de l'utilisateur
                );

                // Afficher une notification pour indiquer que le message a été envoyé
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Message envoyé')));

                // Naviguer vers la page de conversation
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConversationPage(
                      conversationId: conversationRef.id,
                      participants: [post.authorFirstName, context.read<AuthenticationService>().getCurrentUser()!.uid],
                    ),
                  ),
                );
              },
              child: Text('Répondre'),
            ),
          ],
        ),
      ),
    );
  }
}
