import 'package:flutter/material.dart';

class Emailfield extends StatelessWidget {
  TextEditingController emailControler = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Email'),
      controller: emailControler,
    );
  }
}
