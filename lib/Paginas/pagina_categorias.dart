import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Componentes/componente_categoria.dart';
import 'package:flutter_quesfity/Modelos/categoria.dart';
import 'package:flutter_quesfity/criar_categoria.dart';

class PaginaCategorias extends StatefulWidget {
  const PaginaCategorias({super.key});

  @override
  State<StatefulWidget> createState() {
    return PaginaCategoriasState();
  }
}

class PaginaCategoriasState extends State<PaginaCategorias> {
  List<Categoria> listaDeCategorias = [];

  _carregarCategorias() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      String userId = firebaseUser.uid;
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('categorias')
          .get();

      setState(() {
        Categoria categoriaDoSistema = Categoria(
          id: 'categoria_sistema',
          titulo: 'Conquistas do Sistema',
          icone: Icons.emoji_events,
        );

        listaDeCategorias = [
          categoriaDoSistema, // Mantém a categoria do sistema manualmente

          ...snapshot.docs.map((doc) {
            // Adiciona as categorias do Firebase
            int codigoIcone = doc['icone']; // Código do ícone
            return Categoria(
              id: doc.id,
              titulo: doc['titulo'],
              icone:
                  IconData(codigoIcone, fontFamily: 'MaterialIcons'), // Ícone
            );
          }) //.toList()
        ];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _carregarCategorias();
  }

  @override
  Widget build(BuildContext context) {
    double Largura = MediaQuery.of(context).size.width;
    double Altura = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ListView(
            padding: EdgeInsets.zero,
            children: listaDeCategorias.map((conquistas) {
              return Column(
                children: [
                  ComponenteCategoria(
                    nomeLista: conquistas.titulo,
                    iconeLista: conquistas.icone,
                    id: conquistas.id,
                  ),
                ],
              );
            }).toList()),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(12),
        child: FloatingActionButton(
          heroTag: "btn2",
          elevation: 5,
          backgroundColor:
              Theme.of(context).floatingActionButtonTheme.backgroundColor,
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
          onPressed: () async {
            final resultadoCriacao = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaginaCriarListaConquista(
                    listaDeCategorias: listaDeCategorias),
              ),
            );

            if (resultadoCriacao != null) {
              // se a criação foi bem-sucedida
              setState(() {
                listaDeCategorias = resultadoCriacao; // Atualiza a lista
              });
            }
          },
        ),
      ),
    );
  }
}
