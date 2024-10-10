import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Modelos/user.dart';

class PaginaListas extends StatefulWidget {
  final Usuario user;
  const PaginaListas({super.key, required this.user});

  @override
  State<PaginaListas> createState() => PaginaListasState();
}

class PaginaListasState extends State<PaginaListas> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Filtros",
          style: TextStyle(fontFamily: 'PlusJakartaSans'),
        ),
      ),
      body: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.user.filtros.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(widget.user.filtros[index]),
                trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        widget.user.filtros
                            .removeAt(index); // Remove o filtro da lista

                        widget.user
                            .atualizarFiltro(); //Remove o filtro do banco de dados

                        Navigator.pop(context, widget.user);
                      });
                    },
                    icon: const Icon(Icons.delete)),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).primaryColor,
          child: Row(children: [
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Adicionar filtro',
                ),
                controller: controller,
              ),
            ),
            IconButton(
              onPressed: () {
                widget.user.filtros
                    .add(controller.text); // Adiciona o filtro na lista

                widget.user.atualizarFiltro(); // Atualiza o banco de dados

                Navigator.pop(
                    context, widget.user); // Retorna para a pagina anterior
              },
              icon: const Icon(Icons.send, size: 30),
            ),
          ])),
    );
  }
}
