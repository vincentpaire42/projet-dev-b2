import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// Créer une nouvelle conversation
Future<DocumentReference<Map<String, dynamic>>> createConversation(String userId, String recipientId) async {
  // Vérifier si la conversation existe déjà
  final existingConversations = await FirebaseFirestore.instance
      .collection('conversations')
      .where('participants', arrayContainsAny: [userId, recipientId])
      .get();

  if (existingConversations.docs.isNotEmpty) {
    return existingConversations.docs.first.reference;
  }

  // Créer une nouvelle conversation
  final conversationData = {
    'participants': [userId, recipientId],
    'createdAt': FieldValue.serverTimestamp(),
  };

  final conversationRef = await FirebaseFirestore.instance.collection('conversations').add(conversationData);

  // Créer une collection "messages" pour la nouvelle conversation
  await conversationRef.collection('messages').add({
    'from': userId,
    'to': recipientId,
    'content': 'Conversation créée',
    'timestamp': FieldValue.serverTimestamp(),
  });

  return conversationRef;
}

// Envoyer un message dans une conversation existante
Future<void> sendMessage(String conversationId, String fromUserId, String toUserId, String content) async {
  final messageData = {
    'from': fromUserId,
    'to': toUserId,
    'content': content,
    'timestamp': FieldValue.serverTimestamp(),
  };

  await FirebaseFirestore.instance.collection('conversations').doc(conversationId).collection('messages').add(messageData);
}
