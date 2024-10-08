import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Autentificacao/autentificacao.dart';
import 'package:flutter_quesfity/Paginas/pagina_categorias.dart';
import 'package:flutter_quesfity/Paginas/pagina_filtros.dart';
import 'package:flutter_quesfity/Componentes/side_bar.dart';
import 'package:flutter_quesfity/Modelos/user.dart';
import 'package:flutter_quesfity/Paginas/pagina_tarefas.dart';
import 'package:flutter_quesfity/Paginas/pagina_testes.dart';
import 'package:flutter_quesfity/Paginas/pagina_status.dart';
import 'package:flutter_quesfity/firebase_options.dart';
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
  final bool isDarkTheme = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
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
        ),
        secondaryHeaderColor: Colors.grey[200],
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF000000),
        secondaryHeaderColor: const Color(0xFF1E1E1E),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        sliderTheme: const SliderThemeData(
          activeTrackColor: Colors.white,
        ),
        textTheme: Theme.of(context)
            .textTheme
            .apply(fontFamily: 'PlusJakartaSans', bodyColor: Colors.white),
      ),
      themeMode: ThemeMode.dark,
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
            return Login();
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

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index; // Atualiza o index
      print(_selectedIndex);
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

      if (usuarioCarregado != null) {
        // Caso o usuário tenha sido carregado
        user = usuarioCarregado; // Usando o usuário carregado'
      } else {
        user = User(id: userId); // Cria um novo usuário
        await user.salvar();
      }

      setState(() {
        isloading = false;
      }); // Atualiza a interface
    } else {
      // Aqui você pode lidar com o caso em que não há usuário autenticado
      print("Nenhum usuário autenticado.");
      isloading = false;
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

  @override
  void initState() {
    super.initState();
    _carregarUsuario(); // Carregando o usuário
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> paginas = <Widget>[
      PrimeiraPagina(
        user: user,
      ),
      StatusPagina(
        user: user,
      ),
      //TestePagina(),
      const PaginaCategorias()
    ];

    return Scaffold(
      drawer: SideBar(),
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
                child: const Text("Perfil",
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
      body: isloading ? const Center(child: CircularProgressIndicator()) :  IndexedStack(
        index: _selectedIndex,
        children: paginas,
      ),
      bottomNavigationBar: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(
            height: 1,
            thickness: 1,
            indent: 0,
            endIndent: 0,
          ),
          NavigationBar(
            //labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            backgroundColor: Theme.of(context).primaryColor,
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
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onItemSelected,
          ),
        ],
      ),
    );
  }
}
