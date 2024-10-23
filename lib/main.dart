import 'dart:async';
import 'package:achievement_view/achievement_view.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quesfity/Autentificacao/autentificacao.dart';
import 'package:flutter_quesfity/Modelos/conquista.dart';
import 'package:flutter_quesfity/Paginas/pagina_conquistas.dart';
import 'package:flutter_quesfity/Paginas/pagina_filtros.dart';
import 'package:flutter_quesfity/Componentes/side_bar.dart';
import 'package:flutter_quesfity/Modelos/user.dart';
import 'package:flutter_quesfity/Paginas/pagina_tarefas.dart';
import 'package:flutter_quesfity/Paginas/pagina_status.dart';
import 'package:flutter_quesfity/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:intl/intl.dart';
//import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Inicializando o Firebase

  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});
  final bool isDarkTheme = true;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          //statusBarColor: Color.fromARGB(255, 210, 190, 230), // Cor da barra de status
          statusBarIconBrightness: Brightness.light, // Ícones claros
          systemNavigationBarColor: Color(0xFF1E1E1E)),
    );

    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFFF7F7F7),
        fontFamily: 'PlusJakartaSans',
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
        textTheme: Theme.of(context).textTheme.apply(
              fontFamily: 'PlusJakartaSans',
              bodyColor: Colors.black,
            ),
        sliderTheme: const SliderThemeData(
          activeTrackColor: Colors.black,
          inactiveTickMarkColor: Colors.grey,
          thumbColor: Colors.grey,
        ),
        secondaryHeaderColor: Colors.grey[200],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        cardColor: Colors.white,
      ),
      darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: const Color.fromARGB(255, 24, 23,
              23), //const Color(0xFF000000) const Color.fromARGB(255, 24, 23, 23)
          secondaryHeaderColor: const Color(0xFF1E1E1E),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          sliderTheme: const SliderThemeData(
            activeTrackColor: Colors.white,
            inactiveTickMarkColor: Colors.white24,
            thumbColor: Colors.white,
          ),
          textTheme: Theme.of(context)
              .textTheme
              .apply(fontFamily: 'PlusJakartaSans', bodyColor: Colors.white),
          cardColor: const Color(0xFF1E1E1E),
          navigationBarTheme: const NavigationBarThemeData(
            backgroundColor: Color(0xFF323335),
          )),
      themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      home: const RoteadorTela(),
    );
  }
}

