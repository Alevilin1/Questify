import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Componentes/progressao.dart';
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
                color: const Color(0xFF141118),
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
            Text("Força LV${widget.user.nivelAtributos['forca']}",
                style: const TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
