/*import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Componentes/componente_categoria.dart';
import 'package:flutter_quesfity/Modelos/categoria.dart';
import 'package:flutter_quesfity/Paginas/pagina_criarcategoria.dart';

class PaginaConquistas extends StatefulWidget {
  const PaginaConquistas({super.key});

  @override
  State<StatefulWidget> createState() {
    return PaginaConquistasState();
  }
}

class PaginaConquistasState extends State<PaginaConquistas> {
  List<Categoria> listaDeCategorias = [
    Categoria(titulo: "Sistema", icone: Icons.emoji_events),
  ];
  @override
  Widget build(BuildContext context) {
    //double Largura = MediaQuery.of(context).size.width;
    //double Altura = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: ListView(
            padding: EdgeInsets.zero,
            children: listaDeCategorias.map((conquistas) {
              return Column(
                children: [
                  ComponenteCategoria(
                    nomeLista: conquistas.titulo,
                    iconeLista: conquistas.icone,
                    id: conquistas.id,
                  ),
                ],
              );
            }).toList()),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(12),
        child: FloatingActionButton(
          heroTag: "btn2",
          elevation: 5,
          backgroundColor:
              Theme.of(context).floatingActionButtonTheme.backgroundColor,
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
          onPressed: () async {
            final resultadoCriacao = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaginaCriarListaConquista(
                    listaDeCategorias: listaDeCategorias),
              ),
            );

            if (resultadoCriacao != null) {
              // se a criação foi bem-sucedida
              setState(() {
                listaDeCategorias = resultadoCriacao; // Atualiza a lista
              });
            }
          },
        ),
      ),
    );
  }
}
*/