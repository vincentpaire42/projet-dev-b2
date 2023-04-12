import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projet_dev_b2/conversation_page.dart';
import 'package:projet_dev_b2/new_conversation_page.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  late String currentUserId;
  late Stream<QuerySnapshot> conversationsStream;

  @override
  void initState() {
    super.initState();

    // Récupérez l'ID de l'utilisateur courant
    currentUserId = FirebaseAuth.instance.currentUser!.uid;

    // Récupérez les conversations de l'utilisateur courant
    conversationsStream = FirebaseFirestore.instance
        .collection('conversations')
        .where('participants', arrayContains: currentUserId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: conversationsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Erreur: ${snapshot.error}");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          // Si l'utilisateur n'a pas encore de conversations, affichez un message
          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('Vous n\'avez pas encore de conversations.'),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot conversation) {
              Map<String, dynamic> conversationData = conversation.data() as Map<String, dynamic>;

              // Récupérez les participants de la conversation
              List<dynamic> participants = conversationData['participants'];
              participants.remove(currentUserId);

              // Récupérez le dernier message de la conversation
              Query lastMessageQuery = conversation.reference.collection('messages').orderBy('timestamp', descending: true).limit(1);
              return StreamBuilder<QuerySnapshot>(
                stream: lastMessageQuery.snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> lastMessageSnapshot) {
                  if (lastMessageSnapshot.hasError) {
                    return Text("Erreur: ${lastMessageSnapshot.error}");
                  }

                  if (lastMessageSnapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  }

                  // Si la conversation n'a pas encore de messages, affichez un message
                  if (lastMessageSnapshot.data!.docs.isEmpty) {
                    return ListTile(
                      title: Text(participants.join(', ')),
                      subtitle: Text('Aucun message'),
                    );
                  }

                  Map<String, dynamic> lastMessageData = lastMessageSnapshot.data!.docs.first.data() as Map<String, dynamic>;
                  return ListTile(
                    title: Text(participants.join(', ')),
                    subtitle: Text(lastMessageData['content']),
                    trailing: Text(lastMessageData['timestamp'] != null ? (lastMessageData['timestamp'] as Timestamp).toDate().toString() : ''),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConversationPage(conversationId: conversation.id, participants: participants),
                        ),
                      );
                    },
                  );
                },
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Ouvrez la page de création d'une nouvelle conversation
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewConversationPage()),
          );
        },
        child: Icon(Icons.message),
        tooltip: 'Nouvelle conversation',
      ),
    );
  }
}
