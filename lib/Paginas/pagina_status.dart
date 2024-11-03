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
        padding: const EdgeInsets.all(16.0), // padding geral
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Theme.of(context).secondaryHeaderColor,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Vida LV${widget.user.nivel}",
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 26,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Progressao(user: widget.user),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "${widget.user.xp.toInt()}/${widget.user.xpNivel().toInt()}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Você concluiu ${widget.user.tarefasConcluidas} tarefas até o momento!",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                  height: 24), 

              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).secondaryHeaderColor,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: const [ // sombra ao redor dos atributos
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Atributos",
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const Divider(),
                    const SizedBox(height: 16),
                    _elementoAtributos("Força", 'forca'),
                    const SizedBox(height: 16),
                    _elementoAtributos("Inteligência", 'inteligencia'),
                    const SizedBox(height: 16),
                    _elementoAtributos("Carisma", 'carisma'),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// Método para construir linhas de atributos
  Widget _elementoAtributos(String title, String atributo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        ProgressaoAtributos(user: widget.user, atributo: atributo),
      ],
    );
  }
}
