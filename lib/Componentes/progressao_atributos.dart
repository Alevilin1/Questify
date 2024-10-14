import 'package:capped_progress_indicator/capped_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Modelos/user.dart';

class ProgressaoAtributos extends StatelessWidget {
  final Usuario user;
  final String atributo;
  const ProgressaoAtributos(
      {super.key, required this.user, required this.atributo});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CircularCappedProgressIndicator(
          color: Theme.of(context).sliderTheme.activeTrackColor,
          backgroundColor: const Color(0xFFCCCCCC),
          value: user.progressaoDosAtributos(atributo),
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.orange),
        ),

        Text(
          "${user.nivelAtributos[atributo]}",)
      ],
    );
  }
}
