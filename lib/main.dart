import 'package:capped_progress_indicator/capped_progress_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Modelos/user.dart';
import 'package:flutter_quesfity/firebase_options.dart';
import 'package:intl/intl.dart';
import 'CriarTarefa.dart';
import 'Modelos/tarefas.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Inicializando o Firebase
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF121212),
        secondaryHeaderColor: const Color(0xFF222222),
      ),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  int _selectedIndex = 0;
  bool? confirmacaoTarefa = false;
  User user = User(id: "");
  List<Tarefas> listaDeTarefas = [];

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
      // Aqui você pode adicionar lógica para navegação entre páginas.
    });
  }

  @override
  void initState() {
    super.initState();
    _carregarUsuario(); // Carregando o usuário
    _carregarTarefas(); // Carregando tarefas
  }

  Future<void> _carregarTarefas() async { // Carregando tarefas
    String userId = "teste_uid"; // ID do usuário por enquanto é isso

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('tarefas')
        .get();

    setState(() {
      listaDeTarefas = snapshot.docs.map((doc) {
        List<dynamic> atributosList = doc['atributos'];
        List<bool> atributos = atributosList.map((e) => e as bool).toList();
        return Tarefas(
          id: doc.id,
          titulo: doc['titulo'],
          descricao: doc['descricao'],
          tarefaConcluida: doc['tarefaConcluida'],
          xp: doc['xp'],
          atributos: atributos,
        );
      }).toList();
    });
  }

  Future<void> _carregarUsuario() async { // Carregando o usuário
    String userId = "teste_uid";
    User? usuarioCarregado = await User.carregar(userId);
    if (usuarioCarregado != null) {
      user = usuarioCarregado;
    } else {
      user = User(id: userId);
      await user.salvar();
    }
    setState(() {}); // Atualiza a interface
  }

  void concluirTarefa(Tarefas tarefa) async {
    await tarefa.deletarTarefa(user.id, tarefa);

    setState(() {
      tarefa.tarefaConcluida = true;
      listaDeTarefas.remove(tarefa);

      // Adicionando XP
      user.xp += tarefa.xp;

      if (tarefa.atributos[0]) {
        user.xpAtributos['forca'] += tarefa.xp / 2;
      }
      if (tarefa.atributos[1]) {
        user.xpAtributos['inteligencia'] += tarefa.xp / 2;
      }
      if (tarefa.atributos[2]) {
        user.xpAtributos['destreza'] += tarefa.xp / 2;
      }

      while (user.xp >= user.xpNivel()) {
        user.xp -= user.xpNivel();
        user.nivel++;
      }

      user.salvar(); // Salva o XP e o nível do usuário
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000000),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu),
        ),
        title: const Text(
          "Todos",
          style: TextStyle(fontFamily: 'PlusJakartaSans'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'Seu nivel é: ${user.nivel}',
                style: const TextStyle(
                    fontSize: 15, fontFamily: 'PlusJakartaSans'),
              ),
            ),
            LinearCappedProgressIndicator(
              minHeight: 10,
              color: const Color(0xFFFFFFFF),
              backgroundColor: const Color(0xFFCCCCCC),
              value: user.progressao(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                DateFormat.MMMMEEEEd().format(DateTime.now()),
                style: const TextStyle(fontFamily: 'PlusJakartaSans'),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                FilterChip(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  label: const Text(
                    'Todos',
                    style: TextStyle(fontFamily: 'PlusJakartaSans'),
                  ),
                  onSelected: null,
                ),
                const SizedBox(width: 8),
                FilterChip(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  label: const Text(
                    'Pessoal',
                    style: TextStyle(fontFamily: 'PlusJakartaSans'),
                  ),
                  onSelected: null,
                ),
                const SizedBox(width: 8),
                FilterChip(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  label: const Text(
                    'Trabalho',
                    style: TextStyle(fontFamily: 'PlusJakartaSans'),
                  ),
                  onSelected: null,
                ),
                const SizedBox(width: 8),
                FilterChip(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  label: const Text(
                    'Estudo',
                    style: TextStyle(fontFamily: 'PlusJakartaSans'),
                  ),
                  onSelected: null,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Scaffold(
                floatingActionButton: FloatingActionButton(
                  elevation: 5,
                  shape: const CircleBorder(),
                  backgroundColor: Colors.white,
                  child: const Icon(Icons.add, color: Colors.black),
                  onPressed: () async {
                    final resultado = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CriarTarefa(
                          listaDeTarefas: List.from(listaDeTarefas),
                        ),
                      ),
                    );
                    if (resultado != null) {
                      setState(() {
                        listaDeTarefas = resultado;
                      });
                    }
                  },
                ),
                backgroundColor: Colors.black,
                body: ListView(
                  children: listaDeTarefas.map((Tarefa) {
                    return Card(
                      child: CheckboxListTile(
                        title: Text(Tarefa.titulo),
                        subtitle: Tarefa.descricao != ""
                            ? Text(
                                Tarefa.descricao,
                                maxLines: 1,
                              )
                            : null,
                        secondary: Text(
                          "${Tarefa.xp} XP",
                          style: const TextStyle(fontSize: 13),
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: Colors.green,
                        value: Tarefa.tarefaConcluida,
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              Tarefa.tarefaConcluida = value;
                              concluirTarefa(Tarefa);
                            });
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const Divider(),
            NavigationBar(
              backgroundColor: Colors.black,
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.task),
                  label: 'Tarefas',
                ),
                NavigationDestination(
                  icon: Icon(Icons.trending_up_rounded),
                  label: 'Status',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person),
                  label: 'Perfil',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}




/*

import 'package:capped_progress_indicator/capped_progress_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Modelos/user.dart';
import 'package:flutter_quesfity/ListaTarefa.dart';
import 'package:flutter_quesfity/firebase_options.dart';
import 'package:intl/intl.dart';
import 'CriarTarefa.dart';
import 'Modelos/tarefas.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options:
          DefaultFirebaseOptions.currentPlatform); // Inicializando o firebase
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            brightness: Brightness.dark,
            primaryColor: const Color(0xFF121212),
            secondaryHeaderColor: const Color(0xFF222222)),
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
  int _selectedIndex = 0;
  bool? confirmacaoTarefa = false;
  User user = User(id: "");
  List<Tarefas> listaDeTarefas = [];

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
      // Aqui você pode adicionar lógica para navegação entre páginas.
    });
  }

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
        List<dynamic> atributosList = doc[
            'atributos']; //Pegando os atributos da tarefa e transformando em uma lista de dynamic
        List<bool> atributos = atributosList
            .map((e) => e as bool)
            .toList(); //Pegando os atributos da tarefa e transformando em uma lista de bool
        return Tarefas(
          id: doc.id, //Pegando o id da tarefa
          titulo: doc['titulo'],
          descricao: doc['descricao'],
          tarefaConcluida: doc['tarefaConcluida'],
          xp: doc['xp'],
          atributos: atributos, //Pegando os atributos da tarefa
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
    setState(() {}); //Atualiza a interface
  }

  void concluirTarefa(Tarefas tarefa) async {
    //Depois de concluir uma tarefa, ela é deletada do banco de dadoss
    await tarefa.deletarTarefa(user.id, tarefa);

    //await _carregarTarefas();

    setState(() {
      //Removendo a tarefa
      tarefa.tarefaConcluida = true;

      //Removendo da lista
      listaDeTarefas.remove(tarefa);

      //Adicionando XP
      user.xp += tarefa.xp;

      if (tarefa.atributos[0] == true) {
        user.xpAtributos['forca'] += tarefa.xp / 2;
      }

      if (tarefa.atributos[1] == true) {
        user.xpAtributos['inteligencia'] += tarefa.xp / 2;
      }

      if (tarefa.atributos[2] == true) {
        user.xpAtributos['destreza'] += tarefa.xp / 2;
      }

      //Enquanto o meu xp for maior que o necessario para subir de nivel
      while (user.xp >= user.xpNivel()) {
        user.xp -= user.xpNivel();
        user.nivel++;

        /*Debug
        print("Seu nivel é ${user.nivel}");
        print("Seu XP é ${user.xp}");
        */
      }

      //Depois de concluir uma tarefa ou subir de nivel, precisa ser salvo o xp do usuario
      user.salvar();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF000000),
        appBar: AppBar(
          backgroundColor: Color(0xFF000000),
          leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
          title: const Text("Todos",
              style: TextStyle(fontFamily: 'PlusJakartaSans')),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Seu nivel é: ${user.nivel}',
                  style: TextStyle(fontSize: 15, fontFamily: 'PlusJakartaSans'),
                ),
              ),
              LinearCappedProgressIndicator(
                minHeight: 10,
                color: Color(0xFFFFFFFF),
                backgroundColor: Color(0xFFCCCCCC),
                value: user.progressao(), //A barra de progressão vai de 0 a 1
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(DateFormat.MMMMEEEEd().format(DateTime.now()),
                    style: TextStyle(fontFamily: 'PlusJakartaSans')),
              ),
              const SizedBox(
                height: 24,
              ),
              Row(
                children: [
                  FilterChip(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      label: const Text('Todos',
                          style: TextStyle(fontFamily: 'PlusJakartaSans')),
                      onSelected: null),
                  const SizedBox(
                    width: 8,
                  ),
                  FilterChip(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      label: const Text(
                        'Pessoal',
                        style: TextStyle(fontFamily: 'PlusJakartaSans'),
                      ),
                      onSelected: null),
                  const SizedBox(
                    width: 8,
                  ),
                  FilterChip(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      label: const Text('Trabalho',
                          style: TextStyle(fontFamily: 'PlusJakartaSans')),
                      onSelected: null),
                  const SizedBox(
                    width: 8,
                  ),
                  FilterChip(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      label: const Text('Estudo',
                          style: TextStyle(fontFamily: 'PlusJakartaSans')),
                      onSelected: null),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              Expanded(
                child: Scaffold(
                        floatingActionButton: FloatingActionButton(
                        elevation: 5,
                        shape: const CircleBorder(),
                        backgroundColor: Colors.white,
                        child: const Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                        onPressed: () async {
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
                        }),
                        backgroundColor: Colors.black,
                        body: ListView(
                          children: listaDeTarefas.map((Tarefa) {
                            return Card(
                  child: CheckboxListTile(
                title: Text(Tarefa.titulo),
                subtitle: Tarefa.descricao != ""
                    ? Text(
                        Tarefa.descricao,
                        maxLines: 1,
                      )
                    : null,
                secondary: Text(
                  "${Tarefa.xp} XP",
                  style: TextStyle(fontSize: 13),
                ),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: Colors.green,
                value:
                    Tarefa.tarefaConcluida, //Verifica se a tarefa foi concluída
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      Tarefa.tarefaConcluida = value;
                      concluirTarefa(Tarefa);
                    });
                  }
                },
                            ));
                          }).toList(),
                        )),
              ),
              const Divider(),
              NavigationBar(backgroundColor: Colors.black, destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.task),
                  label: 'Tarefas',
                ),
                NavigationDestination(
                  icon: Icon(Icons.trending_up_rounded),
                  label: 'Status',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person),
                  label: 'Perfil',
                ),
              ])
            ],
          ),
        ));
  }
}


*/

