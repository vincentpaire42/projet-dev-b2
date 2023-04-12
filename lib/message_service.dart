// message_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String toUserId, String content) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      throw Exception("Utilisateur non connecté");
    }
    String currentUserId = currentUser.uid;


    if (currentUserId == null) {
      throw Exception("Utilisateur non connecté");
    }

    // Recherchez une conversation existante entre les deux utilisateurs
    QuerySnapshot existingConversations1 = await _firebaseFirestore
        .collection('conversations')
        .where('user1Id', isEqualTo: currentUserId)
        .where('user2Id', isEqualTo: toUserId)
        .get();

    QuerySnapshot existingConversations2 = await _firebaseFirestore
        .collection('conversations')
        .where('user1Id', isEqualTo: toUserId)
        .where('user2Id', isEqualTo: currentUserId)
        .get();

    String conversationId;

    if (existingConversations1.docs.isNotEmpty) {
      conversationId = existingConversations1.docs.first.id;
    } else if (existingConversations2.docs.isNotEmpty) {
      conversationId = existingConversations2.docs.first.id;
    } else {
      // Si aucune conversation existante n'est trouvée, créez-en une nouvelle
      DocumentReference newConversation = await _firebaseFirestore.collection('conversations').add({
        'user1Id': currentUserId,
        'user2Id': toUserId,
      });
      conversationId = newConversation.id;
    }

    // Ajoutez le message à la sous-collection "messages" de la conversation
    await _firebaseFirestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .add({
      'from': currentUserId,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
