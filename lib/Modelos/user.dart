import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_quesfity/Modelos/conquista.dart';

class Usuario {
  String id;
  double xp;
  int nivel;
  int tarefasConcluidas;

  List<dynamic> filtros; // Lista de filtros

  Map<String, dynamic> xpAtributos = {}; // xp dos atributos
  Map<String, dynamic> nivelAtributos = {}; // nivel dos atributos

  Usuario({
    required this.id,
    this.xp = 0,
    this.tarefasConcluidas = 0,
    int? nivel,
    Map<String, dynamic>? xpAtributos,
    Map<String, dynamic>? nivelAtributos,
    List<dynamic>? filtros,
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
            },
        filtros = filtros ??
            [
              'Trabalho',
              'Pessoal',
              'Estudo'
            ], // Inicializando os filtros padrao
        nivel = nivel ?? 1;

  //Salvando os dados do usuario
  Future<void> salvar() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('users').doc(id).set({
      'xp': xp,
      'nivel': nivel,
      'xpAtributos': xpAtributos,
      'nivelAtributos': nivelAtributos,
      'filtros': filtros,
      'tarefasConcluidas': tarefasConcluidas,
    });
  }

  Future<void> salvarConquistas(List<Conquista> conquistas) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    for (Conquista conquista in conquistas) {
      DocumentReference docRef = await firestore
          .collection('users')
          .doc(id)
          .collection('conquistas')
          .add({
        'nome': conquista.nome,
        'descricao': conquista.descricao,
        'desbloqueado': conquista.desbloqueado,
        'idFuncao': conquista.idFuncao,
        'quantidadeDesbloqueio': conquista.quantidadeDesbloqueio,
        'icone': conquista.icone?.codePoint,
        'createdAt': FieldValue.serverTimestamp(), // Adiciona o Timestamp ao criar
      });
      conquista.id = docRef.id;
    }
  }

  // Atualiza os filtros
  Future<void> atualizarFiltro() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('users').doc(id).update({'filtros': filtros});
  }

  // Carrega os dados do usuário do Firestore
  static Future<Usuario?> carregar(String userId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection('users').doc(userId).get();

    if (snapshot.exists) {
      var data = snapshot.data();
      /*List<Conquista> conquistasCarregadas = [];

      // Carrega as conquistas do usuário
      QuerySnapshot<Map<String, dynamic>> conquistasSnapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('conquistas')
          .get();

      conquistasCarregadas = conquistasSnapshot.docs.map((doc) {
        return Conquista(
          nome: doc['nome'],
          descricao: doc['descricao'],
          idFuncao: doc['idFuncao'],
          desbloqueado: doc['desbloqueado'],
        );
      }).toList();*/

      return Usuario(
        id: userId,
        xp: data?['xp'] ?? 0,
        nivel: data?['nivel'] ?? 1,
        xpAtributos: data?['xpAtributos'] ?? {},
        nivelAtributos: data?['nivelAtributos'] ?? {},
        filtros: data?['filtros'] ?? [],
        tarefasConcluidas: data?['tarefasConcluidas'] ?? 0,
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
