import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quesfity/barrausuario.dart';
import 'package:flutter_quesfity/Modelos/user.dart';
import 'Modelos/tarefas.dart';
import 'package:firebase_core/firebase_core.dart';
import 'criartarefas.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            brightness: Brightness.dark,
            primaryColorDark: const Color(0xFF1D1B1B),
            secondaryHeaderColor: const Color(0xFF322F35)),
        home: const Home());
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<Home> {
  bool? confirmacaoTarefa = false;
  User user = User(id: "");
  List<Tarefas> listaDeTarefas = [];

  @override
  void initState() {
    super.initState();
    _carregarUsuario(); //Carregando usuario
    _carregarTarefas(); //Carregando tarefas
  }

  Future<void> _carregarTarefas() async {
    String userId = "teste_uid"; // ID do usuário

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('tarefas')
        .get();

    setState(() {
      listaDeTarefas = snapshot.docs.map((doc) {
        return Tarefas(
          id: doc.id, //Pegando o id da tarefa 
          titulo: doc['titulo'],
          descricao: doc['descricao'],
          dificuldade: doc['dificuldade'],
          tarefaConcluida: doc['tarefaConcluida'],
        );
      }).toList();
    });
  }

  Future<void> _carregarUsuario() async {
    //Por enquando o uid é isso aqui
    String userId = "teste_uid";
    User? usuarioCarregado = await User.carregar(userId);
    if (usuarioCarregado != null) {
      user = usuarioCarregado;
    } else {
      user = User(
          id: userId); // Cria um novo usuário se ele não existir no banco de dados
      await user.salvar();
    }
    setState(() {});
  }

  void concluirTarefa(Tarefas tarefa) async {
    setState(() {
      //Removendo a tarefa
      tarefa.tarefaConcluida = true;
      listaDeTarefas.remove(tarefa);

      //Incrementando xp
      if (tarefa.dificuldade == 1) {
        user.xp += 10;
      } else if (tarefa.dificuldade == 2) {
        user.xp += 20;
      } else if (tarefa.dificuldade == 3) {
        user.xp += 30;
      }

      //Enquanto o meu xp for maior que o necessario para subir de nivel
      while (user.xp >= user.xpNivel()) {
        user.xp -= user.xpNivel();
        user.nivel++;

        //Debug
        print("Seu nivel é ${user.nivel}");
        print("Seu XP é ${user.xp}");
      }

      //Depois de concluir uma tarefa ou subir de nivel, precisa ser salvo o xp do usuario
      user.salvar();
    });

    
    //Depois de concluir uma tarefa, ela é deletada do banco de dadoss
    await tarefa.deletarTarefa(user.id, tarefa);
    
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
          title: const Text("ARAS"),
        ),
        body: Column(
          children: [
            BarraUsuario(
              user: user,
            ),
            Column(
              children: listaDeTarefas.map((tarefa) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                      child: Row(
                    children: [
                      Checkbox(
                          value: tarefa.tarefaConcluida,
                          onChanged: (value) {
                            concluirTarefa(tarefa);
                          }),
                      Text(tarefa.titulo), Text(tarefa.id)
                    ],
                  )),
                );
              }).toList(),
            ),
            FloatingActionButton(
                child: const Icon(Icons.add),
                heroTag: "CriarTarefa",
                onPressed: () async {
                  // Espera o resultado da pagina criartarefas
                  final resultado = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CriarTarefa(
                              listaDeTarefas: List.from(listaDeTarefas),
                            )),
                  );

                  if (resultado != null) {
                    setState(() {
                      listaDeTarefas = resultado;
                    });
                  }
                })
          ],
        ));
  }
}
