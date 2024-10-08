import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Serviços/autentificacao_servico.dart';
import 'package:flutter_quesfity/main.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final AutentificacaoServico _authServico = AutentificacaoServico();
  TextEditingController senhaControler = TextEditingController();
  TextEditingController emailControler = TextEditingController();
  TextEditingController nomeControler = TextEditingController();
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
        key: _formKey,
        child: ListView(
          shrinkWrap: true, //true para que o ListView tenha altura definida
          padding: const EdgeInsets.all(24),
          children: [
            Visibility(
              visible: !queroEntrar,
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nome',
                ),
                controller: nomeControler,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite seu nome';
                  }

                  if (value.length < 3) {
                    return 'Por favor, digite um nome maior';
                  }

                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            TextFormField(
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Email'),
              controller: emailControler,
              validator: (value) {
                //Validação do email
                if (value == null || value.isEmpty) {
                  return 'Por favor, digite seu email';
                }

                if (!value.contains('@') || !value.contains('.')) {
                  return 'Por favor, digite um email valido';
                }

                if (value.length < 6) {
                  return 'Por favor, digite um email valido';
                }

                return null;
              },
            ),
            const SizedBox(
              height: 24,
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Senha',
              ),
              controller: senhaControler,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, digite sua senha';
                }

                if (value.length < 6) {
                  return 'Por favor, digite uma senha maior';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 24,
            ),
            Visibility(
              visible: !queroEntrar,
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirmar Senha',
                ),
                validator: (value) {
                  if (value != senhaControler.text) {
                    return 'As senhas devem ser iguais';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            ElevatedButton(
              onPressed: () {
                botaoPrincipal();
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
                  ? "Não tem uma conta? Clique aqui"
                  : "Já tem uma conta? Clique aqui"),
            )
          ],
        ),
      ),
    );
  }

  botaoPrincipal() {
    if (_formKey.currentState!.validate()) {
      if (queroEntrar) {
        _authServico.loginUsuario(
            email: emailControler.text, senha: senhaControler.text);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const RoteadorTela()));
      } else {
        _authServico.cadastrarUsuario(
            email: emailControler.text,
            senha: senhaControler.text,
            nome: nomeControler.text);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const RoteadorTela()));
      }
    }
  }
}
