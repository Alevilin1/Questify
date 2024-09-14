import 'package:cloud_firestore/cloud_firestore.dart';

//Classe modelo para as tarefas
class Tarefas {
  String id;
  String titulo;
  String descricao;
  int dificuldade;
  DateTime? data = DateTime.now();
  String? filtro;
  bool? tarefaConcluida = false;

  Tarefas({
    this.id = '',
    required this.titulo,
    required this.descricao,
    required this.dificuldade,
    this.data,
    this.filtro,
    this.tarefaConcluida = false,
  });

  // Função para salvar tarefa no Firestore
  Future<void> salvar(String userId) async {
    DocumentReference docRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('tarefas')
        .add({
      'titulo': titulo,
      'descricao': descricao,
      'dificuldade': dificuldade,
      'tarefaConcluida': tarefaConcluida,
    });
    id = docRef.id;
  }

  // Funcao para deletar a tarefa do banco de dados
  Future<void> deletarTarefa(String userId, Tarefas tarefa) async {
    if (tarefa.id.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('tarefas')
          .doc(tarefa.id) // Usa o ID da tarefa para deletá-la
          .delete();
    } else {
      throw Exception('ID da tarefa está vazio');
    }
  }
}
