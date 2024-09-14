import 'Modelos/tarefas.dart';
import 'package:flutter/material.dart';


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
  int? _dificuldadeSelecionada;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crie sua Tarefa"),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            TextFormField(
              controller: tituloControler,
              decoration: const InputDecoration(
                  hintText: "Titulo da tarefa", border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: descricaoControler,
              decoration: const InputDecoration(
                  hintText: "Anotações", border: OutlineInputBorder()),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      _dificuldadeSelecionada = 1;
                    },
                    child: const Text("Fácil")),
                ElevatedButton(
                    onPressed: () {
                      _dificuldadeSelecionada = 2;
                    },
                    child: const Text("Médio")),
                ElevatedButton(
                    onPressed: () {
                      _dificuldadeSelecionada = 3;
                    },
                    child: const Text("Difícil"))
              ],
            ),
            ElevatedButton(
                onPressed: () async {
                  //Criando a tarefa com os dados do usuario
                  Tarefas novaTarefa = Tarefas(
                    titulo: tituloControler.text,
                    descricao: descricaoControler.text,
                    dificuldade: _dificuldadeSelecionada ?? 1,
                  );

                  // Salvando a tarefa no Firestore
                  await novaTarefa.salvar("teste_uid"); 

                  setState(() {
                    widget.listaDeTarefas.add(novaTarefa); //Adicionando a tarefa na lista
                  });

                  //Depois de criar a tarefa, volta para a pagina principal
                  Navigator.pop(context, widget.listaDeTarefas);

                  //Debug
                  
                  print(descricaoControler.text);
                  print(tituloControler.text);
                  print(_dificuldadeSelecionada);
                },
                child: Text("Adicionar")
            )
          ],
        ),
      ),
    );
  }
}
