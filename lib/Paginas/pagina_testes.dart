import 'package:capped_progress_indicator/capped_progress_indicator.dart';
import 'package:flutter/material.dart';

class TestePagina extends StatefulWidget {
  const TestePagina({super.key});

  @override
  _TestePaginaState createState() => _TestePaginaState();
}

class _TestePaginaState extends State<TestePagina> {
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
          )
        ],
      ),
    );
  }
}
