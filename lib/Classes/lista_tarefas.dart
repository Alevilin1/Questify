import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Classes/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'tarefas.dart';

class ListaTarefas extends ChangeNotifier {
  List<Tarefas> listaDeTarefas = [];

  void concluirTarefa(Tarefas tarefa, User user) async {
    tarefa.tarefaConcluida = true;
    user.xp += tarefa.xp;
    await Future.delayed(const Duration(milliseconds: 100));
    await tarefa.deletarTarefa(user.id, tarefa);
    listaDeTarefas.remove(tarefa);

    while (user.xp >= user.xpNivel()) {
      user.xp -= user.xpNivel(); // Remove XP para o proximo nivel
      user.nivel++; // Aumenta o nível do usuário
    }

    user.tarefasConcluidas++;
    user.salvar();

    notifyListeners();
  }

  List<Tarefas> filtrarTarefas(List<String> filtrosSelecionados) {
    if (filtrosSelecionados.isEmpty) {
      return listaDeTarefas;
    }

    // ignore: collection_methods_unrelated_type
    return listaDeTarefas
        .where((tarefa) => filtrosSelecionados.contains(tarefa.filtroTarefa))
        .toList();
  }

  void adicionarTarefa(Tarefas tarefa) {
    listaDeTarefas.insert(0, tarefa);
    notifyListeners();
  }

  void removerTarefa(Tarefas tarefa, User user) async {
    await tarefa.deletarTarefa(user.id, tarefa);
    listaDeTarefas.remove(tarefa);
    notifyListeners();
  }

  Future<void> carregarTarefas() async {
    final firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      String userId = firebaseUser.uid; // Usando o uid do usuário autenticado

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('tarefas')
          .orderBy('createdAt', descending: true)
          .get();

      listaDeTarefas = snapshot.docs.map((doc) {
        //List<dynamic> atributosList = doc['atributos'];
        //List<bool> atributos = atributosList.map((e) => e as bool).toList();
        return Tarefas(
          id: doc.id,
          titulo: doc['titulo'],
          descricao: doc['descricao'],
          tarefaConcluida: doc['tarefaConcluida'],
          xp: doc['xp'],
          filtroTarefa: doc['filtroTarefa'],
          //atributos: atributos,
        );
      }).toList();
    } else {
      // Lidar com o caso em que não há usuário autenticado
      //print("Nenhum usuário autenticado.");
    }
    notifyListeners();
  }
}
