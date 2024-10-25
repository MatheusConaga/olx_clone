import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/routeGenerator.dart';
import 'package:olx_clone/screens/login.dart';


void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Login(),
    initialRoute: Routes.home,
    onGenerateRoute: RouteGenerator.generateRoute,
  ));

}