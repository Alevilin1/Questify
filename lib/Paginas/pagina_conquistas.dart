import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Classes/conquista.dart';
import 'package:google_fonts/google_fonts.dart';

class PaginaConquistas extends StatefulWidget {
  final List<Conquista> listaDeConquistas; // Lista de conquistas parametro
  const PaginaConquistas({super.key, required this.listaDeConquistas});

  @override
  State<PaginaConquistas> createState() => _PaginaConquistasState();
}

class _PaginaConquistasState extends State<PaginaConquistas> {
  /*late List<Conquista> conquistasDesbloqueadas;
  late List<Conquista> conquistasBloqueadas;


  @override
  void initState() {
    super.initState();
    filtrarConquistasDesbloqueadas();
    filtrarConquistasBloqueadas();
  }

     void filtrarConquistasBloqueadas() {
    conquistasBloqueadas = widget.listaDeConquistas
        .where((conquista) => !conquista.desbloqueado)
        .toList();
    }
  */
  Set<int> filtragem = {0};
  List<Conquista> filtrarConquistas() {
    if (filtragem.contains(0)) return widget.listaDeConquistas;

    if (filtragem.contains(1)) {
      return widget.listaDeConquistas
          .where((conquista) => !conquista.desbloqueado)
          .toList();
    }

    if (filtragem.contains(2)) {
      return widget.listaDeConquistas
          .where((conquista) => conquista.desbloqueado)
          .toList();
    }

    return widget.listaDeConquistas;
  }

  @override
  Widget build(BuildContext context) {
    final conquistasDesbloqueadas = filtrarConquistas();

    widget.listaDeConquistas.sort((a, b) {
      if (a.desbloqueado && !b.desbloqueado) {
        return -1; // Se conquista A estiver desbloqueada e B estiver bloqueada retorna -1
      }
      if (!a.desbloqueado && b.desbloqueado) {
        return 1; // Se conquista B estiver desbloqueada e A estiver bloqueada retorna 1
      }
      return 0; // Se as duas conquistas estiverem bloqueadas ou desbloqueadas, não faz nada
    });
    // Organiza as conquistas por desbloqueio
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        surfaceTintColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text("Conquistas",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            )),
      ),
      body: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              child: SegmentedButton(
                  multiSelectionEnabled: false,
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(
                      label: Text(
                        'Todas',
                        style: TextStyle(
                          fontSize: 12.5,
                        ),
                      ),
                      value: 0,
                    ),
                    ButtonSegment(
                      label: Text('Bloqueadas',
                          style: TextStyle(
                            fontSize: 12.5,
                          )),
                      value: 1,
                    ),
                    ButtonSegment(
                      label: Text(
                        'Desbloqueadas',
                        style: TextStyle(
                          fontSize: 12.5,
                        ),
                      ),
                      value: 2,
                    ),
                  ],
                  selected: filtragem,
                  onSelectionChanged: (values) {
                    setState(() {
                      filtragem = values;
                    });
                  }),
            )
          ]),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount:
                  conquistasDesbloqueadas.length, // Quantidade de conquistas
              itemBuilder: (context, index) {
                // Itera sobre as conquistas
                final conquista = conquistasDesbloqueadas[index];
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
                        leading: Container(
                          // Icone da conquista
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: conquista.desbloqueado
                                ? Colors.green.shade300.withOpacity(
                                    0.3) // Cor do icone da conquista desbloqueada
                                : Colors.grey.shade600.withOpacity(
                                    0.3), // Cor do icone da conquista bloqueada
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
                          conquista.desbloqueado
                              ? Icons.emoji_events
                              : Icons.lock,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
