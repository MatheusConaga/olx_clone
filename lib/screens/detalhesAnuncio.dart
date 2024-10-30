import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/models/anuncio.dart';
import 'package:url_launcher/url_launcher.dart';


class DetalhesAnuncio extends StatefulWidget {
  final Anuncio anuncio;

  DetalhesAnuncio({required this.anuncio, super.key});


  @override
  State<DetalhesAnuncio> createState() => _DetalhesAnuncioState();
}

class _DetalhesAnuncioState extends State<DetalhesAnuncio> {

  late Anuncio _anuncio;

  List<Widget> _getListaImagens(){

   List<String> listaUrlImagens = _anuncio.fotos;
   return listaUrlImagens.map((url){

     return Container(
       height: 250,
       decoration: BoxDecoration(
         image: DecorationImage(
             image: NetworkImage(url),
             fit: BoxFit.fitWidth,
         ),
       ),
     );

   }).toList();

  }


   _ligarTelefone( String telefone ) async {

     Uri url = Uri.parse("tel:$telefone");

     if (await canLaunchUrl(url)) {
       await launchUrl(url);
     } else {
       print("Não foi possível fazer a ligação");
     }

  }


  @override
  void initState() {
    super.initState();

    _anuncio = widget.anuncio;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Anúncio"),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              SizedBox(
                height: 250,
                child: _getListaImagens().length > 1
                    ? CarouselSlider(
                  disableGesture: true,
                  items: _getListaImagens(),
                  options: CarouselOptions(
                    // enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    autoPlay: true,
                  ),
                )
                : _getListaImagens().first,
              ),
              Container(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                     "${_anuncio.preco}",
                      style: TextStyle(
                        fontSize: 32,
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${_anuncio.titulo}",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),

                    Text(
                      "Descrição",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      "${_anuncio.descricao}",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Divider(),
                    ),

                    Text(
                      "Contato",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Padding(
                        padding: EdgeInsets.only(bottom: 66),
                      child: Text(
                        "${_anuncio.telefone}",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    
                  ],),
              ),
            ],),

          Positioned(
            left: 16,
              right: 16,
              bottom: 16,
              child: GestureDetector(
                onTap: (){
                  _ligarTelefone(_anuncio.telefone);
                },
                child: Container(
                  child: Text(
                      "Ligar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
                    ),
                  ),
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(30)
                  ),
                ),
                
              ),
          ),

        ],),
    );
  }
}
