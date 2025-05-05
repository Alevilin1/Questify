import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quesfity/Classes/dark_theme.dart';
import 'package:flutter_quesfity/Componentes/componente_escolha.dart';
import 'package:flutter_quesfity/Classes/lista_tarefas.dart';
import 'package:flutter_quesfity/Classes/user.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../Classes/tarefas.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

// ignore: must_be_immutable
class CriarTarefa extends StatefulWidget {
  User user;

  CriarTarefa({super.key, required this.user});

  @override
  State<StatefulWidget> createState() {
    return CriarTarefaState();
  }
}

class CriarTarefaState extends State<CriarTarefa> {
  TextEditingController tituloControler = TextEditingController();
  TextEditingController descricaoControler = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late bool _darkTheme;

  String filtroSelecionado = '';
  bool jaCliquei = false;

  List<String> dificuldades = ["Fácil", "Médio", "Difícil"];
  String dificuldadeSelecionada = "Fácil";
  double xpCriacaoTarefa() {
    return dificuldadeSelecionada == "Fácil"
        ? 50
        : dificuldadeSelecionada == "Médio"
            ? 100
            : dificuldadeSelecionada == "Difícil"
                ? 150
                : 50;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _darkTheme = Provider.of<IsDark>(context, listen: false).isDarkTheme;

      /*SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              //statusBarColor: Color.fromARGB(255, 210, 190, 230), // Cor da barra de status
              statusBarIconBrightness: Brightness.light, // Ícones claros
              systemNavigationBarColor: _darkTheme
                  ? const Color.fromARGB(255, 34, 39, 39)
                  : Colors
                      .white) // Cor da barra de navegação //Color.fromARGB(255, 24, 23,23))
          );*/
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tituloControler.dispose();
    descricaoControler.dispose();

    /*SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            //statusBarColor: Color.fromARGB(255, 210, 190, 230), // Cor da barra de status
            statusBarIconBrightness: Brightness.light, // Ícones claros
            systemNavigationBarColor: _darkTheme
                ? const Color(0xFF111111)
                : const Color(
                    0xFFF2F5FF)) // Cor da barra de navegação //Color.fromARGB(255, 24, 23,23))
        );*/
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final providerTarefas = Provider.of<ListaTarefas>(context);
    //final darkTheme = Provider.of<IsDark>(context).isDarkTheme;
    var listaDeTarefas = providerTarefas.listaDeTarefas;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Theme.of(context).iconTheme.color),
          title: Text(
            "Criar tarefa",
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).iconTheme.color,
                fontSize: 16),
          ),
        ),
        body: Form(
          key: _formKey,
          child: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Stack(
              children: [
                /*Positioned.fill(
                    child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                        Color(0xFF9C2CF3).withOpacity(0.8),
                        Color(0xFF3A49F9).withOpacity(0.8)
                      ])),
                )),
                Positioned(
                left: -50,
                top: 160,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(70),
                    color: Color(0xFF2E3A59),
                  ),
                )),*/

                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                        const Color(0xFF9C2CF3).withOpacity(0.9),
                        const Color(0xFF3A49F9).withOpacity(0.9),
                      ])),
                  height: screenSize.height / 2.3, // 2.5
                  width: screenSize.width,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Nome",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        TextFormField(
                          controller: tituloControler,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, digite um título';
                            }
                            return null;
                          },
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              fontSize: 18),
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: const Color(0xFFD7DDF0)
                                          .withOpacity(0.5))),
                              focusedBorder: const UnderlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFD7DDF0))),
                              hintText: "Digite o nome da tarefa",
                              hintStyle: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                  color: Colors.white)),
                        )
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: screenSize.height / 1.6,
                      width: screenSize.width,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24)),
                          color: Theme.of(context).cardTheme.color),
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Descrição",
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFFBFC8E8)),
                                ),
                              ],
                            ),
                            TextField(
                              controller: descricaoControler,
                              minLines: 1,
                              maxLines: 2,
                              style: GoogleFonts.poppins(),
                              decoration: InputDecoration(
                                hintText: "Digite a descrição da tarefa",
                                hintStyle: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "Categoria",
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFFBFC8E8)),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Wrap(
                              spacing: 20,
                              runSpacing: 20,
                              children: widget.user.filtros.map((filtro) {
                                bool isSelected = filtroSelecionado == filtro;
                                return GestureDetector(
                                    onTap: () {
                                      if (filtroSelecionado == filtro) {
                                        filtroSelecionado = "";
                                      } else {
                                        filtroSelecionado = filtro;
                                      }
                                      setState(() {});
                                    },
                                    child: ComponenteEscolha(
                                        texto: filtro, isSelected: isSelected));
                              }).toList(),
                            ),
                            const SizedBox(
                              height: 24,
                            ),
                            Text(
                              "Dificuldade",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                  color: const Color(0xFFBFC8E8)),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Wrap(
                              spacing: 20,
                              runSpacing: 20,
                              children: dificuldades.map((dificuldade) {
                                bool isSelected =
                                    dificuldadeSelecionada == dificuldade;
                                return GestureDetector(
                                  onTap: () {
                                    dificuldadeSelecionada = dificuldade;
                                    setState(() {});
                                  },
                                  child: ComponenteEscolha(
                                      texto: dificuldade,
                                      isSelected: isSelected),
                                );
                              }).toList(),
                            ),
                            const Spacer(),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                width: double.infinity,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(28),
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            const Color(0xFF9C2CF3)
                                                .withOpacity(0.9),
                                            const Color(0xFF3A49F9)
                                                .withOpacity(0.9),
                                          ])),
                                  height: 55,
                                  child: ElevatedButton(
                                      style: const ButtonStyle(
                                        shadowColor: WidgetStatePropertyAll(
                                            Colors.transparent),
                                        backgroundColor: WidgetStatePropertyAll(
                                            Colors.transparent),
                                      ),
                                      onPressed: () async {
                                        if (jaCliquei == false) {
                                          jaCliquei = true;
                                          if (_formKey.currentState!
                                              .validate()) {
                                            final firebaseUser = firebase_auth
                                                .FirebaseAuth
                                                .instance
                                                .currentUser;

                                            if (firebaseUser != null) {
                                              String userId = firebaseUser.uid;

                                              Tarefas novaTarefa = Tarefas(
                                                titulo: tituloControler.text,
                                                descricao:
                                                    descricaoControler.text,
                                                xp: xpCriacaoTarefa(),
                                                filtroTarefa: filtroSelecionado,
                                              );

                                              // Salvando a tarefa no Firestore
                                              await novaTarefa.salvar(userId);

                                              providerTarefas.adicionarTarefa(
                                                  novaTarefa); // Adicionar apenas no db para não adicionar duas vezes

                                              tituloControler.text = "";
                                              descricaoControler.text = "";
                                              filtroSelecionado = "";
                                              dificuldadeSelecionada = "Fácil";

                                              // Depois de criar a tarefa, volta para a página principal
                                              Navigator.pop(
                                                  context, listaDeTarefas);
                                            }
                                          } else {
                                            jaCliquei = false;
                                          }
                                        }
                                      },
                                      child: Text(
                                        "Criar Tarefa",
                                        style: GoogleFonts.poppins(
                                            color: Colors.white),
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}

/*

Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          "Nova Tarefa",
          style: TextStyle(fontFamily: 'PlusJakartaSans'),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (jaCliquei == false) {
                jaCliquei = true;
                if (_formKey.currentState!.validate()) {
                  final firebaseUser =
                      firebase_auth.FirebaseAuth.instance.currentUser;

                  if (firebaseUser != null) {
                    String userId = firebaseUser.uid;

                    Tarefas novaTarefa = Tarefas(
                      titulo: tituloControler.text,
                      descricao: descricaoControler.text,
                      xp: xpCriacaoTarefa(),
                      atributos: atributosSelecionados,
                      filtroTarefa: filtroSelecionado,
                    );

                    // Salvando a tarefa no Firestore
                    await novaTarefa.salvar(userId);

                    providerTarefas.adicionarTarefa(novaTarefa);

                    // Depois de criar a tarefa, volta para a página principal
                    Navigator.pop(context, listaDeTarefas);
                  }
                } else {
                  jaCliquei = false;
                }
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Container(
                width: screenSize.width * 0.9,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.all(screenSize.width * 0.02),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Básico",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: TextFormField(
                              controller: tituloControler,
                              decoration: _inputDecoration("Título"),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, digite um título';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 25),
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: TextFormField(
                              maxLines: null,
                              expands: false,
                              controller: descricaoControler,
                              decoration: _inputDecoration("Descrição"),
                            ),
                          ),
                          const SizedBox(height: 25),
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: DropdownButtonFormField(
                              isExpanded: true,
                              autofocus: false,
                              hint: Text(
                                filtroSelecionado.isEmpty
                                    ? 'Selecione um filtro'
                                    : filtroSelecionado,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              decoration: const InputDecoration(
                                labelText: 'Filtro',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(10),
                              ),
                              items: widget.user.filtros.map((filtro) {
                                return DropdownMenuItem(
                                  value: filtro,
                                  child: Text(filtro),
                                );
                              }).toList(), //Convertendo para lista
                              onChanged: (selectedValue) {
                                setState(() {
                                  filtroSelecionado = selectedValue.toString();
                                });

                                //print(selectedValue);
                              },
                            ),
                          ),
                          const SizedBox(height: 15),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              "Avançado",
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                          Text(
                            "+${xpCriacaoTarefa()}XP",
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.orange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Column(
                        children: [
                          EscolherDificuldade(
                            onXPChanged: updateXpDificuldade,
                          ),
                          const SizedBox(height: 10),
                          EscolherImportancia(
                            onXPChanged: updateXpImportancia,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    */
