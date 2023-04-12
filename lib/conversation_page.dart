import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConversationPage extends StatefulWidget {
  final String conversationId;
  final List<dynamic> participants;

  const ConversationPage({Key? key, required this.conversationId, required this.participants})
      : super(key: key);

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  late Stream<QuerySnapshot> messagesStream;

  @override
  void initState() {
    super.initState();

    messagesStream = FirebaseFirestore.instance
        .collection('conversations')
        .doc(widget.conversationId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversation avec ${widget.participants.join(', ')}'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: messagesStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Erreur: ${snapshot.error}");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          return ListView(
            reverse: true,
            children: snapshot.data!.docs.map((DocumentSnapshot message) {
              Map<String, dynamic> messageData = message.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(messageData['content']),
                subtitle: Text(messageData['timestamp'] != null
                    ? (messageData['timestamp'] as Timestamp).toDate().toString()
                    : ''),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
