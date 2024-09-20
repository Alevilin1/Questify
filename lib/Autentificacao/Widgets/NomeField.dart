import 'package:flutter/material.dart';

class NomeField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Nome',
      ),
    );
  }
}
