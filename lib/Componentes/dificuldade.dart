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
    if (value != valorAnterior) {
      setState(() {
        if (value > valorAnterior) {
          //Se o valor for maior que o valor anterior
          xpDificuldadeTarefa += 10; //Aumentando o xp da tarefa
        } else if (value < valorAnterior) {
          //Se o valor for menor que o valor anterior
          xpDificuldadeTarefa -= 10; //Diminuindo o xp da tarefa
        }

        if (xpDificuldadeTarefa < 0) {
          xpDificuldadeTarefa = 0;
        }

        widget.onXPChanged(xpDificuldadeTarefa); //Setando o xp da tarefa
      });

      valorAnterior = value; //Setando o valor anterior
      valorSlide = value; //Setando o valor do slide
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 12), //Padding para o texto
          child:  Text(
            "Dificuldade",
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
