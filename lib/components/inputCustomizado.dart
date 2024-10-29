import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputCustomizado extends StatelessWidget {
  InputCustomizado({
    required this.controller,
    required this.hint,
    this.obscure=false,
    this.icon=null,
    this.type = TextInputType.text,
    this.inputFormatters,
    this.maxLines=1,
    this.validator,
    this.onSaved,
    super.key});

  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final Icon? icon;
  final TextInputType type;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLines;
  final String? Function(String?)? validator;
  final String? Function(String?)? onSaved;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: this.controller,
      obscureText: this.obscure,
      style: TextStyle(
          fontSize: 20
      ),
      keyboardType: this.type,
      inputFormatters: this.inputFormatters,
      validator: this.validator,
      maxLines: this.maxLines,
      onSaved: this.onSaved,

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
