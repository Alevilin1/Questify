import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Titulo extends StatelessWidget {
  InputDecoration inputDecoration;
  InputDecoration inputDecoration1;

  TextEditingController tituloControler = TextEditingController();
  TextEditingController descricaoControler = TextEditingController();

  Titulo({
    required this.tituloControler,
    required this.inputDecoration,
    required this.descricaoControler,
    required this.inputDecoration1,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            "Básico",
            style: TextStyle(fontSize: 18),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: TextFormField(
            controller: tituloControler,
            decoration: inputDecoration,
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: TextFormField(
            maxLines: null,
            expands: false,
            controller: descricaoControler,
            decoration: inputDecoration1,
          ),
        ),
        const SizedBox(
          height: 15,
        )
      ],
    );
  }
}
