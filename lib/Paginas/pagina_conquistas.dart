import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Modelos/conquista.dart';

class PaginaConquistas extends StatefulWidget {
  final List<Conquista> listaDeConquistas; // Lista de conquistas parametro
  const PaginaConquistas({super.key, required this.listaDeConquistas});

  @override
  State<PaginaConquistas> createState() => _PaginaConquistasState();
}

class _PaginaConquistasState extends State<PaginaConquistas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: widget.listaDeConquistas.length, // Quantidade de conquistas
        itemBuilder: (context, index) { // Itera sobre as conquistas
          final conquista = widget.listaDeConquistas[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  gradient: LinearGradient(
                    // Gradiente de cores para as conquistas
                    colors: conquista.desbloqueado
                        ? [Colors.green.shade800, Colors.green.shade700]
                        : [Colors.grey.shade800, Colors.grey.shade700],
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container( // Icone da conquista
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: conquista.desbloqueado
                          ? Colors.green.shade300.withOpacity(0.3) // Cor do icone da conquista desbloqueada
                          : Colors.grey.shade600.withOpacity(0.3), // Cor do icone da conquista bloqueada
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      conquista.icone,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    conquista.nome,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      conquista.descricao,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14,
                      ),
                    ),
                  ),
                  trailing: Icon(
                    conquista.desbloqueado ? Icons.emoji_events : Icons.lock,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
