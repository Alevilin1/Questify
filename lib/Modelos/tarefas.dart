import 'package:cloud_firestore/cloud_firestore.dart';

//Classe modelo para as tarefas
class Tarefas {
  String id;
  String titulo;
  String descricao;
  double xp;
  DateTime? data = DateTime.now();
  String filtroTarefa;
  bool? tarefaConcluida = false;
  List<bool> atributos;

  Tarefas({
    this.id = '',
    required this.xp,
    required this.titulo,
    required this.descricao,
    required this.atributos,
    this.data,
    this.tarefaConcluida = false,
    this.filtroTarefa = '',
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
      'tarefaConcluida': tarefaConcluida,
      'xp': xp,
      'atributos': atributos,
      'filtroTarefa': filtroTarefa,
      'createdAt': FieldValue.serverTimestamp(), // Adiciona o Timestamp ao criar
    });
    id = docRef.id;
  }

  // Funcao para deletar a tarefa do banco de dados
  Future<void> deletarTarefa(String userId, Tarefas tarefa) async {
    if (tarefa.id.isNotEmpty) {
      // Verifica se o ID da tarefa não é vazio
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('tarefas')
          .doc(tarefa.id) // Usa o ID da tarefa para deletá-la
          .delete();
    } else {
      throw Exception(
          'ID da tarefa está vazio'); // Exceção se o ID da tarefa estiver vazio
    }
  }
}
