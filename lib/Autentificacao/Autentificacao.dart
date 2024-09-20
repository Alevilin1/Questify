import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Autentificacao/Widgets/ConfirmarSenhaField.dart';
import 'package:flutter_quesfity/Autentificacao/Widgets/EmailField.dart';
import 'package:flutter_quesfity/Autentificacao/Widgets/NomeField.dart';
import 'package:flutter_quesfity/Autentificacao/Widgets/SenhaField.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  bool queroEntrar = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        centerTitle: true,
        title: Text(queroEntrar ? "Entrar" : "Registrar"),
      ),
      body: Form(
        child: ListView(
          shrinkWrap: true, //true para que o ListView tenha altura definida
          padding: const EdgeInsets.all(24),
          children: [
            Visibility(visible: !queroEntrar, child: NomeField(),),
            const SizedBox(
              height: 24,
            ),
            Emailfield(),
            const SizedBox(
              height: 24,
            ),
            SenhaField(),
            const SizedBox(
              height: 24,
            ),
            Visibility(
              visible: !queroEntrar,
              child: SenhaConfirmarField(),
            ),
            const SizedBox(
              height: 24,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/principal');
              },
              child: Text(queroEntrar ? 'Entrar' : 'Registrar'),
            ),
            const SizedBox(
              height: 24,
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  queroEntrar = !queroEntrar;
                });
              },
              child: Text(queroEntrar
                  ? "Não tem uma conta? Clique aqui!"
                  : "Já tem uma conta? Clique aqui"),
            )
          ],
        ),
      ),
    );
  }
}
