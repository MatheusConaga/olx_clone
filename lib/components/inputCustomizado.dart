import 'package:flutter/material.dart';

class InputCustomizado extends StatelessWidget {
  InputCustomizado({
    required this.controller,
    required this.hint,
    this.obscure=false,
    this.icon=null,
    this.type = TextInputType.text,
    super.key});

  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final Icon? icon;
  final TextInputType type;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: this.controller,
      obscureText: this.obscure,
      style: TextStyle(
          fontSize: 20
      ),
      keyboardType: this.type,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
        hintText: this.hint,
        prefixIcon: this.icon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    );
  }
}
