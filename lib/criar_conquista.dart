import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Modelos/categoria.dart';
import 'package:flutter_quesfity/Modelos/conquista.dart';

import 'icones.dart';

class PaginaCriarConquista extends StatefulWidget {
  List<Conquista> listaDeConquistas = [];
  String id;
  PaginaCriarConquista(
      {super.key, required this.listaDeConquistas, required this.id});

  @override
  State<StatefulWidget> createState() {
    return PaginaCriarConquistaState();
  }
}

class PaginaCriarConquistaState extends State<PaginaCriarConquista> {
  TextEditingController tituloControler = TextEditingController();
  TextEditingController descricaoControler = TextEditingController();

  Icones listaIcones = Icones();
  IconData iconeSelecionado = Icons.add;

  @override
  Widget build(BuildContext context) {
    List<IconData> icones = listaIcones.icones;

    double Largura = MediaQuery.of(context).size.width;
    double Altura = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text("Criar Conquista"),
          actions: [
            IconButton(
                onPressed: () async {

                  
                  final firebaseUser = FirebaseAuth.instance.currentUser;

                   if (firebaseUser != null) {
                    String userId = firebaseUser.uid;

                  Conquista novaConquista = Conquista(
                    nome: tituloControler.text,
                    icone: iconeSelecionado,
                    descricao: descricaoControler.text,
                  );

                  setState(() {
                    widget.listaDeConquistas.add(novaConquista);
                  });

                  await novaConquista.salvar(widget.id, userId);
                  Navigator.pop(context, widget.listaDeConquistas);
                  }
                },
                icon: const Icon(Icons.check))
          ]),
      body: SizedBox(
        height: Altura,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).secondaryHeaderColor,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Básico", style: TextStyle(fontSize: 18)),
                    ],
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
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
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
                      expands: false,
                      maxLines: null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Recompensa", style: TextStyle(fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      const Row(
                        children: [
                          Text("Experiência", style: TextStyle(fontSize: 15)),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            onPressed: () {},
                            child: Text("Não definido",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor)),
                          )),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Avançado", style: TextStyle(fontSize: 18)),
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  color: Theme.of(context).primaryColor),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Condição de desbloqueio",
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Define as condições necessárias para que a conquista seja desbloqueada",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue,
                                              ),
                                              onPressed: () {},
                                              child: Text("Adicionar Condição",
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .primaryColor))))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          )),
                    ]),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
