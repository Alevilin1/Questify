import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Componentes/atributos.dart';
import 'package:flutter_quesfity/Componentes/dificuldade.dart';
import 'package:flutter_quesfity/Componentes/importancia.dart';
import 'package:flutter_quesfity/Modelos/user.dart';
import 'Modelos/tarefas.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

// ignore: must_be_immutable
class CriarTarefa extends StatefulWidget {
  List<Tarefas> listaDeTarefas;
  Usuario user;

  CriarTarefa({super.key, required this.listaDeTarefas, required this.user});

  @override
  State<StatefulWidget> createState() {
    return CriarTarefaState();
  }
}

class CriarTarefaState extends State<CriarTarefa> {
  TextEditingController tituloControler = TextEditingController();
  TextEditingController descricaoControler = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  double xpDificuldadeTarefa = 0;
  double xpImportanciaTarefa = 0;
  double xpAtributos = 0;
  String filtroSelecionado = '';

  List<bool> atributosSelecionados = [false, false, false];

  void updateXpDificuldade(double value) {
    setState(() {
      xpDificuldadeTarefa = value; // Atualiza o XP da dificuldade
    });
  }

  void updateXpImportancia(double value) {
    setState(() {
      xpImportanciaTarefa = value; // Atualiza o XP da importância
    });
  }

  double xpCriacaoTarefa() {
    return xpDificuldadeTarefa + xpImportanciaTarefa; // Retorna o XP total
  }

  void updateAtributos(List<bool> atributos) {
    setState(() {
      atributosSelecionados = atributos; // Atualiza atributos selecionados
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Nova Tarefa",
          style: TextStyle(fontFamily: 'PlusJakartaSans'),
        ),
        actions: [
          IconButton(
            onPressed: () async {
            if(_formKey.currentState!.validate()) {
              final firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;

              if (firebaseUser != null) {
                String userId = firebaseUser.uid;

                Tarefas novaTarefa = Tarefas(
                  titulo: tituloControler.text,
                  descricao: descricaoControler.text,
                  xp: xpCriacaoTarefa(),
                  atributos: atributosSelecionados,
                  filtroTarefa: filtroSelecionado,
                );

                // Salvando a tarefa no Firestore
                await novaTarefa.salvar(userId);

                setState(() {
                  widget.listaDeTarefas.insert(0, novaTarefa); // Inserindo a nova tarefa na lista no index 0
                });

                // Depois de criar a tarefa, volta para a página principal
                Navigator.pop(context, widget.listaDeTarefas);
                }
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Container(
                width: screenSize.width * 0.9,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(screenSize.width * 0.02),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Básico",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: TextFormField(
                              controller: tituloControler,
                              decoration: _inputDecoration("Título"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, digite um título';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 25),
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: TextFormField(
                              maxLines: null,
                              expands: false,
                              controller: descricaoControler,
                              decoration: _inputDecoration("Descrição"),
                            ),
                          ),
                          const SizedBox(height: 25),
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: DropdownButtonFormField(
                              isExpanded: true,
                              autofocus: false,
                              hint: Text(
                                filtroSelecionado.isEmpty
                                    ? 'Selecione um filtro'
                                    : filtroSelecionado,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              decoration: const InputDecoration(
                                labelText: 'Filtro',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(10),
                              ),
                              items: widget.user.filtros.map((filtro) {
                                return DropdownMenuItem(
                                  value: filtro,
                                  child: Text(filtro),
                                );
                              }).toList(), //Convertendo para lista
                              onChanged: (selectedValue) {
                                setState(() {
                                  filtroSelecionado = selectedValue.toString();
                                });
        
                                //print(selectedValue);
                              },
                            ),
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              "Avançado",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Text(
                            "+${xpCriacaoTarefa()}XP",
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Column(
                        children: [
                          EscolherDificuldade(
                            onXPChanged: updateXpDificuldade,
                          ),
                          const SizedBox(height: 10),
                          EscolherImportancia(
                            onXPChanged: updateXpImportancia,
                          ),
                          const SizedBox(height: 10),
                          Atributos(
                            escolhaAtributos: updateAtributos,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

InputDecoration _inputDecoration(String nome) {
  return InputDecoration(
    border: const OutlineInputBorder(),
    labelText: nome,
    floatingLabelStyle: const TextStyle(color: Colors.blue),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue, width: 2.0),
    ),
  );
}
