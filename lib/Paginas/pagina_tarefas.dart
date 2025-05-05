import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:flutter_quesfity/Classes/dark_theme.dart';
import 'package:flutter_quesfity/Classes/tarefas.dart';
//import 'package:flutter_quesfity/Componentes/progressao.dart';
import 'package:flutter_quesfity/Classes/lista_tarefas.dart';
//import 'package:flutter_quesfity/Componentes/side_bar.dart';
//import 'package:flutter_quesfity/data.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:intl/intl.dart';
import 'package:flutter_quesfity/Paginas/pagina_criar_tarefas.dart';
//import 'package:flutter_quesfity/Classes/tarefas.dart';
import 'package:flutter_quesfity/Classes/user.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
//import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
//import 'package:vibration/vibration.dart';

class PrimeiraPagina extends StatefulWidget {
  final User user;
  final bool cabecalho;
  const PrimeiraPagina(
      {super.key, required this.user, required this.cabecalho});

  @override
  PrimeiraPaginaState createState() => PrimeiraPaginaState();
}

class PrimeiraPaginaState extends State<PrimeiraPagina> {
  bool? confirmacaoTarefa = false;
  List<String> filtrosSelecionados = [];
  final _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ListaTarefas>(context, listen: false)
          .carregarTarefas(); // Carregando do banco de dados
    });
  }

  @override
  Widget build(BuildContext context) {
    final providerTarefas =
        Provider.of<ListaTarefas>(context); // Provider de tarefas
    final darkTheme = Provider.of<IsDark>(context).isDarkTheme;
    var listaDeTarefas = providerTarefas.listaDeTarefas; // Lista de tarefas

    listaDeTarefas = providerTarefas.filtrarTarefas(filtrosSelecionados);

    return Scaffold(
      //drawer: const SideBar(),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.menu),
          ),
        ),
        title: const Text("Tarefas"),
        forceMaterialTransparency: true,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 24.0, right: 8),
        child: FloatingActionButton(
          elevation: 5,
          backgroundColor: Colors.white,
          shape: const CircleBorder(),
          child: const Icon(
            Icons.add,
            size: 28,
            color: Colors.black,
          ),
          onPressed: () async {
            final resultado = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CriarTarefa(
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
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).primaryColor,
        child: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Olá, ${widget.user.nome}",
                        style: GoogleFonts.poppins(
                            fontSize: 25,
                            fontWeight: FontWeight.w600,
                            color: !darkTheme
                                ? const Color(0xFF2E3A59)
                                : Colors.white),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Tenha um bom dia",
                        style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: !darkTheme
                                ? const Color(0xFF2E3A59)
                                : Colors.white),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: SizedBox(
                    height: 55,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.user.filtros.length,
                      itemBuilder: (context, index) {
                        return cardFiltros(index);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    "Tarefas",
                    style: GoogleFonts.poppins(
                        color:
                            !darkTheme ? const Color(0xFF2E3A59) : Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                listaDeTarefas.isEmpty
                    ? nenhumaTarefa()
                    : Expanded(
                        child: ListView.builder(
                        key: _listKey,
                        itemCount: listaDeTarefas.length,
                        padding: const EdgeInsets.only(left: 24, right: 24),
                        itemBuilder: (context, index) {
                          return cardTarefas(context, listaDeTarefas, index,
                              providerTarefas, darkTheme);
                        },
                      ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding nenhumaTarefa() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: Text(
        "Nenhuma tarefa foi encontrada",
        style: GoogleFonts.poppins(
            color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }

  Padding cardTarefas(BuildContext context, List<Tarefas> listaDeTarefas,
      int index, ListaTarefas providerTarefas, bool darkTheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18.0),
      child: Container(
        width: 200,
        height: 90,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Theme.of(context).cardColor),
        child: Center(
          child: ListTile(
            leading: Checkbox(
              value: listaDeTarefas[index].tarefaConcluida,
              onChanged: (value) {
                if (value != null && value == true) {
                  setState(() {
                    listaDeTarefas[index].tarefaConcluida = true;
                  });
                  providerTarefas.concluirTarefa(
                      listaDeTarefas[index], widget.user);
                }
              },
            ),
            dense: true,
            trailing:
                IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
            subtitle: listaDeTarefas[index].descricao.isEmpty
                ? null
                : Text(
                    listaDeTarefas[index].descricao,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w400),
                  ),
            title: Text(
              listaDeTarefas[index].titulo,
              style: GoogleFonts.poppins(
                  color: !darkTheme ? const Color(0xFF2E3A59) : Colors.white,
                  fontSize: Theme.of(context).textTheme.bodyLarge!.fontSize,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  Padding cardFiltros(int index) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (filtrosSelecionados.contains(widget.user.filtros[index])) {
              filtrosSelecionados.remove(widget.user.filtros[index]);
            } else {
              filtrosSelecionados.add(widget.user.filtros[index]);
            }
          });
        },
        child: Container(
          width: 100,
          //height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: filtrosSelecionados.contains(widget.user.filtros[index])
                ? Colors.white
                : const Color(0xFFE5EAFC),
          ),
          child: Center(
            child: Text(
              widget.user.filtros[index],
              style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontWeight:
                      filtrosSelecionados.contains(widget.user.filtros[index])
                          ? FontWeight.w600
                          : FontWeight.w400,
                  fontSize: 13),
            ),
          ),
        ),
      ),
    );
  }
}
