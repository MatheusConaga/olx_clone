import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Mascaras extends StatefulWidget {
  const Mascaras({super.key});

  @override
  State<Mascaras> createState() => _MascarasState();
}

class _MascarasState extends State<Mascaras> {

  TextEditingController _cpfController = TextEditingController();
  TextEditingController _moedaController = TextEditingController();

  String _valorRecuperado = "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mascaras e Validacoes"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _cpfController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Digite o CPF",
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CnpjInputFormatter(),
              ],
            ),

            TextField(
              controller: _moedaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "Insira um valor em real",
              ),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                RealInputFormatter(moeda: true),
              ],
            ),

            ElevatedButton(
                onPressed: (){
                  setState(() {
                      _valorRecuperado = _moedaController.text.toString();
                  });
                  },
                child: Text("Recuperar valor")
            ),

            Text(
              "Valor: ${_valorRecuperado}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

          ],
        ),
      ),
    );
  }
}
