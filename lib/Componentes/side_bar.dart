import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Classes/dark_theme.dart';
import 'package:flutter_quesfity/Servi%C3%A7os/autentificacao_servico.dart';
import 'package:provider/provider.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    var dark = Provider.of<IsDark>(context);
    return Drawer(
      backgroundColor: Theme.of(context).drawerTheme.backgroundColor,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            color: Theme.of(context).drawerTheme.backgroundColor,
            child: const Text(
              "Menu",
              style: TextStyle(fontSize: 24),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            leading: const Icon(Icons.light_mode),
            title: const Text("Modo escuro"),
            trailing: Switch(
                activeColor: Colors.grey,
                value: dark.isDarkTheme,
                onChanged: (value) {
                  dark.changeTheme();
                }),
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
