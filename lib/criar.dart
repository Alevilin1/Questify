import 'package:flutter_quesfity/Componentes/atributos.dart';
import 'package:flutter_quesfity/Componentes/dificuldade.dart';
import 'package:flutter_quesfity/Componentes/importancia.dart';
import 'package:flutter_quesfity/Componentes/titulo.dart';
import 'Modelos/tarefas.dart';
import 'package:flutter/material.dart';

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
      xpDificuldadeTarefa = value; //Setando o xp da tarefa
    });
  }

  void updateXpImportancia(double value) {
    setState(() {
      xpImportanciaTarefa = value;
    });
  }

  double xpCriacaoTarefa() {
    return xpDificuldadeTarefa +
        xpImportanciaTarefa; //Retorna o xp da tarefa calculado
  }

  void updateAtributos(List<bool> atributos) {
    setState(() {
      atributosSelecionados = atributos;
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
                  borderRadius: BorderRadius.circular(15)),
              child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Titulo(
                    tituloControler: tituloControler,
                    inputDecoration: _inputDecoration("Tarefas"),
                    inputDecoration1: _inputDecoration("Descrição"),
                    descricaoControler: descricaoControler,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).secondaryHeaderColor,
                      borderRadius: BorderRadius.circular(15)),
                  //height: 300,
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
                                      fontSize: 15, color: Colors.orange),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                                //Slider para escolher a dificuldade
                                padding: const EdgeInsets.only(),
                                child: Column(
                                  //Coluna para os sliders
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    EscolherDificuldade(
                                      onXPChanged: updateXpDificuldade,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    EscolherImportancia(
                                        onXPChanged: updateXpImportancia),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Atributos(
                                      escolhaAtributos: updateAtributos,
                                    )
                                  ],
                                ))
                          ]))),
            ),
            ElevatedButton(
                onPressed: () async {
                  Tarefas novaTarefa = Tarefas(
                      //Criando uma nova tarefa
                      titulo: tituloControler.text, //Pegando os dados do titulo
                      descricao: descricaoControler
                          .text, //Pegando os dados da descricão
                      xp: xpCriacaoTarefa(),
                      atributos: atributosSelecionados //Pegando o xp da tarefa
                      );

                  // Salvando a tarefa no Firestore
                  await novaTarefa.salvar("teste_uid");

                  setState(() {
                    widget.listaDeTarefas
                        .add(novaTarefa); //Adicionando a tarefa na lista
                  });

                  //Depois de criar a tarefa, volta para a pagina principal
                  Navigator.pop(context, widget.listaDeTarefas);

                  print(atributosSelecionados);
                  print(descricaoControler.text); //Debug
                  print(tituloControler.text); //Debug
                },
                child: const Text("Adicionar"))
          ],
        ),
      ),
    );
  }
}

InputDecoration _inputDecoration(String nome) {
  //Funcionalidade para deixar o input mais bonito
  return InputDecoration(
      border: const OutlineInputBorder(),
      labelText: nome,
      floatingLabelStyle: const TextStyle(color: Colors.blue),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2.0)));
}
