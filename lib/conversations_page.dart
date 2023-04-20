import 'package:flutter/material.dart';
import 'conversation.dart';
import 'conversation_service.dart';
class ConversationPage extends StatefulWidget {
  final String conversationId;
  final List<String> participants;

  const ConversationPage({
    Key? key,
    required this.conversationId,
    required this.participants,
  }) : super(key: key);

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final MessageDatabaseService _messageDatabaseService = MessageDatabaseService();
  final int messageLimit = 20; // Changez cette valeur pour afficher un nombre différent de messages

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Conversation'),
      ),
      body: StreamBuilder<List<Message>>(
        stream: _messageDatabaseService.getMessage(widget.conversationId, messageLimit),

        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final messages = snapshot.data!;
            return ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Text(message.content),
                  subtitle: Text(message.timestamp),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur lors du chargement des messages'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
