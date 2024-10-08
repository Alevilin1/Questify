import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Modelos/conquista.dart';
import 'package:flutter_quesfity/Paginas/pagina_conquistas.dart';
import 'package:flutter_quesfity/icones.dart';

class ComponenteCategoria extends StatelessWidget {
  final String nomeLista;
  final IconData iconeLista;
  final String id;
  const ComponenteCategoria(
      {super.key,
      required this.nomeLista,
      required this.iconeLista,
      required this.id});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return PaginaConquistas(id: id,);
        }));
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).secondaryHeaderColor,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.blue,
              child: Icon(iconeLista, size: 40, color: Colors.yellow),
            ),
            const SizedBox(height: 8),
            Text(
              nomeLista,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            const Stack(alignment: Alignment.center, children: [
              SizedBox(
                width: 55,
                height: 55,
                child: CircularProgressIndicator(
                  semanticsValue: "1",
                  value: 1,
                  strokeWidth: 5,
                ),
              ),
              Text("0%", style: TextStyle(fontSize: 14))
            ])
          ],
        ),
      ),
    );
  }
}
