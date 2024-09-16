import 'package:flutter/material.dart';

class InfoAtributos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600,
      child: Column(
        children: [
          Card(
            margin: EdgeInsets.all(5),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.center, //Para deixar a imagem no centro
                children: [
                  SizedBox(
                    height: 30,
                    child: Image.asset('lib/Icones/forca.png'),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Força',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(
                            height: 4), // Espaçamento entre o título e o texto
                        Text(
                          "Atividades que ajudam a aprimorar sua saúde e condicionamento físico",
                          softWrap:
                              true, // Permite a quebra automática de linha
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.all(5),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                    child: Image.asset('lib/Icones/inteligencia.png'),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Inteligência',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Atividades que estimulam a mente e o raciocínio, como resolver problemas lógicos ou jogar xadrez.",
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.all(5),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 30,
                    child: Image.asset('lib/Icones/carisma.png'),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Carisma',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Atividades que promovem a melhoria da atratividade, como participar de eventos sociais e desenvolver habilidades de comunicação eficazes.",
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Fechar"))
        ],
      ),
    );
  }
}
