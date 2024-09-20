import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Modelos/user.dart';


class StatusPagina extends StatefulWidget {
  User user;
  StatusPagina({required this.user});

  @override
  State<StatefulWidget> createState() {
    return StatusPaginaState();
  }
}

class StatusPaginaState extends State<StatusPagina> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("Força LV${widget.user.nivelAtributos['forca']}",
                style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
