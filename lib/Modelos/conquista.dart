import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Conquista {
  String id;
  String nome;
  String descricao;
  final String idFuncao; // identificador da função associada
  bool desbloqueado = false;
  int quantidadeDesbloqueio;
  IconData? icone;

  Conquista(
      {this.id = '',
      required this.nome,
      required this.descricao,
      required this.idFuncao,
      this.desbloqueado = false,
      this.quantidadeDesbloqueio = 1,
      this.icone
    });

  void checarDesbloqueio() {
    if (!desbloqueado) {
      desbloqueado = true;
      print('Conquista desbloqueada: $nome');
    }
  }

  // Função para atualizar uma conquista específica do usuário
  Future<void> atualizarConquista(
      String userId, String conquistaId, bool desbloqueado) async {
    try {
      await FirebaseFirestore.instance
          .collection('users') // A coleção de usuários
          .doc(userId) // O ID do usuário
          .collection('conquistas') // A subcoleção de conquistas
          .doc(conquistaId) // O id da conquista
          .update({
        'desbloqueado': desbloqueado
      }); // Atualiza o campo "desbloqueado"

      print("Conquista atualizada com sucesso.");
    } catch (e) {
      print("Erro ao atualizar conquista: $e");
      //print("Erro");
    }
  }
}
