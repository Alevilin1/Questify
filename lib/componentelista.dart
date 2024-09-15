import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Modelos/tarefas.dart';

class ComponenteLista extends StatefulWidget {
  final List<Tarefas> listaDeTarefas;
  final void Function(Tarefas tarefa) concluirTarefa;

  ComponenteLista({
    required this.listaDeTarefas,
    required this.concluirTarefa,
  });

  @override
  State<StatefulWidget> createState() {
    return ComponenteListaState();
  }
}

class ComponenteListaState extends State<ComponenteLista> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView(
      children: widget.listaDeTarefas.map((tarefa) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Row(
              children: [
                Checkbox(
                  value: tarefa
                      .tarefaConcluida, //Verifica se a tarefa foi concluída
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        tarefa.tarefaConcluida = value;


                        widget.concluirTarefa(tarefa);
                      });
                    }
                  },
                ),
                Text(tarefa.titulo),
                Text(
                  " Teste ID: ${tarefa.id}",
                  style: TextStyle(color: Colors.red),
                )
              ],
            ),
          ),
        );
      }).toList(),
    ));
  }
}
