import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quesfity/Classes/conquista.dart';

class User extends ChangeNotifier {
  final String? id;
  final String? nome;
  double xp;
  int conquistasDesbloqueadas;
  int nivel;
  int tarefasConcluidas;
  List<dynamic> filtros; // Lista de filtros

  //Map<String, dynamic> xpAtributos = {}; // xp dos atributos
  //Map<String, dynamic> nivelAtributos = {}; // nivel dos atributos

  User({
    this.id,
    this.nome,
    this.xp = 0,
    this.conquistasDesbloqueadas = 0,
    this.tarefasConcluidas = 0,
    int? nivel,
    //Map<String, dynamic>? xpAtributos,
    //Map<String, dynamic>? nivelAtributos,
    List<dynamic>? filtros,
  })  : filtros = filtros ??
            [
              'Trabalho',
              'Pessoal',
              'Estudo'
            ], // Inicializando os filtros padrao
        nivel = nivel ?? 1;
  /*: xpAtributos = xpAtributos ?? // Inicializando os valores do xp
            {
              'forca': 0,
              'inteligencia': 0,
              'carisma': 0,
            },
        nivelAtributos = nivelAtributos ?? // Inicializando os valores do nivel
            {
              'forca': 1,
              'inteligencia': 1,
              'carisma': 1,
            },*/

  //Salvando os dados do usuario
  Future<void> salvar() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore.collection('users').doc(id).set({
      'xp': xp,
      'nivel': nivel,
      'nome': nome,
      'conquistasDesbloqueadas': conquistasDesbloqueadas,
      'filtros': filtros,
      'tarefasConcluidas': tarefasConcluidas,
    });
  }

  /*Future<void> carregarConquistas(List<Conquista> listaDeConquistas) async {
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
        notifyListeners();
      } else {}
    }
  }

  Future<void> carregarUsuario(
      User user, List<Conquista> listaDeConquistas, bool isloading) async {
    final firebaseUser = firebase_auth
        .FirebaseAuth.instance.currentUser; // Usando o uid do Firebase Auth

    if (firebaseUser != null) {
      // Usando o uid do Firebase Auth
      String userId = firebaseUser.uid;
      User? usuarioCarregado =
          await User.carregar(userId); // Carregando o usuário

      if (usuarioCarregado != null) {
        // Se o usuário foi carregado
        // Caso o usuário tenha sido carregado
        user = usuarioCarregado; // Usando o usuário carregado
      } else {
        // Caso o usuário não tenha sido carregado
        user = User(id: userId); // Cria um novo usuário
        await user.salvar(); // Cria o usuário
        await user.salvarConquistas(listaDeConquistas); // Cria as conquistas
      }
    }

    notifyListeners(); // Atualiza a interface
  }*/

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
        'createdAt':
            FieldValue.serverTimestamp(), // Adiciona o Timestamp ao criar
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
  static Future<User?> carregar(String userId) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection('users').doc(userId).get();

    if (snapshot.exists) {
      // Se o usuario existe
      var data = snapshot.data(); // Pega os dados

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

      return User(
        id: userId,
        nome: data?['nome'] ?? "Usuário",
        xp: data?['xp'] ?? 0,
        nivel: data?['nivel'] ?? 1,
        conquistasDesbloqueadas: data?['conquistasDesbloqueadas'] ?? 0,
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

  /*int xpDosAtributos(String atributo) {
    return nivelAtributos[atributo] * 100;
  }

  double progressaoDosAtributos(String atributo) {
    //Mesmo processo da progressao do xp geral para os atributos
    return xpAtributos[atributo] / xpDosAtributos(atributo);
  }
}*/
}
