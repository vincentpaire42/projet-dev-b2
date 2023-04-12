import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:projet_dev_b2/conversation_page.dart';

class NewConversationPage extends StatefulWidget {
  @override
  _NewConversationPageState createState() => _NewConversationPageState();
}

class _NewConversationPageState extends State<NewConversationPage> {
  final TextEditingController _userIdController = TextEditingController();

  @override
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nouvelle conversation'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _userIdController,
              decoration: InputDecoration(
                labelText: "ID de l'utilisateur",
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                String userId = _userIdController.text.trim();
                if (userId.isNotEmpty) {
                  DocumentReference conversationRef = FirebaseFirestore.instance.collection('conversations').doc();
                  await conversationRef.set({
                    'participants': [userId],
                    'created_at': FieldValue.serverTimestamp(),
                  });

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ConversationPage(conversationId: conversationRef.id, participants: [userId]),
                    ),
                  );
                }
              },
              child: Text('Démarrer une conversation'),
            ),
          ],
        ),
      ),
    );
  }
}
