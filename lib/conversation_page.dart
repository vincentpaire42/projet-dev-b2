import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConversationPage extends StatefulWidget {
  final String? conversationId;
  final List<dynamic> participants;

  const ConversationPage({Key? key, required this.conversationId, required this.participants})
      : super(key: key);

  @override
  _ConversationPageState createState() => _ConversationPageState();
}


class _ConversationPageState extends State<ConversationPage> {
  late Stream<QuerySnapshot> messagesStream;
  final TextEditingController _messageController = TextEditingController();

  Future<String> getUserNameById(String userId) async {
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
    return '${userData['first_name']} ${userData['last_name']}';
  }

  @override
  void initState() {
    super.initState();

    messagesStream = FirebaseFirestore.instance
        .collection('messages')
        .where('conversationId', isEqualTo: widget.conversationId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    String content = _messageController.text.trim();
    _messageController.clear();

    await FirebaseFirestore.instance.collection('messages').add({
      'conversationId': widget.conversationId,
      'idFrom': widget.participants[0],
      'idTo': widget.participants[1],
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
      'type': 'text',
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<String>(
          future: getUserNameById(widget.participants.first),
          builder:
              (BuildContext context, AsyncSnapshot<String> userNameSnapshot) {
            if (userNameSnapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (userNameSnapshot.hasError) {
              return Text("Erreur: ${userNameSnapshot.error}");
            }

            return Text('Conversation avec ${userNameSnapshot.data!}');
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: messagesStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text("Erreur: ${snapshot.error}");
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                return ListView(
                  reverse: true,
                  children: snapshot.data!.docs.map((DocumentSnapshot message) {
                    Map<String, dynamic> messageData =
                        message.data() as Map<String, dynamic>;
                    return ListTile(
                      title: Text(messageData['content']),
                      subtitle: Text(messageData['timestamp'] != null
                          ? (messageData['timestamp'] as Timestamp)
                              .toDate()
                              .toString()
                          : ''),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: "Envoyer un message"),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
