import 'package:capped_progress_indicator/capped_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Modelos/user.dart';

class Progressao extends StatefulWidget {
  final Usuario user;
  const Progressao({super.key, required this.user});
  @override
  ProgressaoState createState() => ProgressaoState();
}

class ProgressaoState extends State<Progressao> {
  bool animar = true;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(
        begin: 0.0,
        end: widget.user.progressao(),
      ),
      duration: animar
          ? const Duration(milliseconds: 500)
          : const Duration(seconds: 0), // Ajuste o tempo da animação
      builder: (context, double value, child) {
        return LinearCappedProgressIndicator(
          minHeight: 10,
          color: Theme.of(context).sliderTheme.activeTrackColor,
          backgroundColor: const Color(0xFFCCCCCC),
          value: value,
        );
      },
    );
  }
}
