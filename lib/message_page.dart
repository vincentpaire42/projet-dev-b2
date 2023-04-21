import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projet_dev_b2/conversation_page.dart';

class MessagePage extends StatefulWidget {
  MessagePage({Key? key}) : super(key: key);

  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  late String currentUserId;

  Future<String> getConversationId(String userId1, String userId2) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('conversations')
        .where('participants', arrayContains: userId1)
        .get();

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      List<dynamic> participants = data['participants'];
      if (participants.contains(userId2)) {
        return doc.id;
      }
    }

    // Crée une nouvelle conversation et récupère son ID
    DocumentReference conversationRef = await FirebaseFirestore.instance.collection('conversations').add({
      'participants': [userId1, userId2],
    });
    return conversationRef.id;
  }



  Future<List<Map<String, dynamic>>> getAllUsers() async {
    QuerySnapshot usersSnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    return usersSnapshot.docs
        .map((userDoc) => userDoc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    currentUserId = FirebaseAuth.instance.currentUser!.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messagessss'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getAllUsers(),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.hasError) {
            return Text("Erreur: ${snapshot.error}");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          List<Map<String, dynamic>> users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic> user = users[index];
              return ListTile(
                title: Text('${user['first_name']} ${user['last_name']}'),
                onTap: () async {
                  String? conversationId =
                      await getConversationId(currentUserId, user['id']);
                  if (conversationId == null) {
                    // Créez une nouvelle conversation et obtenez son ID
                    DocumentReference conversationRef = await FirebaseFirestore
                        .instance
                        .collection('conversations')
                        .add({
                      'participants': [currentUserId, user['id']],
                    });
                    conversationId = conversationRef.id;
                  }

                  if (conversationId != null) {
                    // Utilisez conversationId seulement si ce n'est pas nul
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConversationPage(
                          conversationId: conversationId!,
                          participants: [currentUserId, currentUserId],
                        ),
                      ),
                    );
                  } else {
                    // Gérez le cas où conversationId est nul
                    // par exemple, affichez un message d'erreur ou une alerte
                  }

                },
              );
            },
          );
          ;
        },
      ),
    );
  }
}
