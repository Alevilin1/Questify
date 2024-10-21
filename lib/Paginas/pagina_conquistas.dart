import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Modelos/conquista.dart';

class PaginaConquistas extends StatefulWidget {
  final List<Conquista> listaDeConquistas;
  const PaginaConquistas({super.key, required this.listaDeConquistas});

  @override
  State<PaginaConquistas> createState() => _PaginaConquistasState();
}

class _PaginaConquistasState extends State<PaginaConquistas> {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: widget.listaDeConquistas.map((conquistas) {
      return ListTile(
        title: Text(conquistas.nome),
        subtitle: Text(conquistas.descricao),
        leading: Icon(conquistas.icone, size: 28, color: conquistas.desbloqueado ? Colors.green : Colors.white),
        trailing: conquistas.desbloqueado
            ? const Icon(
                Icons.check_circle,
                color: Colors.green,
              )
            : const Icon(Icons.block),
      );
    }).toList());
  }
}
