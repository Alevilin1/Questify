import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Modelos/user.dart';

class Levelup extends StatelessWidget {
  final User user;
  Levelup({required this.user});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text(
                "Ok",
                style: TextStyle(
                    fontFamily: 'PlusJakartaSans', color: Colors.white),
              ),
            )
          ],
        )
      ],
      title: Text("Você subiu para o nivel ${user.nivel}!",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'PlusJakartaSans',
          )),
      contentPadding: const EdgeInsets.all(20),
      content:
          const Text("Ao atingir seus objetivos na vida, você subiu de nivel!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
              )),
    );
  }
}
