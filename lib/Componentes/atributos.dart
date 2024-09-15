import 'package:flutter/material.dart';

class Atributos extends StatefulWidget {
  final Function(List<bool>) escolhaAtributos;

  const Atributos({super.key, required this.escolhaAtributos});

  @override
  State<StatefulWidget> createState() {
    return AtributosState();
  }
}

class AtributosState extends State<Atributos> {
  List<bool> selecionados = [false, false, false];

  void _atualizarAtributos() {
    widget.escolhaAtributos(selecionados);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(12),
          child: Text('Atributos'),
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        selecionados[0] = !selecionados[0];
                        if (selecionados[0] == true) {
                          _atualizarAtributos();

                          //Debug
                          //print("A força é ${selecionados[0]}");
                        }
                      });
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          width: 40,
                          height: 50,
                          child: Opacity(
                            opacity: selecionados[0] ? 1.0 : 0.3,
                            child: Image.asset('lib/Icones/forca.png'),
                          ),
                        ),
                       const Text("FOR")
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          selecionados[1] = !selecionados[1];
                          if (selecionados[1] == true) {
                            _atualizarAtributos();
                            //print("A inteligência é ${selecionados[1]}");
                          }
                        });
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            width: 40,
                            height: 50,
                            child: Opacity(
                              opacity: selecionados[1] ? 1.0 : 0.3,
                              child: Image.asset('lib/Icones/inteligencia.png'),
                            ),
                          ),
                          const Text(" INT")
                        ],
                      ),
                    ),
                  ],
                )),
            Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          selecionados[2] = !selecionados[2];
                          if (selecionados[2] == true) {
                            _atualizarAtributos();
                            //print("A inteligência é ${selecionados[2]}");
                          }
                        });
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            width: 40,
                            height: 50,
                            child: Opacity(
                              opacity: selecionados[2] ? 1.0 : 0.3,
                              child: Image.asset('lib/Icones/carisma.png'),
                            ),
                          ),
                          const Text("CAR")
                        ],
                      ),
                    ),
                  ],
                ))
          ],
        )
      ],
    );
  }
}
