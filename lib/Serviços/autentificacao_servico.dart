import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AutentificacaoServico {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  cadastrarUsuario(
      {required String email,
      required String senha,
      required String nome}) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: senha);

    await FirebaseFirestore.instance
        .collection("users")
        .doc(_auth.currentUser!.uid)
        .set({"nome": nome});
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
    await _auth.signOut(); // Desloga o usuario
  }

  Future<void> deletarConta() async {
    FirebaseFirestore firebase = FirebaseFirestore.instance;
    var uid = _auth.currentUser!.uid;
    var docConquistas = await firebase
        .collection("users")
        .doc(uid)
        .collection('conquistas')
        .get();

    for (final doc in docConquistas.docs) {
      await doc.reference.delete(); // Excluindo conquistas
    }

    await firebase
        .collection("users")
        .doc(uid)
        .delete(); // Deletando usuario do db
    await _auth.currentUser!.delete(); // Deletando usuario do auth
  }
}
