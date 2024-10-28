import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/screens/anuncios.dart';
import 'package:olx_clone/screens/login.dart';
import 'package:olx_clone/screens/meusAnuncios.dart';
import 'package:olx_clone/screens/novoAnuncio.dart';

class RouteGenerator{

  static Route<dynamic> generateRoute (RouteSettings settings){

    final args = settings.arguments;

    switch ( settings.name ){

      case Routes.home:
        return MaterialPageRoute(
            builder: (_) => Anuncios()
        );
      case Routes.login:
        return MaterialPageRoute(
            builder: (_) => Login()
        );
      case Routes.meusAnuncios:
        return MaterialPageRoute(
            builder: (_) => MeusAnuncios()
        );
      case Routes.novoAnuncio:
        return MaterialPageRoute(
            builder: (_) => NovoAnuncio()
        );
      default:
        return _erroRota();
    }
  }

  static Route<dynamic> _erroRota(){
    
    return MaterialPageRoute(
        builder: (_){
          return Scaffold(
            appBar: AppBar(
              title: Text("Tela nao encontrada"),
            ),
            body: Center(
              child: Text("Tela nao encontrada"),
            ),
          );
        }
    );

  }

}

class Routes{

  static const String home = "/";
  static const String login = "/login";
  static const String meusAnuncios = "/meus-anuncios";
  static const String novoAnuncio = "/novo-anuncio";

}