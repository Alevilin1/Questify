import 'package:flutter/material.dart';

class SenhaField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Senha',
      ),
    );
  }
}
