import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:validadores/Validador.dart';

class Formularios extends StatefulWidget {
  const Formularios({super.key});

  @override
  State<Formularios> createState() => _FormulariosState();
}

class _FormulariosState extends State<Formularios> {

  final _formKey = GlobalKey<FormState>();
  String _mensagem = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Formulario"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              TextFormField(
                decoration: InputDecoration(
                  hintText: "Digite seu nome"
                ),
                validator: (valor){

                  return Validador()
                      .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                  .minLength(3, msg: "O nome deve possuir pelo menos 3 caracteres")
                      .valido(valor);

                },
              ),


              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: "Digite sua idade"
                ),
                validator: (valor){

                  return Validador()
                      .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                      .valido(valor);

                },
              ),

              TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CpfInputFormatter(),
                ],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: "Digite seu CPF"
                ),
                validator: (valor){

                  return Validador()
                      .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                      .add(Validar.CPF, msg: "CPF inválido")
                      .valido(valor);

                },
              ),

              ElevatedButton(
                child: Text("Salvar"),
                onPressed: () {
                    if( _formKey.currentState!.validate() ){

                    }
                },
              ),

              Text(
                _mensagem,
                style: TextStyle(
                  fontSize: 25
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
