import 'package:flutter/material.dart';

class BotaoCustomizado extends StatelessWidget {
  BotaoCustomizado({required this.texto, required this.onPressed, this.corTexto,super.key});

  final String texto;
  final Color? corTexto;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple,
        padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
      ),
      onPressed: this.onPressed,
      child: Text(
        this.texto,
        style: TextStyle(
            color: this.corTexto,
            fontWeight: FontWeight.bold,
            fontSize: 16
        ),
      ),
    );
  }
}
