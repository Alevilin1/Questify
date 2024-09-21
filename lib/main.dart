import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Autentificacao/Autentificacao.dart';
import 'package:flutter_quesfity/Componentes/SideBar.dart';
import 'package:flutter_quesfity/Modelos/user.dart';
import 'package:flutter_quesfity/Paginas/PaginaTarefas.dart';
import 'package:flutter_quesfity/Paginas/StatusPagina.dart';
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
      User? usuarioCarregado = await User.carregar(userId);

      if (usuarioCarregado != null) {
        user = usuarioCarregado;
      } else {
        user = User(id: userId);
        await user.salvar();
      }

      setState(() {}); // Atualiza a interface
    } else {
      // Aqui você pode lidar com o caso em que não há usuário autenticado
      print("Nenhum usuário autenticado.");
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
        title: const Text(
          "Todos",
          style: TextStyle(fontFamily: 'PlusJakartaSans'),
        ),
        actions: [],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: paginas,
      ),
      bottomNavigationBar: NavigationBar(
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
    );
  }
}
