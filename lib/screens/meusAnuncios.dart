import 'package:flutter/material.dart';
import 'package:olx_clone/routeGenerator.dart';

class MeusAnuncios extends StatefulWidget {
  const MeusAnuncios({super.key});

  @override
  State<MeusAnuncios> createState() => _MeusAnunciosState();
}

class _MeusAnunciosState extends State<MeusAnuncios> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("Meus anúncios",),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
              Navigator.pushNamed(context, Routes.novoAnuncio);
          },
        child: Icon(Icons.add),
      ),
      body: Container(

      ),

    );
  }
}

