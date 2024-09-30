import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  String id;
  double xp;
  int nivel;

  List<dynamic> filtros;

  Map<String, dynamic> xpAtributos = {}; // xp dos atributos
  Map<String, dynamic> nivelAtributos = {}; // nivel dos atributos

  User({
    required this.id,
    this.xp = 0,
    this.nivel = 1,
    Map<String, dynamic>? xpAtributos,
    Map<String, dynamic>? nivelAtributos,
    this.filtros = const ['Trabalho', 'Pessoal', 'Estudo'],
  })  : xpAtributos = xpAtributos ?? // Inicializando os valores do xp
            {
              'forca': 0,
              'inteligencia': 0,
              'destreza': 0,
            },
        nivelAtributos = nivelAtributos ?? // Inicializando os valores do nivel
            {
              'forca': 1,
              'inteligencia': 1,
              'destreza': 1,
            };

  //Salvando os dados do usuario
  Future<void> salvar() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('users').doc(id).set({
      'xp': xp,
      'nivel': nivel,
      'xpAtributos': xpAtributos,
      'nivelAtributos': nivelAtributos,
      'filtros' : filtros
    });
  }

  // Atualiza os filtros
  Future<void> atualizarFiltro() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('users').doc(id).update({
      'filtros': filtros
    });
  }

  // Carrega os dados do usuário do Firestore
  static Future<User?> carregar(String userId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection('users').doc(userId).get();

    if (snapshot.exists) {
      var data = snapshot.data();
      return User(
        id: userId,
        xp: data?['xp'] ?? 0,
        nivel: data?['nivel'] ?? 1,
        xpAtributos: data?['xpAtributos'] ?? {},
        nivelAtributos: data?['nivelAtributos'] ?? {},
        filtros: data?['filtros'] ?? [],
      );
    }
    return null; // Caso o usuário não exista
  }

  int xpNivel() {
    //Se o nivel for dois, então o xp necessario para o proximo nivel, vai ser 200
    return nivel * 100;
  }

  double progressao() {
    //Tenho que fazer esse calculo, pois o valor da barra de progresso é somente de 0 a 1
    return xp /
        xpNivel(); //Exemplo: xp: 20, xpnivel = 200, 20/200 = 0,1. 0,1 é 10% na barra de progresso
  }
}
