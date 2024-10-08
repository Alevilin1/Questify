import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'user.dart';

class Conquista {
  String nome;
  String descricao = "";
  String id;
  IconData icone;
  bool desbloqueado;

  Conquista(
      {required this.icone,
      required this.nome,
      required this.descricao,
      this.id = '',
      this.desbloqueado = false  
    });

  Future<void> salvar(String categoriaId, String uid) async {
    DocumentReference docRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('categorias')
        .doc(categoriaId)
        .collection('conquistas')
        .add({'nome': nome, 'descricao': descricao, 'icone': icone.codePoint});

    id = docRef.id;
  }


  void verificarDesbloqueioConquista(User user, int quantidadeTarefas, Conquista conquista, String categoriaId, String userId) async {
   if(user.tarefasConcluidas >= quantidadeTarefas) {
     desbloqueado = true;
     await conquista.atualizar(categoriaId, userId);
   }
}

   Future<void> atualizar(String categoriaId, String uid) async {
    if (id.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('categorias')
          .doc(categoriaId)
          .collection('conquistas')
          .doc(id)
          .update({
        'desbloqueado': desbloqueado, // Atualizando o estado de desbloqueio
      });
    }
  }
}

