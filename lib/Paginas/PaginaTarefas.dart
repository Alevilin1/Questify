import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_quesfity/CriarTarefa.dart';
import 'package:flutter_quesfity/Modelos/tarefas.dart';
import 'package:flutter_quesfity/Modelos/user.dart';
import 'package:capped_progress_indicator/capped_progress_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PrimeiraPagina extends StatefulWidget {
  User user;
  PrimeiraPagina({required this.user});

  @override
  _PrimeiraPaginaState createState() => _PrimeiraPaginaState();
}

class _PrimeiraPaginaState extends State<PrimeiraPagina> {
  bool? confirmacaoTarefa = false;
  List<Tarefas> listaDeTarefas = [];

  @override
  void initState() {
    super.initState();
    _carregarUsuario(); // Carregando o usuário
    _carregarTarefas(); // Carregando tarefas
  }

  Future<void> _carregarTarefas() async {
    // Carregando tarefas
    String userId = "teste_uid"; // ID do usuário por enquanto é isso

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('tarefas')
        .get();

    setState(() {
      listaDeTarefas = snapshot.docs.map((doc) {
        List<dynamic> atributosList = doc['atributos'];
        List<bool> atributos = atributosList.map((e) => e as bool).toList();
        return Tarefas(
          id: doc.id,
          titulo: doc['titulo'],
          descricao: doc['descricao'],
          tarefaConcluida: doc['tarefaConcluida'],
          xp: doc['xp'],
          atributos: atributos,
        );
      }).toList();
    });
  }

  Future<void> _carregarUsuario() async {
    // Carregando o usuário
    String userId = "teste_uid";
    User? usuarioCarregado = await User.carregar(userId);
    if (usuarioCarregado != null) {
      widget.user = usuarioCarregado;
    } else {
      widget.user = User(id: userId);
      await widget.user.salvar();
    }
    setState(() {}); // Atualiza a interface
  }

  void concluirTarefa(Tarefas tarefa) async {
    await tarefa.deletarTarefa(widget.user.id, tarefa);

    setState(() {
      tarefa.tarefaConcluida = true;
      listaDeTarefas.remove(tarefa);

      // Adicionando XP
      widget.user.xp += tarefa.xp;

      if (tarefa.atributos[0]) {
        widget.user.xpAtributos['forca'] += tarefa.xp / 2;
      }
      if (tarefa.atributos[1]) {
        widget.user.xpAtributos['inteligencia'] += tarefa.xp / 2;
      }
      if (tarefa.atributos[2]) {
        widget.user.xpAtributos['destreza'] += tarefa.xp / 2;
      }

      while (widget.user.xp >= widget.user.xpNivel()) {
        widget.user.xp -= widget.user.xpNivel();
        widget.user.nivel++;
      }

      widget.user.salvar(); // Salva o XP e o nível do usuário
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'Seu nivel é: ${widget.user.nivel}',
                style: const TextStyle(
                    fontSize: 15, fontFamily: 'PlusJakartaSans'),
              ),
            ),
            LinearCappedProgressIndicator(
              minHeight: 10,
              color: const Color(0xFFFFFFFF),
              backgroundColor: const Color(0xFFCCCCCC),
              value: widget.user.progressao(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                DateFormat.MMMMEEEEd().format(DateTime.now()),
                style: const TextStyle(fontFamily: 'PlusJakartaSans'),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                FilterChip(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  label: const Text(
                    'Todos',
                    style: TextStyle(fontFamily: 'PlusJakartaSans'),
                  ),
                  onSelected: null,
                ),
                const SizedBox(width: 8),
                FilterChip(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  label: const Text(
                    'Pessoal',
                    style: TextStyle(fontFamily: 'PlusJakartaSans'),
                  ),
                  onSelected: null,
                ),
                const SizedBox(width: 8),
                FilterChip(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  label: const Text(
                    'Trabalho',
                    style: TextStyle(fontFamily: 'PlusJakartaSans'),
                  ),
                  onSelected: null,
                ),
                const SizedBox(width: 8),
                FilterChip(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  label: const Text(
                    'Estudo',
                    style: TextStyle(fontFamily: 'PlusJakartaSans'),
                  ),
                  onSelected: null,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Scaffold(
                // Tela de tarefas
                floatingActionButton: FloatingActionButton(
                  elevation: 5,
                  shape: const CircleBorder(),
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.add, color: Colors.black),
                  onPressed: () async {
                    final resultado = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CriarTarefa(
                          listaDeTarefas: List.from(listaDeTarefas),
                        ),
                      ),
                    );
                    if (resultado != null) {
                      setState(() {
                        listaDeTarefas = resultado;
                      });
                    }
                  },
                ),
                backgroundColor: Colors.black,
                body: listaDeTarefas.isEmpty
                    ? const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 32,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Nenhuma tarefa encontrada.",
                              style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      )
                    : ListView(
                        children: listaDeTarefas.map((tarefa) {
                          return Card(
                            child: CheckboxListTile(
                              title: Text(tarefa.titulo),
                              subtitle: tarefa.descricao != ""
                                  ? Text(
                                      tarefa.descricao,
                                      maxLines: 1,
                                    )
                                  : null,
                              secondary: Text(
                                "${tarefa.xp} XP",
                                style: const TextStyle(fontSize: 13),
                              ),
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: Colors.green,
                              value: tarefa.tarefaConcluida,
                              onChanged: (value) {
                                // Quando o checkbox for alterado
                                if (value != null) {
                                  setState(() {
                                    tarefa.tarefaConcluida = value;
                                    concluirTarefa(tarefa);
                                  });
                                }
                              },
                            ),
                          );
                        }).toList(),
                      ),
              ),
            ),
          ],
        ));
  }
}
