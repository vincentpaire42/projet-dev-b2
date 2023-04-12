import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthenticationModel extends ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;

  Future<void> signUpAndSignIn(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null) {
        // Mettez à jour l'état de l'utilisateur connecté
        _currentUser = user;
        notifyListeners(); // N'oubliez pas d'appeler cette méthode pour mettre à jour l'état de l'application
      }
    } catch (e) {
      // Gérer les exceptions ici, par exemple, afficher un message d'erreur à l'utilisateur
    }
  }

// Vous pouvez ajouter d'autres méthodes d'authentification ici, comme signIn, signOut, etc.
}
