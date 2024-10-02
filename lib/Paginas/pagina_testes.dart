import 'package:capped_progress_indicator/capped_progress_indicator.dart';
import 'package:flutter/material.dart';

class TestePagina extends StatefulWidget {
  @override
  _TestePaginaState createState() => _TestePaginaState();
}

class _TestePaginaState extends State<TestePagina> {
  double xp = 0;
  double progresso = 0;
  bool animar = true;

  verificacaoXP() {
    if (xp >= 1) {
      setState(() {
        Future.delayed(Duration(seconds: 1), () {
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

               xp += 0.25;

              
            },
          ),
          IconButton(
              onPressed: () {
                xp += 1.2;
                setState(() {});
                verificacaoXP();
              },
              icon: Icon(Icons.add))
        ],
      ),
    );
  }
}
