class Conversation {
  final String id;
  final List<String> participants;

  Conversation({required this.id, required this.participants});

  factory Conversation.fromMap(Map<String, dynamic> data) {
    return Conversation(
      id: data['id'],
      participants: List<String>.from(data['participants']),
    );
  }
}
