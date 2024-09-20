import 'package:flutter/material.dart';

class SenhaConfirmarField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Confirmar Senha',
      ),
    );
  }
}
