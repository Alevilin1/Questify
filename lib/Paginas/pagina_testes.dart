import 'package:capped_progress_indicator/capped_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Modelos/conquista.dart';
import 'package:flutter_quesfity/Modelos/user.dart';


class TestePagina extends StatefulWidget {
  final Usuario user;
  final List<Conquista> conquistas;
  const TestePagina({super.key, required this.user, required this.conquistas});

  @override
  TestePaginaState createState() => TestePaginaState();
}

class TestePaginaState extends State<TestePagina> {
  double barraProgresso = 0;
  double xp = 0;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
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

        ],       
      ),
    );
  }
}
