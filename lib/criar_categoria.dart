import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Modelos/categoria.dart';
import 'package:flutter_quesfity/icones.dart';

class PaginaCriarListaConquista extends StatefulWidget {
  final List<Categoria> listaDeCategorias;

  const PaginaCriarListaConquista({super.key, required this.listaDeCategorias});
  @override
  State<StatefulWidget> createState() {
    return PaginaCriarListaConquistaState();
  }
}

class PaginaCriarListaConquistaState extends State<PaginaCriarListaConquista> {
  TextEditingController tituloControler = TextEditingController();
  TextEditingController descricaoControler = TextEditingController();

  bool jaCliquei = false;

  IconData iconeSelecionado = Icons.add;

  Icones classeIcones = Icones();

  @override
  Widget build(BuildContext context) {
    List icones = classeIcones.icones;

    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Nova Categoria"),
        actions: [
          IconButton(
              onPressed: () async {
                if (jaCliquei == false) { // se o botão ainda não foi clicado

                  setState(() {
                    jaCliquei = true; // marca o botão como clicado
                  });

                  final firebaseUser = FirebaseAuth.instance.currentUser;

                  if (firebaseUser != null) {
                    String userId = firebaseUser.uid;

                    Categoria novaCategoria = Categoria(
                      titulo: tituloControler.text,
                      icone: iconeSelecionado,
                      descricao: descricaoControler.text,
                    );

                    await novaCategoria.salvar(userId); // salva no firebase

                    setState(() {
                      widget.listaDeCategorias
                          .add(novaCategoria); // adiciona na lista
                    });

                    // ignore: use_build_context_synchronously
                    Navigator.pop(context, widget.listaDeCategorias);
                  }
                }
              },
              icon: const Icon(Icons.check))
        ],
      ),
      body: SizedBox(
          height: altura,
          width: largura,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Theme.of(context).secondaryHeaderColor,
              ),
              width: double.infinity,
              height: 100,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Basico", style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.blue,
                    child:
                        Icon(iconeSelecionado, size: 40, color: Colors.yellow),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                      style: ButtonStyle(
                        shape: WidgetStatePropertyAll<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                              side: const BorderSide(
                                color: Colors.grey,
                              )),
                        ),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                width: double.infinity,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 8,
                                      ),
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Selecione um icone",
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      Wrap(
                                          children: icones.map((icon) {
                                        return Container(
                                          margin: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            color: Colors.blue,
                                          ),
                                          width: 50,
                                          height: 50,
                                          child: IconButton(
                                            icon: Icon(icon,
                                                color: Colors.yellow),
                                            onPressed: () {
                                              setState(() {
                                                iconeSelecionado = icon;
                                              });
                                              Navigator.pop(context);
                                            },
                                          ),
                                        );
                                      }).toList())
                                    ],
                                  ),
                                ),
                              );
                            });
                      },
                      child: const Text("Alterar Icone",
                          style: TextStyle(
                            color: Colors.blue,
                          ))),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: tituloControler,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nome da categoria',
                        floatingLabelStyle: TextStyle(color: Colors.blue),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                        ),
                      ),
                      maxLength: 15,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: descricaoControler,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Descrição (opcional)',
                        floatingLabelStyle: TextStyle(color: Colors.blue),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0),
                        ),
                      ),
                      maxLength: 50,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
