import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EscolherDificuldade extends StatefulWidget {
  final Function(double) onXPChanged; //Funcão que receberá o valor do slide

  const EscolherDificuldade({super.key, required this.onXPChanged});
  @override
  State<StatefulWidget> createState() {
    return EscolherDificuldadeState();
  }
}

class EscolherDificuldadeState extends State<EscolherDificuldade> {
  double xpDificuldadeTarefa = 0;
  double valorSlide = 0; //Valor do slide
  double valorAnterior = 0; //Valor anterior do slide

  void updateXpDificuldade(double value) {
    setState(() {
      if (value == 0) {
        xpDificuldadeTarefa = 0;
      } else if (value == 1) {
        xpDificuldadeTarefa = 10;
      } else if (value == 2) {
        xpDificuldadeTarefa = 20;
      } else if (value == 3) {
        xpDificuldadeTarefa = 30;
      }

      if (xpDificuldadeTarefa < 0) {
        xpDificuldadeTarefa = 0;
      }

      widget.onXPChanged(xpDificuldadeTarefa); //Setando o xp da tarefa
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
            "Dificuldade",
            style: TextStyle(fontSize: 15),
          ),
        ),
        Slider(
            //Slider para escolher a dificuldade
            value: valorSlide, //Valor na interface do usuario
            activeColor: Colors.orange,
            inactiveColor: Theme.of(context).sliderTheme.inactiveTrackColor,
            thumbColor: Theme.of(context).sliderTheme.thumbColor,
            min: 0, //Define o valor minimo
            max: 3, //Define o valor maximo
            divisions: 3, //Define o número de divisões
            label: valorSlide.round().toString(), //Define o texto do slide
            onChanged: (double value) {
              //Quando o valor do slide for alterado
              setState(() {
                valorSlide = value;
                updateXpDificuldade(value); //Atualiza o xp da tarefa

                /*Debug
                print(xpDificuldadeTarefa.toString());
                print("O valor atual é: ${valorSlide.toString()}");
                */
              });
            }),
      ],
    );
  }
}
