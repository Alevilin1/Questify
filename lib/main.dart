import 'dart:async';
import 'package:achievement_view/achievement_view.dart';
//import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:flutter_quesfity/Autentificacao/autentificacao.dart';
import 'package:flutter_quesfity/Classes/conquista.dart';
import 'package:flutter_quesfity/Classes/dark_theme.dart';
import 'package:flutter_quesfity/Classes/lista_tarefas.dart';
import 'package:flutter_quesfity/Paginas/pagina_configuracoes.dart';
//import 'package:flutter_quesfity/Paginas/pagina_conquistas.dart';
import 'package:flutter_quesfity/Paginas/pagina_filtros.dart';
import 'package:flutter_quesfity/Componentes/side_bar.dart';
import 'package:flutter_quesfity/Classes/user.dart';
import 'package:flutter_quesfity/Paginas/pagina_tarefas.dart';
import 'package:flutter_quesfity/Paginas/pagina_status.dart';
//import 'package:flutter_quesfity/Paginas/pagina_testes.dart';
import 'package:flutter_quesfity/data.dart';
import 'package:flutter_quesfity/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:intl/intl.dart';
//import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Inicializando o Firebase

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => User()),
    ChangeNotifierProvider(create: (_) => ListaTarefas()),
    ChangeNotifierProvider(create: (_) => IsDark())
  ], child: const Main()));
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => MainState();
}

class MainState extends State<Main> {
  @override
  void initState() {
    super.initState();
    Provider.of<IsDark>(context, listen: false).getTheme();
  }

