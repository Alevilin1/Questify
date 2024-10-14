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
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
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
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(child: Progressao(user: widget.user)),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "${widget.user.xp.toInt()}/${widget.user.xpNivel().toInt()}",
                        ),
                      ],
                    ),
                    Text(
                      "Você concluiu ${widget.user.tarefasConcluidas} tarefas até o momento!",
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).secondaryHeaderColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Text("Atributos", style: TextStyle(fontSize: 20)),
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Força",
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 18,
                            ),
                          ),
                          ProgressaoAtributos(
                              user: widget.user, atributo: 'forca'),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Inteligência",
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 18,
                            ),
                          ),
                          ProgressaoAtributos(
                              user: widget.user, atributo: 'inteligencia'),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Carisma",
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 18,
                            ),
                          ),
                          ProgressaoAtributos(
                              user: widget.user, atributo: 'carisma'),
                        ],
                      ),
                      const SizedBox(height: 4),
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
