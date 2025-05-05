import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ComponenteEscolha extends StatelessWidget {
  final String texto;
  final bool isSelected;
  const ComponenteEscolha(
      {super.key, required this.texto, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: isSelected
              ? const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0, 100],
                  colors: [Color(0xFF9C2CF3), Color(0xFF3A49F9)])
              : null,
          color: !isSelected ? const Color(0xFFE5EAFC) : null),
      child: Center(
          child: Text(
        texto,
        style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: isSelected ? Colors.white : Colors.black),
      )),
    );
  }
}
