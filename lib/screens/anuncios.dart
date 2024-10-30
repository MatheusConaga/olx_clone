import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/components/itemAnuncio.dart';
import 'package:olx_clone/models/anuncio.dart';
import 'package:olx_clone/routeGenerator.dart';
import 'package:olx_clone/utils/configuracoes.dart';

class Anuncios extends StatefulWidget {
  const Anuncios({super.key});

  @override
  State<Anuncios> createState() => _AnunciosState();
}

class _AnunciosState extends State<Anuncios> {

  List<String> itensMenu = [];
  String? _itemSelecionadoEstado;
  String? _itemSelecionadoCategoria;
  List<DropdownMenuItem<String>> _listaItensDropEstados = [];
  List<DropdownMenuItem<String>> _listaItensDropCategorias = [];
  final _controller = StreamController<QuerySnapshot>.broadcast();

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

  _carregarItensDropdown() {

    _listaItensDropCategorias = Configuracoes.getCategorias();

    _listaItensDropEstados = Configuracoes.getEstados();

  }

  Stream <QuerySnapshot> _adicionarListenerAnuncios(){

    FirebaseFirestore db = FirebaseFirestore.instance;

    Stream <QuerySnapshot> stream = db
        .collection("anuncios")
        .snapshots();

    stream.listen((dados){
      _controller.add(dados);

    });

    return _controller.stream;


  }

  Stream <QuerySnapshot> _filtrarAnuncios(){

    FirebaseFirestore db = FirebaseFirestore.instance;

    Query query = db.collection("anuncios");

    if ( _itemSelecionadoEstado != null ){

      query = query.where("estado",isEqualTo: _itemSelecionadoEstado);

    }
    if ( _itemSelecionadoCategoria != null ){

      query = query.where("categoria",isEqualTo: _itemSelecionadoCategoria);

    }

    Stream <QuerySnapshot> stream = query.snapshots();

    stream.listen((dados){
      _controller.add(dados);

    });

    return _controller.stream;


  }



  @override
  void initState() {
    super.initState();
    _carregarItensDropdown();
    _verificarUsuarioLogado();
    _adicionarListenerAnuncios();

  }


  @override
  Widget build(BuildContext context) {

    var carregandoDados = Center(
      child: Column(
        children: [
          CircularProgressIndicator(),
          Text("Carregando anúncios"),
        ],
      ),
    );


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
        child: Column(
          children: [

            Row(
              children: [

                Expanded(
                    child: DropdownButtonHideUnderline(
                        child: Center(
                          child: DropdownButton(
                              iconEnabledColor: Colors.purple,
                              value: _itemSelecionadoEstado,
                              items: _listaItensDropEstados,
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.black,
                              ),
                              onChanged: (estado){
                                setState(() {
                                  _itemSelecionadoEstado = estado;
                                  _filtrarAnuncios();
                                });
                              }
                          ),
                        ),
                    )
                ),

                Container(
                  color: Colors.grey![200],
                  width: 3,
                  height: 40,
                ),

                Expanded(
                    child: DropdownButtonHideUnderline(
                      child: Center(
                        child: DropdownButton(
                            iconEnabledColor: Colors.purple,
                            value: _itemSelecionadoCategoria,
                            items: _listaItensDropCategorias,
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.black,
                            ),
                            onChanged: (categoria){
                              setState(() {
                                _itemSelecionadoCategoria = categoria;
                                _filtrarAnuncios();
                              });
                            }
                        ),
                      ),
                    )
                ),

              ],
            ),

            StreamBuilder(
                stream: _controller.stream,
                builder: (context,snapshot){
                  switch ( snapshot.connectionState ){
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return carregandoDados;
                      break;
                    case ConnectionState.active:
                    case ConnectionState.done:

                      QuerySnapshot querySnapshot = snapshot.data!;

                      if(querySnapshot.docs.length == 0){
                        return Container(
                          padding: EdgeInsets.all(25),
                          child: Text(
                            "Nenhum anúncio! :C",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }
                      return Expanded(
                          child: ListView.builder(
                              itemBuilder: (_,index){

                                List<DocumentSnapshot> anuncios = querySnapshot.docs.toList();
                                DocumentSnapshot documentSnapshot = anuncios[index];
                                Anuncio anuncio = Anuncio.fromDocumentSnapshot(documentSnapshot);

                                return ItemAnuncio(
                                    anuncio: anuncio,
                                    onTapItem: (){
                                      Navigator.pushNamed(
                                          context,
                                          Routes.detalhesAnuncio,
                                          arguments: anuncio
                                      );
                                    },

                                );

                              },
                            itemCount: querySnapshot.docs.length,
                          ),
                      );

                  }
                  return Container();
                }
            ),


          ],
        ),
      ),
    );
  }
}
