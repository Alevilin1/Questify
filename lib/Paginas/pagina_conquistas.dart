import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Modelos/categoria.dart';
import 'package:flutter_quesfity/Modelos/conquista.dart';
import 'package:flutter_quesfity/criar_conquista.dart';

class PaginaConquistas extends StatefulWidget {
  String id;
  PaginaConquistas({super.key, required this.id});

  @override
  State<StatefulWidget> createState() {
    return PaginaConquistasState();
  }
}

class PaginaConquistasState extends State<PaginaConquistas> {
  List<Conquista> listaDeConquistas = [];
  bool isLoading = true;

  PaginaConquistasState() {}

  _carregarConquistas() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      String userId = firebaseUser.uid;
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('categorias')
          .doc(widget.id)
          .collection('conquistas')
          .get();

      setState(() {
        listaDeConquistas = [
          ...snapshot.docs.map((doc) {
            // Adiciona as categorias do Firebase
            int codigoIcone = doc['icone']; // Código do ícone
            return Conquista(
              nome: doc['nome'],
              icone: IconData(codigoIcone, fontFamily: 'MaterialIcons'),
              descricao: doc['descricao'],
            );
          }) //.toList()
        ];
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _carregarConquistas();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Conquistas"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SizedBox(
              width: width,
              height: height,
              child: listaDeConquistas.isEmpty
                  ? const Center(child: Text("Ainda nenhuma conquista"))
                  : ListView.builder(
                      itemCount: listaDeConquistas.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                            title: Text(
                              listaDeConquistas[index].nome,
                            ),
                            leading: Icon(
                              listaDeConquistas[index].icone,
                            ),
                            subtitle: listaDeConquistas[index].descricao.isEmpty
                                ? null
                                : Text(
                                    listaDeConquistas[index].descricao,
                                  ),
                            trailing: listaDeConquistas[index].desbloqueado
                                ? Text("Desbloqueado")
                                : Text("Bloqueado"));
                      },
                    ),
            ),
      floatingActionButton: widget.id == 'categoria_sistema'
          ? null
          : FloatingActionButton(
              onPressed: () async {
                final resultadoCriacao = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaginaCriarConquista(
                      listaDeConquistas: listaDeConquistas,
                      id: widget.id,
                    ),
                  ),
                );

                if (resultadoCriacao != null) {
                  // se a criação foi bem-sucedida
                  setState(() {
                    listaDeConquistas = resultadoCriacao; // Atualiza a lista
                    print(listaDeConquistas);
                  });
                }
              },
              heroTag: "btn3",
              elevation: 5,
              backgroundColor:
                  Theme.of(context).floatingActionButtonTheme.backgroundColor,
              shape: const CircleBorder(),
              child: const Icon(Icons.add),
            ),
    );
  }
}
