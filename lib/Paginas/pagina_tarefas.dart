import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Componentes/progressao.dart';
import 'package:intl/intl.dart';
import 'package:flutter_quesfity/criar_tarefas.dart';
import 'package:flutter_quesfity/Modelos/tarefas.dart';
import 'package:flutter_quesfity/Modelos/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:vibration/vibration.dart';

class PrimeiraPagina extends StatefulWidget {
  final Usuario user;
  const PrimeiraPagina({super.key, required this.user});

  @override
  PrimeiraPaginaState createState() => PrimeiraPaginaState();
}

class PrimeiraPaginaState extends State<PrimeiraPagina> {
  bool? confirmacaoTarefa = false;
  List<Tarefas> listaDeTarefas = [];
  List<String> filtrosSelecionados = [];
  bool teste = true;

  List<Tarefas> _filtrarTarefas() {
    if (filtrosSelecionados.isEmpty) {
      return listaDeTarefas; // Retorna todas as tarefas se nenhum filtro estiver selecionado
    }

    return listaDeTarefas.where((tarefa) {
      return filtrosSelecionados.contains(
          tarefa.filtroTarefa); // Filtra com base nos filtros selecionados
    }).toList();
  }

  Future<void> _carregarTarefas() async {
    final firebaseUser = firebase_auth.FirebaseAuth.instance.currentUser;

    if (firebaseUser != null) {
      String userId = firebaseUser.uid; // Usando o uid do usuário autenticado

      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('tarefas')
          .orderBy('createdAt', descending: true)
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
            filtroTarefa: doc['filtroTarefa'],
            atributos: atributos,
          );
        }).toList();
      });
    } else {
      // Lidar com o caso em que não há usuário autenticado
      //print("Nenhum usuário autenticado.");
    }
  }

  @override
  void initState() {
    super.initState();
    _carregarTarefas();
  }

  void concluirTarefa(Tarefas tarefa) async {
    await tarefa.deletarTarefa(widget.user.id, tarefa); // Deleta a tarefa

    await Future.delayed(const Duration(milliseconds: 300));

    setState(() {
      tarefa.tarefaConcluida = true; // Conclui a tarefa
      listaDeTarefas.remove(tarefa); // Remove a tarefa da lista

      // Adicionando XP
      widget.user.xp += tarefa.xp;

      if (tarefa.atributos[0]) {
        widget.user.xpAtributos['forca'] += tarefa.xp / 2;
      }
      if (tarefa.atributos[1]) {
        widget.user.xpAtributos['inteligencia'] += tarefa.xp / 2;
      }
      if (tarefa.atributos[2]) {
        widget.user.xpAtributos['carisma'] += tarefa.xp / 2;
      }

      while (widget.user.xpAtributos['forca'] >=
          widget.user.xpDosAtributos('forca')) {
        widget.user.xpAtributos['forca'] -= widget.user
            .xpDosAtributos('forca'); // Remove XP para o proximo nivel
        widget.user.nivelAtributos['forca']++; // Aumenta o nível do atributo
      }

      while (widget.user.xpAtributos['inteligencia'] >=
          widget.user.xpDosAtributos('inteligencia')) {
        widget.user.xpAtributos['inteligencia'] -= widget.user
            .xpDosAtributos('inteligencia'); // Remove XP para o proximo nivel
        widget.user
            .nivelAtributos['inteligencia']++; // Aumenta o nivel do atributo
      }

      while (widget.user.xpAtributos['carisma'] >=
          widget.user.xpDosAtributos('carisma')) {
        widget.user.xpAtributos['carisma'] -= widget.user
            .xpDosAtributos('carisma'); // Remove XP para o proximo nivel
        widget.user.nivelAtributos['carisma']++; // Aumenta o nível do atributo
      }

      while (widget.user.xp >= widget.user.xpNivel()) {
        widget.user.xp -=
            widget.user.xpNivel(); // Remove XP para o proximo nivel
        widget.user.nivel++; // Aumenta o nível do usuário
      }

      widget
          .user.tarefasConcluidas++; // Aumenta o contador de tarefas concluidas
      widget.user.salvar(); // Salva o XP e o nível do usuário
    });
  }

  @override
  Widget build(BuildContext context) {
    final tarefasFiltradas = _filtrarTarefas();

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: teste,
            child: Card(
              color: Theme.of(context).cardColor,
              elevation: 4,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.remove_red_eye,
                            color: Colors.grey[700], size: 18),
                        const SizedBox(
                          width: 8,
                        ),
                        GestureDetector(
                          child: Text(
                            "Esconder",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[700]),
                          ),
                          onTap: () {
                            setState(() {
                              teste = !teste;
                            });
                          },
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Nível ${widget.user.nivel}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'PlusJakartaSans',
                          ),
                        ),
                        Text(
                          "${widget.user.xp.toInt()}/${widget.user.xpNivel().toInt()} XP",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Progressao(user: widget.user),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat.MMMMEEEEd().format(DateTime.now()),
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    )
                  ],
                ),
              ),
            ),
          ),
          teste ? const SizedBox(height: 16) : const SizedBox(),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: widget.user.filtros.map((filtros) {
                return Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: FilterChip(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    label: Text(
                      filtros,
                      style: const TextStyle(fontFamily: 'PlusJakartaSans'),
                    ),
                    selected: filtrosSelecionados.contains(filtros),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          filtrosSelecionados.add(filtros);
                        } else {
                          filtrosSelecionados.remove(filtros);
                        }
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          listaDeTarefas.isEmpty
              ? const SizedBox()
              : const SizedBox(height: 24),
          Expanded(
            child: Scaffold(
              floatingActionButton: FloatingActionButton(
                // Botaão para criar uma nova tarefa
                elevation: 5,
                backgroundColor:
                    Theme.of(context).floatingActionButtonTheme.backgroundColor,
                shape: const CircleBorder(),
                child: const Icon(Icons.add, size: 28),
                onPressed: () async {
                  final resultado = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CriarTarefa(
                        listaDeTarefas: List.from(listaDeTarefas),
                        user: widget.user,
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
              backgroundColor: Theme.of(context).primaryColor,
              body: listaDeTarefas.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.search, size: 64, color: Colors.grey[400]),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //Icon(Icons.search, size: 32),
                              //SizedBox(width: 8),
                              Text(
                                "Sem tarefas",
                                style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontSize: 24,
                                    color: Colors.grey[700]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Toque no botão + para criar uma tarefa.",
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView(
                      children: tarefasFiltradas.map((tarefa) {
                        return Card(
                          color: Theme.of(context).cardColor,
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            title: Text(
                              tarefa.titulo,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            leading: Checkbox(
                              activeColor: Colors.white,
                              value: tarefa.tarefaConcluida,
                              onChanged: (value) async {
                                if (value != null && value == true) {
                                  setState(() {
                                    tarefa.tarefaConcluida = value;
                                    concluirTarefa(tarefa);
                                  });

                                  if (await Vibration.hasVibrator() != null) {
                                    await Vibration.vibrate(duration: 100);
                                  }
                                }
                              },
                            ),
                            subtitle: tarefa.descricao.isNotEmpty
                                ? Text(
                                    tarefa.descricao,
                                    style: const TextStyle(fontSize: 14),
                                  )
                                : null,
                            trailing: Text(
                              "${tarefa.xp} XP",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
