import 'package:dropdown_button2/dropdown_button2.dart';
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
  User user;

  CriarTarefa({required this.listaDeTarefas, required this.user});

  @override
  State<StatefulWidget> createState() {
    return CriarTarefaState();
  }
}

class CriarTarefaState extends State<CriarTarefa> {
  TextEditingController tituloControler = TextEditingController();
  TextEditingController descricaoControler = TextEditingController();

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
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Nova Tarefa"),
        actions: [
          IconButton(
            onPressed: () async {
              final firebaseUser =
                  firebase_auth.FirebaseAuth.instance.currentUser;

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
                  widget.listaDeTarefas.add(novaTarefa);
                });

                // Depois de criar a tarefa, volta para a página principal
                Navigator.pop(context, widget.listaDeTarefas);
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).secondaryHeaderColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Básico",
                                style: TextStyle(fontSize: 18),
                              ),
                              ActionChip(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                label: const Text(
                                  "Filtros",
                                  style: TextStyle(fontSize: 12),
                                ),
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: TextFormField(
                            controller: tituloControler,
                            decoration: _inputDecoration("Título"),
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
                          child: DropdownButton2(
                            isExpanded: true,
                            autofocus: true,
                            hint: Text(
                              filtroSelecionado.isEmpty ? 'Selecione um filtro' : filtroSelecionado,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            buttonStyleData: ButtonStyleData(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            items: widget.user.filtros.map((filtro) {
                              return DropdownMenuItem(
                                value: filtro,
                                child: Text(filtro),
                              );
                            }).toList(), // Aqui convertemos o Iterable para List com toList()
                            onChanged: (selectedValue) {

                              setState(() {
                                filtroSelecionado = selectedValue.toString();
                              });
                            
                              // Sua lógica de mudança aqui
                              print(selectedValue);
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
