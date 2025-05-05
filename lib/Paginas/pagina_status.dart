import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Classes/conquista.dart';
//import 'package:flutter_quesfity/Componentes/progressao.dart';
import 'package:flutter_quesfity/Classes/user.dart';
import 'package:flutter_quesfity/Componentes/side_bar.dart';
import 'package:flutter_quesfity/Paginas/pagina_conquistas.dart';
import 'package:flutter_quesfity/data.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:wave_linear_progress_indicator/wave_linear_progress_indicator.dart';

class StatusPagina extends StatefulWidget {
  final User user;
  final List<Conquista> listaDeConquistas;

  const StatusPagina(
      {super.key, required this.user, required this.listaDeConquistas});

  @override
  State<StatefulWidget> createState() {
    return StatusPaginaState();
  }
}

class StatusPaginaState extends State<StatusPagina> {
  @override
  Widget build(BuildContext context) {
    // Get the orientation
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: const SideBar(),
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) => IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ),
          ),
        ),
        forceMaterialTransparency: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        color: Theme.of(context).primaryColor,
        child:
            isPortrait ? _layoutVertical(context) : _layoutHorizontal(context),
      ),
    );
  }

  Widget _layoutVertical(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Stack(
          children: [
            componentePerfil(context),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.18,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        componenteInfo("Conquistas Desbloqueadas",
                            widget.user.conquistasDesbloqueadas.toString()),
                        const SizedBox(
                          width: 50,
                        ),
                        componenteInfo("Tarefas\nConcluidas",
                            widget.user.tarefasConcluidas.toString()),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Conquistas",
                                style: GoogleFonts.poppins(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PaginaConquistas(
                                          listaDeConquistas:
                                              widget.listaDeConquistas,
                                        ),
                                      ));
                                },
                                child: Text("Ver todas",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    )),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.listaDeConquistas.length,
                              itemBuilder: (context, index) {
                                return componenteConquistas(index);
                              },
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _layoutHorizontal(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10,
              bottom: 20,
            ),
            decoration:
                BoxDecoration(gradient: LinearGradient(colors: gradient)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile section
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          backgroundImage: NetworkImage(
                              "https://cdn.iconscout.com/icon/free/png-256/free-avatar-icon-download-in-svg-png-gif-file-formats--user-boy-avatars-flat-icons-pack-people-456322.png"),
                          radius: 40,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.user.nome.toString(),
                          style: GoogleFonts.poppins(
                              fontSize: 18, color: Colors.white),
                        ),
                        Text(
                          "Nivel: ${widget.user.nivel.toString()}",
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: 180,
                          height: 15,
                          child: LinearProgressIndicator(
                            borderRadius: BorderRadius.circular(15),
                            value: widget.user.progressao(),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "${widget.user.xp.toInt()}/${widget.user.xpNivel()} XP",
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                // Stats section
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            componenteInfo("Conquistas Desbloqueadas",
                                widget.user.conquistasDesbloqueadas.toString()),
                            const SizedBox(width: 20),
                            componenteInfo("Tarefas\nConcluidas",
                                widget.user.tarefasConcluidas.toString()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Conquistas section
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Conquistas",
                      style: GoogleFonts.poppins(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaginaConquistas(
                                listaDeConquistas: widget.listaDeConquistas,
                              ),
                            ));
                      },
                      child: Text("Ver todas",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey,
                          )),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.listaDeConquistas.length,
                    itemBuilder: (context, index) {
                      return componenteConquistas(index);
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding componenteConquistas(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                gradient: widget.listaDeConquistas[index].desbloqueado
                    ? LinearGradient(colors: gradient)
                    : null,
                color: Colors.white,
                borderRadius: BorderRadius.circular(20)),
            width: 75,
            height: 75,
            child: Icon(
              !widget.listaDeConquistas[index].desbloqueado
                  ? Icons.lock
                  : widget.listaDeConquistas[index].icone,
              size: 33,
              color: widget.listaDeConquistas[index].desbloqueado
                  ? Colors.white
                  : Colors.grey,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            width: 80,
            child: Text(
              softWrap: true,
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
              widget.listaDeConquistas[index].desbloqueado
                  ? widget.listaDeConquistas[index].nome
                  : "Bloqueado",
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  Expanded componenteInfo(String texto, String texto2) {
    return Expanded(
      child: Container(
        height: 90,
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              texto2,
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Text(
              texto,
              softWrap: true,
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                  fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Container componentePerfil(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 2.2,
      decoration: BoxDecoration(gradient: LinearGradient(colors: gradient)),
      child: SafeArea(
        top: true,
        child: Column(
          children: [
            const CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://cdn.iconscout.com/icon/free/png-256/free-avatar-icon-download-in-svg-png-gif-file-formats--user-boy-avatars-flat-icons-pack-people-456322.png"),
              radius: 50,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.user.nome.toString(),
              style: GoogleFonts.poppins(fontSize: 20, color: Colors.white),
            ),
            Text(
              "Nivel: ${widget.user.nivel.toString()}",
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 1.5,
              height: 18,
              child: LinearProgressIndicator(
                borderRadius: BorderRadius.circular(18),
                value: widget.user.progressao(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "${widget.user.xp.toInt()}/${widget.user.xpNivel()} XP",
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
