import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'authentication_service.dart';
import 'conversation.dart';
import 'conversation_service.dart';
import 'conversations_page.dart';
import 'post.dart';

String createGroupChatId(String userId, String recipientId) {
  if (userId.hashCode <= recipientId.hashCode) {
    return '$userId-$recipientId';
  } else {
    return '$recipientId-$userId';
  }
}

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
        child: SingleChildScrollView(
          // Ajoutez le widget SingleChildScrollView ici
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                post.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6),
              Text(
                'Descrption: ${post.description}',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 16),
              Text(
                  'Auteur: ${post.authorFirstName} ${post.authorLastNameInitial}.'),
              SizedBox(height: 16),
              Text('Budget: ${post.budget} €'),
              SizedBox(height: 16),
              Text('Lieu: ${post.Lieux} '),
              TextFormField(
                controller: responseController, // Ajoutez le contrôleur
                decoration: InputDecoration(labelText: 'Réponse'),
              ),
              SizedBox(height: 8),
              // Ajoutez le bouton "Répondre" à la page de détail du post
              ElevatedButton(
                onPressed: () async {
                  // Utilisez MessageDatabaseService pour créer une conversation et envoyer un message
                  MessageDatabaseService messageDatabaseService =
                      MessageDatabaseService();

                  // Créez un groupe de discussion ID en combinant les deux ID d'utilisateur
                  String groupChatId = createGroupChatId(
                    context.read<AuthenticationService>().getCurrentUser()!.uid,
                    post.authorId,
                  );

                  // Envoyez le message initial
                  Message initialMessage = Message(
                    idFrom: context
                        .read<AuthenticationService>()
                        .getCurrentUser()!
                        .uid,
                    idTo: post.authorId,
                    timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
                    content:
                        'J\'ai répondu à votre post : ${post.title}\n\n${responseController.text}',
                    type: 0,
                  );

                  messageDatabaseService.onSendMessage(
                      groupChatId, initialMessage);

                  // Afficher une notification pour indiquer que le message a été envoyé
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Message envoyé')));

                  // Naviguer vers la page de conversation
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConversationPage(
                        conversationId: groupChatId,
                        participants: [
                          post.authorId,
                          context
                              .read<AuthenticationService>()
                              .getCurrentUser()!
                              .uid,
                        ],
                      ),
                    ),
                  );
                },
                child: Text('Répondre'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
