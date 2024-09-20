import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Modelos/user.dart';
import 'package:wave_linear_progress_indicator/wave_linear_progress_indicator.dart';

class BarraUsuario extends StatefulWidget {
  final User user;
  const BarraUsuario({super.key, required this.user});

  @override
  BarraUsuarioState createState() => BarraUsuarioState();
}

class BarraUsuarioState extends State<BarraUsuario> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).secondaryHeaderColor,
          borderRadius: BorderRadius.circular(10),),
        height: 150,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Alexandre'),
              Text("Nivel: ${widget.user.nivel}", style: const TextStyle(fontSize: 15),),
              SizedBox(
                child: WaveLinearProgressIndicator(
                  value: widget.user
                      .progressao(), //A barra de progressão vai de 0 a 1
                ),
              )
            ]
          ),
        ),
      ),
    );
  }
}
/*

child: WaveLinearProgressIndicator(
                            value: widget.user
                                .progressao(), //A barra de progressão vai de 0 a 1
                          ),


*/



/*

Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      height: 150,
      child: Card(
          color: Theme.of(context).secondaryHeaderColor,
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
*/