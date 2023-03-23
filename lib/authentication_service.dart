import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String> signIn({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "Connexion réussie";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "Une erreur s'est produite lors de la connexion";
    } catch (e) {
      return "Une erreur inattendue s'est produite";
    }
  }


  Future<String> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return Future.value("Inscription réussie");
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    }
  }
}
