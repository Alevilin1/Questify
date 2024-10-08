import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Servi%C3%A7os/autentificacao_servico.dart';



class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1E1E1E),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            color: const Color(0xFF1E1E1E),
            child: const Text(
              "Menu",
              style: TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Deslogar"),
            onTap: () {
              AutentificacaoServico().deslogarUsuario();
            },
          ),
        ],
      ),
    );
  }
}
