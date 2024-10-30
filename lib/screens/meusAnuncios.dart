import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/components/itemAnuncio.dart';
import 'package:olx_clone/models/anuncio.dart';
import 'package:olx_clone/routeGenerator.dart';

class MeusAnuncios extends StatefulWidget {
  const MeusAnuncios({super.key});

  @override
  State<MeusAnuncios> createState() => _MeusAnunciosState();
}

class _MeusAnunciosState extends State<MeusAnuncios> {

  final _controller = StreamController<QuerySnapshot>.broadcast();
  String _idUsuarioLogado = "";

  _recuperaDadosUsuarioLogado() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser;
    _idUsuarioLogado = usuarioLogado!.uid;
  }

   Stream <QuerySnapshot> _adicionarListenerAnuncios(){

     FirebaseFirestore db = FirebaseFirestore.instance;

     _recuperaDadosUsuarioLogado().then((_){


       Stream <QuerySnapshot> stream = db
           .collection("meus_anuncios")
           .doc(_idUsuarioLogado)
           .collection("anuncios")
           .snapshots();

       stream.listen((dados){
         _controller.add( dados );
       });


     });

     return _controller.stream;


  }

  _removerAnuncio(String idAnuncio){

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("meus_anuncios")
    .doc(_idUsuarioLogado)
    .collection("anuncios")
    .doc(idAnuncio)
    .delete().then((_){

      db.collection("anuncios")
          .doc(idAnuncio)
          .delete();

    });

  }

  @override
  void initState() {
    super.initState();
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
        title: Text("Meus anúncios",),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            Navigator.pushNamed(context, Routes.novoAnuncio);
          },
          foregroundColor: Colors.white,
         icon: Icon(Icons.add),
        label: Text("Adicionar"),
      ),
      body: StreamBuilder(
          stream: _controller.stream,
          builder: (context,snapshot){

            switch ( snapshot.connectionState ){

              case ConnectionState.none:
              case ConnectionState.waiting:
                return carregandoDados;
                break;
              case ConnectionState.active:
              case ConnectionState.done:
                if (snapshot.hasError)
                  return Text("Erro ao carregar os dados!");
                QuerySnapshot querySnapshot = snapshot.data!;

                return ListView.builder(
                    itemCount: querySnapshot.docs.length,
                    itemBuilder: (_,index){

                      List<DocumentSnapshot> anuncios = querySnapshot.docs.toList();
                      DocumentSnapshot documentSnapshot = anuncios[index];
                      Anuncio anuncio = Anuncio.fromDocumentSnapshot(documentSnapshot);

                      return ItemAnuncio(
                        anuncio: anuncio,
                        onPressedRemover: (){
                          showDialog(
                              context: context,
                              builder: (context){
                                return AlertDialog(
                                  title: Text("Confirmar"),
                                  content: Text("Deseja realmente remover esse anúncio?"),
                                  actions: [

                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                                      onPressed: (){
                                          Navigator.of(context).pop();
                                        }, 
                                        child: Text(
                                          "Cancelar",
                                          style: TextStyle(
                                            color: Colors.white
                                          ),
                                        ),
                                    ),

                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                      onPressed: (){
                                        _removerAnuncio( anuncio.id );
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "Remover",
                                        style: TextStyle(
                                            color: Colors.white
                                        ),
                                      ),
                                    ),



                                  ],
                                );
                              }
                          );
                        },

                      );


                    }
                );

            }
            return Container();

          }
      ),

    );
  }
}

