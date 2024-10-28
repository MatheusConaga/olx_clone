import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/routeGenerator.dart';

class Anuncios extends StatefulWidget {
  const Anuncios({super.key});

  @override
  State<Anuncios> createState() => _AnunciosState();
}

class _AnunciosState extends State<Anuncios> {

  List<String> itensMenu = [];

  _escolhaMenuItem(String itemEscolhido){

    switch( itemEscolhido ){

      case "Meus anúncios":
        Navigator.pushNamed(context, Routes.meusAnuncios);
        break;
      case "Entrar / Cadastrar":
        Navigator.pushNamed(context, Routes.login);
        break;
      case "Deslogar":
        _deslogarUsuario();
        break;


    }

  }

  _deslogarUsuario() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    
    Navigator.pushReplacementNamed(context, Routes.login);
    
  }

  Future _verificarUsuarioLogado() async{

    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser;

    if ( usuarioLogado == null ){

      itensMenu = [
        "Entrar / Cadastrar"
      ];

    } else{
      itensMenu = [
        "Meus anúncios",
        "Deslogar"
      ];
    }

  }

  @override
  void initState() {
    super.initState();
    _verificarUsuarioLogado();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text("OLX",),
        elevation: 0,
        actions: [
          PopupMenuButton <String>(
              onSelected: _escolhaMenuItem,
              itemBuilder: (context) {
                  return itensMenu.map((String item){
                    return PopupMenuItem <String>(
                        value: item,
                        child: Text(item),
                    );
                  }).toList();
              },
            color: Colors.white,
            icon: Icon(Icons.menu, color: Colors.white,),
          ),
        ],
      ),
      body: Container(
        child: Text("Anuncios"),
      ),
    );
  }
}
