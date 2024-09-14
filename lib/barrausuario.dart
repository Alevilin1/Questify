import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Modelos/user.dart';

class BarraUsuario extends StatefulWidget {
  final User user;
  const BarraUsuario({super.key, required this.user});

  @override
  _BarraUsuarioState createState() => _BarraUsuarioState();
}

class _BarraUsuarioState extends State<BarraUsuario> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      height: 150,
      child: Card(
          color: Theme.of(context).primaryColorDark,
          child: Stack(children: [
            Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: CircleAvatar(
                    child: Text("A"),
                  ), //Avatar
                ),
                Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LinearProgressIndicator(
                            value: widget.user
                                .progressao(), //A barra de progressão vai de 0 a 1
                          ),
                        ),
                      ]),
                ),
              ],
            ),
            const Positioned(bottom: 60, left: 350, child: Text("")),
            Positioned(
                bottom: 64,
                left: 68,
                child: Text("Nivel: ${widget.user.nivel}"))
          ])),
    );
  }
}
