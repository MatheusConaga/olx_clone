import 'package:flutter/material.dart';
import 'package:olx_clone/models/anuncio.dart';


class DetalhesAnuncio extends StatefulWidget {
  final Anuncio anuncio;

  DetalhesAnuncio({required this.anuncio,super.key});




  @override
  State<DetalhesAnuncio> createState() => _DetalhesAnuncioState();
}

class _DetalhesAnuncioState extends State<DetalhesAnuncio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(),
    );
  }
}
