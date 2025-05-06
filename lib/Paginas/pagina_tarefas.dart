import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Classes/dark_theme.dart';
import 'package:flutter_quesfity/Classes/tarefas.dart';
import 'package:flutter_quesfity/Classes/lista_tarefas.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_quesfity/Paginas/pagina_criar_tarefas.dart';
import 'package:flutter_quesfity/Classes/user.dart';
import 'package:provider/provider.dart';

class PrimeiraPagina extends StatefulWidget {
  final User user;
  final bool cabecalho;
  const PrimeiraPagina(
      {super.key, required this.user, required this.cabecalho});

  @override
  PrimeiraPaginaState createState() => PrimeiraPaginaState();
}

class PrimeiraPaginaState extends State<PrimeiraPagina>
    with SingleTickerProviderStateMixin {
  bool? confirmacaoTarefa = false;
  List<String> filtrosSelecionados = [];
  final _listKey = GlobalKey<AnimatedListState>();
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ListaTarefas>(context, listen: false).carregarTarefas();
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final providerTarefas = Provider.of<ListaTarefas>(context);
    final darkTheme = Provider.of<IsDark>(context).isDarkTheme;
    var listaDeTarefas = providerTarefas.filtrarTarefas(filtrosSelecionados);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        leading: Builder(
          builder: (BuildContext context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(
              Icons.menu_rounded,
              color: darkTheme ? Colors.white : Colors.black87,
              size: 28,
            ),
          ),
        ),
        title: Text(
          "Tarefas",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: darkTheme ? Colors.white : Colors.black87,
          ),
        ),
        forceMaterialTransparency: true,
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _animationController.value,
            child: FloatingActionButton(
              elevation: 8,
              backgroundColor:
                  darkTheme ? const Color(0xFF3A49F9) : const Color(0xFF9C2CF3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.add,
                size: 28,
                color: Colors.white,
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
          );
        },
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          gradient: darkTheme
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF111111), Color(0xFF1E1E1E)],
                )
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFF2F5FF), Color(0xFFE5EAFC)],
                ),
        ),
        child: SafeArea(
          top: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, 30 * (1 - _animationController.value)),
                    child: Opacity(
                      opacity: _animationController.value,
                      child: Container(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /*Text(
                              "Olá, ${widget.user.nome}",
                              style: GoogleFonts.poppins(
                                fontSize: 30,
                                fontWeight: FontWeight.w700,
                                color: darkTheme
                                    ? Colors.white
                                    : const Color(0xFF2E3A59),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),*/
                            // Status do usuario
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 20),
                              decoration: BoxDecoration(
                                color: darkTheme
                                    ? const Color(0xFF1E1E1E).withOpacity(0.7)
                                    : Colors.white.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: darkTheme
                                        ? Colors.black12
                                        : Colors.black.withOpacity(0.05),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _statusItem("Nível", "${widget.user.nivel}",
                                      Icons.trending_up_rounded, darkTheme),
                                  _dividerStatus(darkTheme),
                                  _statusItem(
                                      "XP",
                                      "${widget.user.xp.toInt()}/${widget.user.xpNivel()}",
                                      Icons.flash_on,
                                      darkTheme),
                                  _dividerStatus(darkTheme),
                                  _statusItem(
                                      "Concluídas",
                                      "${widget.user.tarefasConcluidas}",
                                      Icons.task_alt,
                                      darkTheme),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Filtros
              AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, 20 * (1 - _animationController.value)),
                    child: Opacity(
                      opacity: _animationController.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 24, bottom: 10),
                            child: Text(
                              "Filtros",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: darkTheme
                                    ? Colors.white70
                                    : const Color(0xFF2E3A59),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: SizedBox(
                              height: 45,
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
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Titulo tarefas
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tarefas",
                      style: GoogleFonts.poppins(
                        color:
                            darkTheme ? Colors.white : const Color(0xFF2E3A59),
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "${listaDeTarefas.length} ${listaDeTarefas.length == 1 ? "tarefa" : "tarefas"}",
                      style: GoogleFonts.poppins(
                        color: darkTheme ? Colors.white70 : Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Lista de tarefas
              Expanded(
                child: listaDeTarefas.isEmpty
                    ? nenhumaTarefa()
                    : AnimatedBuilder(
                        animation: _animationController,
                        builder: (context, child) {
                          return ListView.builder(
                            key: _listKey,
                            itemCount: listaDeTarefas.length,
                            padding: const EdgeInsets.only(
                                left: 24, right: 24, bottom: 80),
                            itemBuilder: (context, index) {
                              // Efeito de animação
                              final itemAnimation =
                                  Tween(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                  parent: _animationController,
                                  curve: Interval(
                                    (1 / listaDeTarefas.length) * index,
                                    1.0,
                                    curve: Curves.easeOut,
                                  ),
                                ),
                              );

                              return Transform.translate(
                                offset:
                                    Offset(0, 30 * (1 - itemAnimation.value)),
                                child: Opacity(
                                  opacity: itemAnimation.value,
                                  child: cardTarefas(context, listaDeTarefas,
                                      index, providerTarefas, darkTheme),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusItem(
      String label, String value, IconData icon, bool darkTheme) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color:
                  darkTheme ? const Color(0xFF3A49F9) : const Color(0xFF9C2CF3),
            ),
            const SizedBox(width: 4),
            Text(
              value,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: darkTheme ? Colors.white : const Color(0xFF2E3A59),
              ),
            ),
          ],
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: darkTheme ? Colors.white60 : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _dividerStatus(bool darkTheme) {
    return Container(
      height: 30,
      width: 1,
      color: darkTheme ? Colors.white24 : Colors.black12,
    );
  }

  Widget nenhumaTarefa() {
    final darkTheme = Provider.of<IsDark>(context).isDarkTheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.task_alt,
            size: 64,
            color: darkTheme
                ? Colors.white.withOpacity(0.2)
                : Colors.grey.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            "Nenhuma tarefa encontrada",
            style: GoogleFonts.poppins(
              color: darkTheme ? Colors.white60 : Colors.grey,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Toque no botão + para adicionar",
            style: GoogleFonts.poppins(
              color: darkTheme ? Colors.white38 : Colors.grey.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget cardTarefas(BuildContext context, List<Tarefas> listaDeTarefas,
      int index, ListaTarefas providerTarefas, bool darkTheme) {
    // Create a priority color based on task index (just for visual variety)
    final Color priorityColor = index % 3 == 0
        ? const Color(0xFFFF6B6B) // Red
        : index % 3 == 1
            ? const Color(0xFF3A49F9) // Blue
            : const Color(0xFF9C2CF3); // Purple

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: darkTheme ? const Color(0xFF2A2D37) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: darkTheme
                  ? Colors.black.withOpacity(0.2)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Priority indicator
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 4,
                  color: priorityColor,
                ),
              ),

              // Task content
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  leading: Transform.scale(
                    scale: 1.2,
                    child: Checkbox(
                      value: listaDeTarefas[index].tarefaConcluida,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      activeColor: priorityColor,
                      checkColor: Colors.white,
                      onChanged: (value) {
                        if (value != null && value == true) {
                          setState(() {
                            listaDeTarefas[index].tarefaConcluida = true;
                          });

                          // Mostra a animação e depois conclui a tarefa
                          animacaoConclusao(
                                  context, listaDeTarefas[index].titulo)
                              .then((_) {
                            providerTarefas.concluirTarefa(
                                listaDeTarefas[index], widget.user);
                          });
                        }
                      },
                    ),
                  ),
                  title: Text(
                    listaDeTarefas[index].titulo,
                    style: GoogleFonts.poppins(
                      color: darkTheme ? Colors.white : const Color(0xFF2E3A59),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: listaDeTarefas[index].descricao.isEmpty
                      ? Row(
                          children: [
                            listaDeTarefas[index].filtroTarefa.isEmpty
                                ? Container()
                                : Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    margin: const EdgeInsets.only(top: 4),
                                    decoration: BoxDecoration(
                                      color: darkTheme
                                          ? const Color(0xFF3A3A3A)
                                          : const Color(0xFFE5EAFC),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      listaDeTarefas[index].filtroTarefa,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: darkTheme
                                            ? Colors.white70
                                            : const Color(0xFF2E3A59),
                                      ),
                                    ),
                                  ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 2),
                              margin: const EdgeInsets.only(top: 4),
                              decoration: BoxDecoration(
                                color: darkTheme
                                    ? const Color(0xFF3A3A3A)
                                    : const Color(0xFFE5EAFC),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.flash_on,
                                    size: 12,
                                    color: Color(0xFF9C2CF3),
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    "${listaDeTarefas[index].xp}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: darkTheme
                                          ? Colors.white70
                                          : const Color(0xFF2E3A59),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 4, bottom: 4),
                              child: Text(
                                listaDeTarefas[index].descricao,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: darkTheme
                                      ? Colors.white70
                                      : Colors.grey[600],
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                listaDeTarefas[index].filtroTarefa.isEmpty
                                    ? Container()
                                    : Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: darkTheme
                                              ? const Color(0xFF3A3A3A)
                                              : const Color(0xFFE5EAFC),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          listaDeTarefas[index].filtroTarefa,
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: darkTheme
                                                ? Colors.white70
                                                : const Color(0xFF2E3A59),
                                          ),
                                        ),
                                      ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: darkTheme
                                        ? const Color(0xFF3A3A3A)
                                        : const Color(0xFFE5EAFC),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.flash_on,
                                        size: 12,
                                        color: Color(0xFF9C2CF3),
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        "${listaDeTarefas[index].xp}",
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: darkTheme
                                              ? Colors.white70
                                              : const Color(0xFF2E3A59),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                  trailing: PopupMenuButton(
                    icon: Icon(
                      Icons.more_vert,
                      color: darkTheme ? Colors.white70 : Colors.grey[700],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: darkTheme ? const Color(0xFF2A2D37) : Colors.white,
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        onTap: () {
                          setState(() {
                            providerTarefas.removerTarefa(
                                listaDeTarefas[index], widget.user);
                          });
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete,
                              size: 20,
                              color: Colors.red[400],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Excluir',
                              style: GoogleFonts.poppins(
                                color: Colors.red[400],
                              ),
                            ),
                          ],
                        ),
                      ),
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

  Future<void> animacaoConclusao(BuildContext context, String taskTitle) async {
    final darkTheme = Provider.of<IsDark>(context, listen: false).isDarkTheme;

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1500),
            curve: Curves.elasticOut,
            tween: Tween<double>(begin: 0.4, end: 1.0),
            onEnd: () {
              Navigator.of(context).pop();
            },
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: darkTheme ? const Color(0xFF2A2D37) : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF9C2CF3).withOpacity(0.1),
                        ),
                        child: const Icon(
                          Icons.check_circle,
                          color: Color(0xFF9C2CF3),
                          size: 60,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Tarefa Concluída!",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: darkTheme
                              ? Colors.white
                              : const Color(0xFF2E3A59),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          taskTitle,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color:
                                darkTheme ? Colors.white70 : Colors.grey[600],
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
      },
    );
  }

  Widget cardFiltros(int index) {
    final darkTheme = Provider.of<IsDark>(context).isDarkTheme;
    final bool isSelected =
        filtrosSelecionados.contains(widget.user.filtros[index]);

    return Padding(
      padding: const EdgeInsets.all(4),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (isSelected) {
              filtrosSelecionados.remove(widget.user.filtros[index]);
            } else {
              filtrosSelecionados.add(widget.user.filtros[index]);
            }
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isSelected
                ? darkTheme
                    ? const Color(0xFF3A49F9)
                    : const Color(0xFF9C2CF3)
                : darkTheme
                    ? Colors.black.withOpacity(0.3)
                    : const Color(0xFFE5EAFC),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: (darkTheme
                              ? const Color(0xFF3A49F9)
                              : const Color(0xFF9C2CF3))
                          .withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
          child: Text(
            widget.user.filtros[index],
            style: GoogleFonts.poppins(
              color: isSelected
                  ? Colors.white
                  : darkTheme
                      ? Colors.white70
                      : const Color(0xFF2E3A59),
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}

/*

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

*/