import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/outrosConhecimentos/formularios.dart';
import 'package:olx_clone/outrosConhecimentos/mascaras.dart';
import 'package:olx_clone/routeGenerator.dart';
import 'package:olx_clone/screens/anuncios.dart';
import 'package:olx_clone/screens/login.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Formularios(),
    title: "OLX",
    initialRoute: "/",
    onGenerateRoute: RouteGenerator.generateRoute,
  ));

}