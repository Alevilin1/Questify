import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Categoria {
  String id;
  String titulo;
  String? descricao;
  IconData icone;

  Categoria({
    this.id = '',
    required this.titulo,
    this.descricao,
    required this.icone,
  });

    Future<void> salvar(String userId) async {
    DocumentReference docRef = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('categorias')
        .add({
      'titulo': titulo,
      'descricao': descricao,
      'icone': icone.codePoint
    });
    id = docRef.id;
  }





}
