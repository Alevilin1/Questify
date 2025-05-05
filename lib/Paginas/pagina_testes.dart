import 'package:animated_list_plus/animated_list_plus.dart';
import 'package:capped_progress_indicator/capped_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Classes/conquista.dart';
import 'package:flutter_quesfity/Classes/user.dart';
import 'package:flutter_quesfity/data.dart';
import 'package:google_fonts/google_fonts.dart';

class TestePagina extends StatefulWidget {
  final User user;
  final List<Conquista> listaDeConquistas;
  const TestePagina(
      {super.key, required this.user, required this.listaDeConquistas});

  @override
  TestePaginaState createState() => TestePaginaState();
}

class TestePaginaState extends State<TestePagina> {
  double barraProgresso = 0;
  double xp = 0;
  final listKey = GlobalKey<AnimatedListState>();
  double progresso = 0;
  bool animar = true;

  verificacaoXP() {
    if (xp >= 1) {
      setState(() {
        Future.delayed(const Duration(seconds: 1), () {
          xp -= xp;
          animar = false;
          setState(() {});
        });
      });
    }
  }

  List<String> testeLista = [
    "TESTE",
    "TESTE",
    "TESTE",
    "TESTE",
    "TESTE",
    "TESTE",
    "TESTE",
    "TESTE",
    "TESTE",
    "TESTE",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(),
        body: Row(
          children: [
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: testeLista.length,
                itemBuilder: (context, index) {
                  return cardFiltro(testeLista[index]);
                },
              ),
            )
          ],
        ));
  }

  Padding cardFiltro(filtro) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Container(
        width: 100,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Colors.white,
        ),
        child: Center(
          child: Text(
            filtro,
            style: GoogleFonts.poppins(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ),
      ),
    );
  }

  AnimatedList listaAnimada() {
    return AnimatedList(
        key: listKey,
        shrinkWrap: true,
        initialItemCount: testeLista.length,
        itemBuilder: (context, index, animation) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizeTransition(
              sizeFactor: animation,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    testeLista.removeAt(index);
                    listKey.currentState!.removeItem(
                        index,
                        (context, animation) => SizeTransition(
                              sizeFactor: animation,
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.black,
                                ),
                                child: const Center(
                                  child: Text(
                                    "TESTE",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ),
                            ));
                  });
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black,
                  ),
                  child: const Center(
                    child: Text(
                      "TESTE",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}


/*
Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Row(
                children: [Text('Conquistas')],
              ),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.listaDeConquistas.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                gradient:
                                    widget.listaDeConquistas[index].desbloqueado
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
                              color:
                                  widget.listaDeConquistas[index].desbloqueado
                                      ? Colors.white
                                      : Colors.grey,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(widget.listaDeConquistas[index].desbloqueado
                              ? widget.listaDeConquistas[index].nome
                              : "Bloqueado"),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                height: 70,
                width: 120,
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(40)),
                child: Center(child: Text("Pessoal")),
              )
            ],
          ),
        )

Column(
        children: [
          TweenAnimationBuilder(
            tween: Tween<double>(
              begin: 0.0,
              end: xp,
            ),
            duration:
                animar ? const Duration(milliseconds: 500) : Duration.zero,
            builder: (context, double value, child) {
              return LinearCappedProgressIndicator(
                minHeight: 10,
                color: const Color(0xFFFFFFFF),
                backgroundColor: const Color(0xFFCCCCCC),
                value: value,
              );
            },
            onEnd: () {
              if (!animar) {
                animar = true;
              }
            },
          ),
          IconButton(
              onPressed: () {
                xp += 1.2;
                setState(() {});
                verificacaoXP();
              },
              icon: const Icon(Icons.add)),
          AnimatedRotation(
            turns: barraProgresso / 100,
            duration: const Duration(seconds: 1),
            child:
                const Icon(Icons.light_mode, size: 100, color: Colors.orange),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Slider(
                value: barraProgresso, // Valor na interface do usuario
                min: 0,
                max: 100,
                activeColor: Colors.orange,
                onChanged: (double value) {
                  // Quando o valor do slide for alterado
                  setState(() {
                    barraProgresso = value;
                    xp = value / 100;
                  });
                }),
          ),
          /*IconButton(
            onPressed: () {
              showAlertBanner(
                  context,
                  () {},
                  alertBannerLocation: AlertBannerLocation.bottom,
                  safeAreaBottomEnabled: false,
                  safeAreaLeftEnabled: false,
                  const Text("Alerta"));
            },
            icon: const Icon(Icons.safety_check),
          ),*/
          ListView(
              shrinkWrap: true,
              children: widget.conquistas.map((conquista) {
                return ListTile(
                  title: Text(conquista.nome),
                  trailing: conquista.desbloqueado
                      ? const Icon(Icons.check)
                      : const Icon(Icons.block),
                  subtitle: Text(conquista.idFuncao),
                );
              }).toList()),

          )
        ],
      ),*/