class RoteadorTela extends StatelessWidget {
  const RoteadorTela({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: firebase_auth.FirebaseAuth.instance.userChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const Home();
          } else {
            return const Login();
          }
        });
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  int _selectedIndex = 0;
  Usuario user = Usuario(id: "");
  bool isloading = true;
  AudioPlayer audioPlayer = AudioPlayer();
  bool estaMostrandoConquista = false;

  //List<Conquista> listaDeConquistasDesbloqueadas = [];
  List<Conquista> listaDeConquistas = [
    Conquista(
      nome: "Iniciante",
      descricao: "Conclua sua primeira tarefa",
      idFuncao: "funcao1",
      quantidadeDesbloqueio: 1,
      desbloqueado: false,
      icone: Icons.emoji_events,
    ),  
    Conquista(
      nome: "Iniciante Produtivo",
      descricao: "Complete 5 tarefas",
      idFuncao: "funcao1",
      quantidadeDesbloqueio: 5,
      desbloqueado: false,
      icone: Icons.emoji_events,
    ),
    Conquista(
      nome: "Produtividade em alta",
      descricao: "Complete 20 tarefas",
      idFuncao: "funcao1",
      quantidadeDesbloqueio: 20,
      desbloqueado: false,
      icone: Icons.emoji_events,
    ),
    Conquista(
      nome: "Aprendiz",
      descricao: "Atinga o nivel 5",
      idFuncao: "funcao2",
      quantidadeDesbloqueio: 5,
      desbloqueado: false,
      icone: Icons.emoji_events,
    ),
  ];

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index; // Atualiza o index
      //print(_selectedIndex);
    });
  }

  Future<void> _carregarUsuario() async {
    final firebaseUser = firebase_auth
        .FirebaseAuth.instance.currentUser; // Usando o uid do Firebase Auth

    if (firebaseUser != null) {
      // Usando o uid do Firebase Auth
      String userId = firebaseUser.uid;
      Usuario? usuarioCarregado =
          await Usuario.carregar(userId); // Carregando o usuário

      if (usuarioCarregado != null) {
        // Se o usuário foi carregado
        // Caso o usuário tenha sido carregado
        user = usuarioCarregado; // Usando o usuário carregado
      } else {
        // Caso o usuário não tenha sido carregado
        user = Usuario(id: userId); // Cria um novo usuário
        await user.salvar(); // Cria o usuário
        await user.salvarConquistas(listaDeConquistas); // Cria as conquistas
      }

      setState(() {
        isloading = false;
      }); // Atualiza a interface
    } else {
      //print("Nenhum usuário autenticado.");
      isloading = false;
    }
  }

  Future<void> _carregarConquistas() async {
    final firebaseUser = firebase_auth
        .FirebaseAuth.instance.currentUser; // Usando o uid do Firebase Auth

    if (firebaseUser != null) {
      String userId = firebaseUser.uid; // Usando o uid do usuário autenticado

      QuerySnapshot snapshot =
          await FirebaseFirestore.instance // Busca as conquistas do usuário
              .collection('users')
              .doc(userId)
              .collection('conquistas')
              .orderBy('createdAt', descending: false)
              .get();

      if (snapshot.docs.isNotEmpty) {
        // Se o usuário tem conquistas, carrega as conquistas
        setState(() {
          listaDeConquistas = snapshot.docs.map((doc) {
            int codePoints = doc['icone'];
            return Conquista(
              nome: doc['nome'],
              descricao: doc['descricao'],
              idFuncao: doc['idFuncao'],
              desbloqueado: doc['desbloqueado'],
              id: doc.id,
              quantidadeDesbloqueio: doc['quantidadeDesbloqueio'],
              icone: IconData(codePoints, fontFamily: 'MaterialIcons'),
            );
          }).toList();
        });
      } else {}
    }
  }

  void navegarParaPaginaListas() async {
    // Navega para a pagina de listas
    final updatedUser = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaginaListas(user: user),
      ),
    );

    if (updatedUser != null) {
      // Caso o usuário tenha sido atualizado
      setState(() {
        user = updatedUser; // Atualiza o usuário
      });
    }
  }

  void show(Conquista conquista) async {
    
    while (estaMostrandoConquista) {
      // Enquanto estiver mostrando uma conquista
      await Future.delayed(const Duration(milliseconds: 500)); // Aguarde para mostrar outra conquista, se tiver
    }

    estaMostrandoConquista = true; // Define que a conquista está sendo mostrada

    //Tocando o som de desbloqueio
    audioPlayer.play(AssetSource('mixkit-software-interface-start-2574.wav'));

    // Exibe o desbloqueio da conquista na interface
    AchievementView(
      color: Theme.of(context).cardColor,
      textStyleTitle: TextStyle(
        color: Theme.of(context).textTheme.bodyLarge!.color,
      ),
      textStyleSubTitle: TextStyle(
        color: Theme.of(context).textTheme.bodyLarge!.color,
      ),
      alignment: const AlignmentDirectional(0, 0.8),
      elevation: 5,
      isCircle: true,
      icon: const FaIcon(
        FontAwesomeIcons.trophy,
        color: Colors.green,
      ),
      title: conquista.nome,
      subTitle: conquista.descricao,
    ).show(context);

    Future.delayed(const Duration(seconds: 6), () {
      //Espera acabar o desbloqueio
      estaMostrandoConquista = false; // Define que a conquista não está sendo mostrada para mostrar a outra conquista
    });

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _carregarUsuario(); // Carregando o usuário
    _carregarConquistas(); // Carregando as conquistas
  }

  @override
  Widget build(BuildContext context) {
    Map<String, Function(Conquista conquista)> funcoesConquista = {
      // Funções das conquistas
      'funcao1': (Conquista conquista) {
        if (user.tarefasConcluidas >= conquista.quantidadeDesbloqueio &&
            !conquista.desbloqueado) {
          conquista.desbloqueado =
              true; // Define o campo "desbloqueado" como true na lista

          //print("O ID é " + conquista.id); Debug

          conquista.atualizarConquista(user.id, conquista.id,
              true); // Atualiza o campo "desbloqueado" no firebase

          Future.delayed(const Duration(seconds: 1),
              () => show(conquista)); // Exibe a conquista
        }
      },
      'funcao2': (Conquista conquista) {
        if (user.nivel >= conquista.quantidadeDesbloqueio &&
            !conquista.desbloqueado) {
          conquista.desbloqueado = true;

          conquista.atualizarConquista(user.id, conquista.id,
              true); // Atualiza o campo "desbloqueado" no firebase

          Future.delayed(const Duration(seconds: 1),
              () => show(conquista)); // Exibe a conquista
        }
      },
    };

    void executarFuncaoConquista(Conquista conquista) {
      // Executa as funções das conquistas
      if (conquista.desbloqueado) return;

      String idFuncao = conquista.idFuncao; // ID da função da conquista

      if (funcoesConquista.containsKey(idFuncao)) {
        // Verifica se a chave da conquista existe no Map
        // Executa a função da chave associada à conquista
        funcoesConquista[idFuncao]!(conquista);
      } else {
        // print("Função não encontrada para a conquista: ${conquista.nome}"); // Caso não exista, imprime uma mensagem de erro
      }
    }

    // Cria um temporizador para executar a função a cada 1 segundo
    Timer.periodic(const Duration(seconds: 1), (_) {
      // Iterando a lista de conquistas
      for (var conquista in listaDeConquistas) {
        executarFuncaoConquista(
            conquista); // passando as conquistas para a função
      }
    });

    final List<Widget> paginas = <Widget>[
      PrimeiraPagina(
        user: user,
      ),
      StatusPagina(
        user: user,
      ),
      PaginaConquistas(listaDeConquistas: listaDeConquistas)
      //TestePagina(user: user, conquistas: listaDeConquistas)
    ];

    return isloading
        ? Container(
            alignment: Alignment.center,
            color: Theme.of(context).primaryColor,
            child: const CircularProgressIndicator())
        : Scaffold(
            drawer: const SideBar(),
            backgroundColor: Theme.of(context).primaryColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).primaryColor,
              leading: Builder(
                builder: (BuildContext context) => IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(Icons.menu),
                ),
              ),
              title: Row(
                children: [
                  Visibility(
                      visible: _selectedIndex == 0,
                      child: const Text(
                        "Tarefas",
                        style: TextStyle(fontFamily: 'PlusJakartaSans'),
                      )),
                  Visibility(
                      visible: _selectedIndex == 1,
                      child: const Text("Status",
                          style: TextStyle(fontFamily: 'PlusJakartaSans'))),
                  Visibility(
                      visible: _selectedIndex == 2,
                      child: const Text("Conquistas",
                          style: TextStyle(fontFamily: 'PlusJakartaSans')))
                ],
              ),
              actions: [
                Visibility(
                  visible: _selectedIndex == 0,
                  child: IconButton(
                    onPressed: () {
                      navegarParaPaginaListas();
                    },
                    icon: const Icon(Icons.format_list_numbered),
                  ),
                )
              ],
            ),
            body: IndexedStack(
              index: _selectedIndex,
              children: paginas,
            ),
            bottomNavigationBar: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                /*const Divider(
            height: 0.5,
            thickness: 0.5,
            indent: 0,
            endIndent: 0,
          ),*/
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  child: NavigationBar(
                    //labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
                    backgroundColor: Theme.of(context).secondaryHeaderColor,
                    destinations: const [
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: NavigationDestination(
                          icon: Icon(Icons.check_circle),
                          selectedIcon: Icon(Icons.check_circle),
                          label: 'Tarefas',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: NavigationDestination(
                          icon: Icon(Icons.trending_up_rounded),
                          label: 'Status',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: NavigationDestination(
                          icon: Icon(Icons.emoji_events),
                          label: 'Conquistas',
                        ),
                      ),
                    ],
                    selectedIndex: _selectedIndex, // Index selecionado
                    onDestinationSelected:
                        _onItemSelected, // Função ao selecionar
                    height: 65, // Tamanho da navigator bar
                    /*labelBehavior: // Só vai aparecer o texto sé estiver selecionado
                        NavigationDestinationLabelBehavior.onlyShowSelected,*/
                  ),
                ),
              ],
            ),
          );
  }
}
