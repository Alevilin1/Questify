import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IsDark extends ChangeNotifier {
  bool isDarkTheme = false;

  void changeTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkTheme = !isDarkTheme;
    prefs.setBool("isDarkTheme", isDarkTheme);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            //statusBarColor: Color.fromARGB(255, 210, 190, 230), // Cor da barra de status
            statusBarIconBrightness: Brightness.light, // Ícones claros
            systemNavigationBarColor: !isDarkTheme
                ? Colors.white //const Color(0xFFF2F5FF)
                : const Color.fromARGB(255, 34, 39, 39))
        /*const Color(
                    0xFF111111)) // Cor da barra de navegação //Color.fromARGB(255, 24, 23,23))*/
        );
    notifyListeners();
  }

  void getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkTheme = prefs.getBool("isDarkTheme") ?? false;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            //statusBarColor: Color.fromARGB(255, 210, 190, 230), // Cor da barra de status
            statusBarIconBrightness: Brightness.light, // Ícones claros
            systemNavigationBarColor: !isDarkTheme
                ? Colors.white //const Color(0xFFF2F5FF)
                : const Color.fromARGB(255, 34, 39, 39))
        //Color(0xFF111111)) // Cor da barra de navegação //Color.fromARGB(255, 24, 23,23))
        );
    notifyListeners();
  }
}
