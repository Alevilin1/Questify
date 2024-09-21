import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Servi%C3%A7os/AutenticacaoServico.dart';
import 'package:flutter_quesfity/main.dart';



class SideBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color(0xFF1E1E1E),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            color: Color(0xFF1E1E1E),
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
