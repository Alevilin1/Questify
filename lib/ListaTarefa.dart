import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Modelos/tarefas.dart';
import 'CriarTarefa.dart';

class ComponenteLista extends StatefulWidget {
  List<Tarefas> listaDeTarefas;
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
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          elevation: 5,
          shape: CircleBorder(),
          backgroundColor: Colors.white,
            child: const Icon(Icons.add, color: Colors.black,),
            onPressed: () async {
              final resultado = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CriarTarefa(
                          listaDeTarefas: List.from(widget.listaDeTarefas),
                        )),
              );
              if (resultado != null) {
                setState(() {
                  widget.listaDeTarefas = resultado;
                });
              }
            }),
        body: ListView.builder(
          itemCount: widget.listaDeTarefas.length, //Quantidade de tarefas
          itemBuilder: (context, index) {
            Tarefas tarefa = widget.listaDeTarefas[index]; //Recebe a tarefa
            return Container(
              child: CheckboxListTile(
                title: Text(tarefa.titulo),
                subtitle: tarefa.descricao != ""
                    ? Text(
                        tarefa.descricao,
                        maxLines: 1,
                      )
                    : null,
                activeColor: Colors.green,
                value:
                    tarefa.tarefaConcluida, //Verifica se a tarefa foi concluída
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      tarefa.tarefaConcluida = value;

                      widget.concluirTarefa(tarefa);
                    });
                  }
                },
              ),
            );
          },
        ));
  }
}



/*

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




*/


/*class ComponenteListaState extends State<ComponenteLista> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
            itemCount: widget.listaDeTarefas.length, //Quantidade de tarefas
            itemBuilder: (context, index) {
              Tarefas tarefa = widget.listaDeTarefas[index]; //Recebe a tarefa
              return Card(
                child: CheckboxListTile(
                  title: Text(tarefa.titulo),
                  checkboxShape: CircleBorder(),
                  subtitle: tarefa.descricao != ""
                      ? Text(
                          tarefa.descricao,
                          maxLines: 1,
                        )
                      : null,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.green,
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
              );
            }));
  }
}*/


/*

 Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            final resultado = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CriarTarefa(
                          listaDeTarefas: List.from(widget.listaDeTarefas),
                        )),
              );
          }),
        body: ListView.builder(
      itemCount: widget.listaDeTarefas.length, //Quantidade de tarefas
      itemBuilder: (context, index) {
        Tarefas tarefa = widget.listaDeTarefas[index]; //Recebe a tarefa
        return Container(
          child: CheckboxListTile(
            title: Text(tarefa.titulo),
            subtitle: tarefa.descricao != ""
                ? Text(
                    tarefa.descricao,
                    maxLines: 1,
                  )
                : null,
            activeColor: Colors.green,
            value: tarefa.tarefaConcluida, //Verifica se a tarefa foi concluída
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  tarefa.tarefaConcluida = value;

                  widget.concluirTarefa(tarefa);
                });
              }
            },
          ),
        );
      },
    ));
  }
}
*/



/*

  Expanded(
      
      child: ListView.builder(
        itemCount: widget.listaDeTarefas.length, //Quantidade de tarefas
        itemBuilder: (context, index) {
          Tarefas tarefa = widget.listaDeTarefas[index]; //Recebe a tarefa
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).secondaryHeaderColor,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    shape: CircleBorder(),
                    value: tarefa.tarefaConcluida,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          tarefa.tarefaConcluida = value;
                          widget.concluirTarefa(tarefa);
                        });
                      }
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tarefa.titulo,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Text(
                            tarefa.titulo,
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
*/



/*

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




*/


/*class ComponenteListaState extends State<ComponenteLista> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: ListView.builder(
            itemCount: widget.listaDeTarefas.length, //Quantidade de tarefas
            itemBuilder: (context, index) {
              Tarefas tarefa = widget.listaDeTarefas[index]; //Recebe a tarefa
              return Card(
                child: CheckboxListTile(
                  title: Text(tarefa.titulo),
                  checkboxShape: CircleBorder(),
                  subtitle: tarefa.descricao != ""
                      ? Text(
                          tarefa.descricao,
                          maxLines: 1,
                        )
                      : null,
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.green,
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
              );
            }));
  }
}*/


/*

 Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            final resultado = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CriarTarefa(
                          listaDeTarefas: List.from(widget.listaDeTarefas),
                        )),
              );
          }),
        body: ListView.builder(
      itemCount: widget.listaDeTarefas.length, //Quantidade de tarefas
      itemBuilder: (context, index) {
        Tarefas tarefa = widget.listaDeTarefas[index]; //Recebe a tarefa
        return Container(
          child: CheckboxListTile(
            title: Text(tarefa.titulo),
            subtitle: tarefa.descricao != ""
                ? Text(
                    tarefa.descricao,
                    maxLines: 1,
                  )
                : null,
            activeColor: Colors.green,
            value: tarefa.tarefaConcluida, //Verifica se a tarefa foi concluída
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  tarefa.tarefaConcluida = value;

                  widget.concluirTarefa(tarefa);
                });
              }
            },
          ),
        );
      },
    ));
  }
}
*/



/*

  Expanded(
      
      child: ListView.builder(
        itemCount: widget.listaDeTarefas.length, //Quantidade de tarefas
        itemBuilder: (context, index) {
          Tarefas tarefa = widget.listaDeTarefas[index]; //Recebe a tarefa
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).secondaryHeaderColor,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    shape: CircleBorder(),
                    value: tarefa.tarefaConcluida,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          tarefa.tarefaConcluida = value;
                          widget.concluirTarefa(tarefa);
                        });
                      }
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tarefa.titulo,
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Text(
                            tarefa.titulo,
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

*/