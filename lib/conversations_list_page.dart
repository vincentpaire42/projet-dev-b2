import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'conversations_page.dart';

class ConversationsListPage extends StatelessWidget {
  String getOtherParticipantId(String groupChatId, String currentUserId) {
    List<String> participants = groupChatId.split('-');
    return participants.firstWhere((participantId) => participantId != currentUserId);
  }

  Future<String> getOtherParticipantFirstName(String otherParticipantId) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(otherParticipantId).get();
    return doc.data()?['prenom'] ?? 'Inconnu';
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text("Conversations"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Voici vos conversations en cours:"),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collectionGroup('messages').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  print('Erreur détaillée: ${snapshot.error}');
                  return Center(
                      child: Text('Erreur lors de la récupération des conversations'));
                }

                try {
                  List<QueryDocumentSnapshot> filteredDocs = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return data['idFrom'] == currentUser;
                  }).toList();

                  return Material(
                    child: ListView.builder(
                      itemCount: filteredDocs.length,
                      itemBuilder: (context, index) {
                        final messageData = filteredDocs[index].data() as Map<String, dynamic>;
                        final groupChatId = filteredDocs[index].reference.parent.parent!.id;
                        final otherParticipantId = getOtherParticipantId(groupChatId, currentUser);

                        return ListTile(
                          title: FutureBuilder<String>(
                            future: getOtherParticipantFirstName(otherParticipantId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              }
                              if (snapshot.hasError) {
                                return Text('Erreur');
                              }
                              return Text(snapshot.data!);
                            },
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ConversationPage(
                                  conversationId: groupChatId,
                                  participants: [currentUser, otherParticipantId],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  );
                } catch (e) {
                  print('Erreur détaillée: $e');
                  return Center(
                      child: Text('Erreur lors de la récupération des conversations'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