  @override
  Widget build(BuildContext context) {
    var darkTheme = Provider.of<IsDark>(context);
    var dark = darkTheme.isDarkTheme;

    /*SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            //statusBarColor: Color.fromARGB(255, 210, 190, 230), // Cor da barra de status
            statusBarIconBrightness: Brightness.light, // Ícones claros
            systemNavigationBarColor: !dark
                ? Colors.white //Color(0xFFF2F5FF)
                : const Color(
                    0xFF111111)) // Cor da barra de navegação //Color.fromARGB(255, 24, 23,23))
        );*/

    return MaterialApp(
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: const Color(0xFFF2F5FF),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.black12,
            foregroundColor: Colors.white,
          ),
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: Colors.black,
              ),
          cardTheme: const CardTheme(color: Colors.white),
          iconTheme: const IconThemeData(color: Colors.white),
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
          drawerTheme: const DrawerThemeData(
            backgroundColor: Colors.white,
          )),
      darkTheme: ThemeData(
          drawerTheme: const DrawerThemeData(
            backgroundColor: Color.fromARGB(255, 34, 39, 39),
          ),
          brightness: Brightness.dark,
          iconTheme: const IconThemeData(color: Colors.black),
          primaryColor: const Color(
              0xFF111111), //const Color(0xFF111111) //const Color(0xFF000000) const Color.fromARGB(255, 24, 23, 23)
          secondaryHeaderColor: const Color(0xFF1E1E1E),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          cardTheme: const CardTheme(color: Color.fromARGB(255, 34, 39, 39)),
          sliderTheme: const SliderThemeData(
            activeTrackColor: Colors.white,
            inactiveTickMarkColor: Colors.white24,
            thumbColor: Colors.white,
          ),
          textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.white),
          cardColor: const Color.fromARGB(255, 34, 39, 39),
          navigationBarTheme: const NavigationBarThemeData(
            backgroundColor: Color(0xFF323335),
          )),
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
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
  User user = User(id: "");
  bool isloading = true;
  //AudioPlayer audioPlayer = AudioPlayer();
  bool estaMostrandoConquista = false;
  bool cabecalho = true;

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
      descricao: "Atinja o nivel 5",
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
      User? usuarioCarregado =
          await User.carregar(userId); // Carregando o usuário

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (usuarioCarregado != null &&
          doc.data()!.containsKey("filtros") &&
          doc.data()!.containsKey("xp") &&
          doc.data()!.containsKey("nivel") &&
          doc.data()!.containsKey("tarefasConcluidas")) {
        // Se o usuário foi carregado
        // Caso o usuário tenha sido carregado
        user = usuarioCarregado; // Usando o usuário carregado
      } else {
        // Caso o usuário não tenha sido carregado

        if (doc.exists &&
            doc.data() != null &&
            doc.data()!.containsKey('nome')) {
          user = User(id: userId, nome: doc['nome']);
        } else {
          user = User(id: userId, nome: 'Usuário');
        } // Cria um novo usuário
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
      await Future.delayed(const Duration(
          milliseconds: 500)); // Aguarde para mostrar outra conquista, se tiver
    }

    estaMostrandoConquista = true; // Define que a conquista está sendo mostrada

    //Tocando o som de desbloqueio
    //audioPlayer.play(AssetSource('mixkit-software-interface-start-2574.wav'));

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
      isCircle: false,
      icon: const FaIcon(
        FontAwesomeIcons.trophy,
        color: Colors.green,
      ),
      title: conquista.nome,
      subTitle: conquista.descricao,
    ).show(context);

    Future.delayed(const Duration(seconds: 6), () {
      //Espera acabar o desbloqueio
      estaMostrandoConquista =
          false; // Define que a conquista não está sendo mostrada para mostrar a outra conquista
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

          user.conquistasDesbloqueadas++;
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

          user.conquistasDesbloqueadas++;
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
        cabecalho: cabecalho,
      ),
      StatusPagina(user: user, listaDeConquistas: listaDeConquistas),
      //PaginaConquistas(listaDeConquistas: listaDeConquistas)
      PaginaConfiguracoes(
        user: user,
      ),
    ];

    return isloading
        ? Container(
            alignment: Alignment.center,
            color: Theme.of(context).primaryColor,
            child: Image.asset(
                'lib/Icones/Logo.png')) //const CircularProgressIndicator())
        : Scaffold(
            drawer: const SideBar(),
            backgroundColor: Theme.of(context).primaryColor,
            /*appBar: AppBar(
              centerTitle: true,
              surfaceTintColor: Theme.of(context).primaryColor,
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
                    icon: const Icon(Icons.filter_list),
                  ),
                ),
                Visibility(
                  visible: _selectedIndex == 0,
                  child: PopupMenuButton(
                      color: Theme.of(context).secondaryHeaderColor,
                      itemBuilder: (context) {
                        return [];
                      }),
                )
              ],
            ),*/
            body: IndexedStack(
              index: _selectedIndex,
              children: paginas,
            ),
            bottomNavigationBar: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              child: SizedBox(
                height: 55,
                child: NavigationBar(
                    selectedIndex: _selectedIndex, // Index selecionado
                    onDestinationSelected: _onItemSelected,
                    indicatorColor: Colors.transparent,
                    //backgroundColor: Theme.of(context).primaryColor,
                    backgroundColor: Theme.of(context).cardColor,
                    destinations: [
                      //Color(0xFF9C2CF3).withOpacity(0.8),Color(0xFF3A49F9).withOpacity(0.8)
                      NavigationDestination(
                          icon: iconeNormal(Icons.home),
                          selectedIcon: const IconeGradient(icone: Icons.home),
                          label: ""),
                      NavigationDestination(
                          icon: iconeNormal(Icons.person),
                          selectedIcon: const IconeGradient(
                            icone: Icons.person,
                          ),
                          label: ""),
                      NavigationDestination(
                          icon: iconeNormal(Icons.settings),
                          selectedIcon:
                              const IconeGradient(icone: Icons.settings),
                          label: "")
                    ]),
              ),
            ),
            /*bottomNavigationBar: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                /*const Divider(
                  height: 0.5,
                  thickness: 0.2,
                  indent: 0,
                  endIndent: 0,
                  color: Colors.white,
                ),*/
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  child: NavigationBar(
                    //labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
                    backgroundColor: Theme.of(context).secondaryHeaderColor,
                    destinations: [
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: NavigationDestination(
                          icon: Icon(Icons.check_circle,
                              color: _selectedIndex == 0
                                  ? Colors.white
                                  : Colors.grey),
                          //selectedIcon: Icon(Icons.check_box),
                          label: 'Tarefas',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: NavigationDestination(
                          icon: Icon(
                            Icons.trending_up_rounded,
                            color: _selectedIndex == 1
                                ? Colors.white
                                : Colors.grey,
                          ),
                          label: 'Status',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: NavigationDestination(
                          icon: Icon(Icons.emoji_events,
                              color: _selectedIndex == 2
                                  ? Colors.white
                                  : Colors.grey),
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
                    elevation: 5,
                  ),
                ),
              ],
            ),*/
          );
  }

  Transform iconeNormal(IconData icone) {
    return Transform.translate(
      offset: const Offset(0, 5),
      child: Icon(
        icone,
        color: Colors.grey,
        size: 30,
      ),
    );
  }
}

class IconeGradient extends StatelessWidget {
  final IconData icone;
  const IconeGradient({
    required this.icone,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, 5),
      child: ShaderMask(
        shaderCallback: (bounds) =>
            LinearGradient(colors: gradient).createShader(bounds),
        child: Icon(
          icone,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }
}
/*

SizedBox(
              //height: 40,
              child: NavigationBar(
                  selectedIndex: _selectedIndex, // Index selecionado
                  onDestinationSelected: _onItemSelected,
                  indicatorColor: Colors.transparent,
                  //backgroundColor: Theme.of(context).primaryColor,
                  backgroundColor: Colors.red,
                  destinations: const [
                    //Color(0xFF9C2CF3).withOpacity(0.8),Color(0xFF3A49F9).withOpacity(0.8)
                    NavigationDestination(
                        icon: Icon(
                          Icons.home,
                          color: Colors.grey,
                          size: 30,
                        ),
                        selectedIcon: IconeGradient(icone: Icons.home),
                        label: ""),
                    NavigationDestination(
                        icon: Icon(
                          Icons.person,
                          color: Colors.grey,
                          size: 30,
                        ),
                        selectedIcon: IconeGradient(
                          icone: Icons.person,
                        ),
                        label: ""),
                    NavigationDestination(
                        icon: Icon(
                          Icons.settings,
                          color: Colors.grey,
                          size: 30,
                        ),
                        selectedIcon: IconeGradient(icone: Icons.settings),
                        label: "")
                  ]),
            ),*/