import 'package:capped_progress_indicator/capped_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Modelos/user.dart';

class ProgressaoAtributos extends StatelessWidget {

  final Usuario user;
  const ProgressaoAtributos({super.key, required this.user}); 
  
  @override
  Widget build(BuildContext context) {
    return LinearCappedProgressIndicator(
      minHeight: 10,
      color: Theme.of(context).sliderTheme.activeTrackColor,
      backgroundColor: const Color(0xFFCCCCCC),
      value: user.progressaoDosAtributos('forca'),
    );
  }
}
