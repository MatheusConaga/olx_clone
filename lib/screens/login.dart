import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:olx_clone/components/inputCustomizado.dart';
import 'package:olx_clone/models/usuario.dart';
import 'package:olx_clone/routeGenerator.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController _emailController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();

  bool _cadastrar = false;
  String _mensagemErro = "";

  _cadastrarUsuario( Usuario usuario ) async{

    FirebaseAuth auth = FirebaseAuth.instance;

    await auth.createUserWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha
    ).then((UserCredential userCredential){



    });

  }

  _logarUsuario( Usuario usuario ){

    FirebaseAuth auth = FirebaseAuth.instance;

    auth.signInWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha
    ).then((UserCredential userCredential){

      Navigator.pushNamedAndRemoveUntil(context, Routes.home, (_) => false);


    });

  }

  _validarCampos(){

    String email = _emailController.text;
    String senha = _senhaController.text;

    if (email.isNotEmpty && email.contains("@")){
      if(senha.isNotEmpty && senha.length >= 8){

        // Configurar Usuario
        Usuario usuario = Usuario();
        usuario.email = email;
        usuario.senha = senha;


        if (_cadastrar ){

          _cadastrarUsuario( usuario );

        } else {

          _logarUsuario( usuario );

        }

      } else{
        setState(() {
          _mensagemErro = "Preencha a senha com pelo menos 8 caracteres";
        });
      }

    } else{
      setState(() {
        _mensagemErro = "Preencha o E-mail válido";
      });
    }



  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
      ),

      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 32),
                    child: Image.asset(
                        "assets/images/logo.png",
                      width: 200,
                      height: 150,
                    ),
                  ),
                InputCustomizado(
                    controller: _emailController,
                    hint: "Insira o email",
                  icon: Icon(Icons.email),
                  type: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 10,
                ),
                InputCustomizado(
                    controller: _senhaController,
                    hint: "Insira a senha",
                  icon: Icon(Icons.lock),
                  obscure: true,
                ),


                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Logar"),
                    Switch(
                        value: _cadastrar,
                        onChanged: (bool valor){
                          setState(() {
                              _cadastrar = valor;
                          });
                        }
                    ),
                    Text("Cadastrar"),
                  ],
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      padding: EdgeInsets.fromLTRB(20, 16, 20, 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                    onPressed: (){
                      _validarCampos();
                    },
                    child: _cadastrar ?
                    Text(
                      "Cadastrar",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        fontSize: 16
                      ),
                    ) : Text(
                        "Entrar",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                        )
                    ),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 30),
                  child: Center(
                    child: GestureDetector(
                      child: Text(
                          "Ir para tela de Anuncios",
                        style: TextStyle(
                          color: Colors.purple,
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      onTap: (){
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          Routes.home,
                              (_) => false,
                        );
                      },
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    _mensagemErro,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),

    );
  }
}
