import 'package:firebase_auth/firebase_auth.dart';

class AutentificacaoServico {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  cadastrarUsuario(
      {required String email,
      required String senha,
      required String nome}) async {
    await _auth.createUserWithEmailAndPassword(
        email: email, password: senha);
  }

  Future<String?> loginUsuario(
      {required String email, required String senha}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
      return null; // Retorna null se o login foi bem-sucedido
    } on FirebaseAuthException catch (e) {
      return e.message;
    }   
  }

  Future<void> deslogarUsuario() async {
    await _auth.signOut();
  }
}
