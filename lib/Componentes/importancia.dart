import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EscolherImportancia extends StatefulWidget {
  final Function(double) onXPChanged; //Funcão que receberá o valor do slide

  EscolherImportancia({required this.onXPChanged});
  @override
  State<StatefulWidget> createState() {
    return EscolherImportanciaState();
  }
}

class EscolherImportanciaState extends State<EscolherImportancia> {
  double xpImportanciaTarefa = 0;
  double valorSlide = 0; //Valor do slide
  double valorAnterior = 0; //Valor anterior do slide

  void updateXpDificuldade(double value) {
      setState(() {
        if (value == 0) {
          xpImportanciaTarefa = 0;
        } else if (value == 1) {
          xpImportanciaTarefa = 10;
        } else if (value == 2) {
          xpImportanciaTarefa = 20;
        } else if (value == 3) {
          xpImportanciaTarefa = 30;
        }

        if (xpImportanciaTarefa < 0) {
          xpImportanciaTarefa = 0;
        }

        widget.onXPChanged(xpImportanciaTarefa); //Setando o xp da tarefa
      });
    
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 12), //Padding para o texto
          child: Text(
            "Importancia",
            style: TextStyle(fontSize: 15),
          ),
        ),
        Slider(
            //Slider para escolher a dificuldade
            value: valorSlide, //Valor na interface do usuario
            activeColor: Colors.orange,
            inactiveColor: Colors.white24,
            thumbColor: Colors.white,
            min: 0, //Define o valor minimo
            max: 3, //Define o valor maximo
            divisions: 3, //Define o número de divisões
            label: valorSlide.round().toString(), //Define o texto do slide
            onChanged: (double value) {
              setState(() {
                valorSlide = value;
                updateXpDificuldade(value); //Atualiza o xp da tarefa

                //Debug
                print(xpImportanciaTarefa.toString());
                print("O valor atual é: ${valorSlide.toString()}");
              });
            }),
      ],
    );
  }
}
