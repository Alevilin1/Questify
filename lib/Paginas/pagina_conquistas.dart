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
    return Placeholder(
        child: Column(
            children: widget.listaDeConquistas.map((conquistas) {
      return ListTile(
        title: Text(conquistas.nome),
        subtitle: Text(conquistas.descricao),
        leading: Icon(conquistas.icone),
        trailing: conquistas.desbloqueado ? const Icon(Icons.check_circle, color: Colors.green,) : Icon(Icons.block),
      );
    }).toList()));
  }
}
