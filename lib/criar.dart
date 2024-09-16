import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Componentes/atributos.dart';
import 'package:flutter_quesfity/Componentes/dificuldade.dart';
import 'package:flutter_quesfity/Componentes/importancia.dart';
import 'package:flutter_quesfity/Componentes/titulo.dart';
import 'Modelos/tarefas.dart';

// ignore: must_be_immutable
class CriarTarefa extends StatefulWidget {
  List<Tarefas> listaDeTarefas;

  CriarTarefa({required this.listaDeTarefas});

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
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
        title: const Text("Nova Tarefa"),
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
                child: Titulo(
                  tituloControler: tituloControler,
                  inputDecoration: _inputDecoration("Tarefas"),
                  inputDecoration1: _inputDecoration("Descrição"),
                  descricaoControler: descricaoControler,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).secondaryHeaderColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.only(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Tarefas novaTarefa = Tarefas(
                  titulo: tituloControler.text,
                  descricao: descricaoControler.text,
                  xp: xpCriacaoTarefa(),
                  atributos: atributosSelecionados,
                );

                // Salvando a tarefa no Firestore
                await novaTarefa.salvar("teste_uid");

                setState(() {
                  widget.listaDeTarefas.add(novaTarefa);
                });

                // Depois de criar a tarefa, volta para a página principal
                Navigator.pop(context, widget.listaDeTarefas);
              },
              child: const Text("Adicionar"),
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
