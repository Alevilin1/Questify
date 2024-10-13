import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Componentes/progressao.dart';
import 'package:flutter_quesfity/Componentes/progressao_atributos.dart';
import 'package:flutter_quesfity/Modelos/user.dart';

class StatusPagina extends StatefulWidget {
  final Usuario user;
  const StatusPagina({super.key, required this.user});

  @override
  State<StatefulWidget> createState() {
    return StatusPaginaState();
  }
}

class StatusPaginaState extends State<StatusPagina> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Theme.of(context).secondaryHeaderColor,
              ),
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Vida LV${widget.user.nivel}",
                    style: const TextStyle(
                        fontFamily: 'PlusJakartaSans', fontSize: 24),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(child: Progressao(user: widget.user)),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "${widget.user.xp.toInt()}/${widget.user.xpNivel().toInt()}",
                      ),
                    ],
                  ),
                  Text(
                      "Você concluiu ${widget.user.tarefasConcluidas} tarefas até o momento!"),
                  const SizedBox(
                    height: 4,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(8.0)),
                    ),
                    width: double.infinity,
                    child: Text("Atributos",
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 20,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        )),
                  ),
                  Container(
                      width: double.infinity,
                      color: Theme.of(context).secondaryHeaderColor,
                      child: Row(
                        children: [
                          Text(
                            "Força",
                            style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                                fontSize: 16),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                              child: ProgressaoAtributos(user: widget.user))
                        ],
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
