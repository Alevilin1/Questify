import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Classes/dark_theme.dart';
import 'package:flutter_quesfity/Classes/user.dart';
import 'package:flutter_quesfity/Paginas/pagina_filtros.dart';
import 'package:flutter_quesfity/Servi%C3%A7os/autentificacao_servico.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PaginaConfiguracoes extends StatefulWidget {
  final User user;
  const PaginaConfiguracoes({required this.user, super.key});

  @override
  State<PaginaConfiguracoes> createState() => _PaginaConfiguracoesState();
}

class _PaginaConfiguracoesState extends State<PaginaConfiguracoes> {
  @override
  Widget build(BuildContext context) {
    var dark = Provider.of<IsDark>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text("Configurações"),
        ),
        body: Container(
          color: Theme.of(context).primaryColor,
          child: Column(
            children: [
              SwitchListTile(
                activeColor: Colors.grey,
                secondary: const Icon(Icons.light_mode),
                title: const Text("Modo escuro"),
                value: dark.isDarkTheme,
                onChanged: (value) {
                  dark.changeTheme();
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text("Editar filtros"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PaginaListas(user: widget.user)));
                },
              ),
              ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Deslogar"),
                  onTap: () async {
                    await AutentificacaoServico().deslogarUsuario();
                  }),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("Excluir conta"),
                onTap: () async {
                  //await AutentificacaoServico().deletarConta();
                  dialogExcluir(context);
                },
              )
            ],
          ),
        ));
  }

  Future<dynamic> dialogExcluir(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Deseja realmente excluir sua conta?",
                  style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ))),
              actions: [
                TextButton(
                  child: Text(
                    "Cancelar",
                    style: GoogleFonts.poppins(
                        color: Colors.black, fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text(
                    "Excluir",
                    style: GoogleFonts.poppins(
                        color: Colors.red, fontWeight: FontWeight.w600),
                  ),
                  onPressed: () async {
                    await AutentificacaoServico().deletarConta();
                    Navigator.pop(context);
                  },
                ),
              ],
            ));
  }
}
