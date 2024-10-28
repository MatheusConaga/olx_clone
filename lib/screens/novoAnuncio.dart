import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx_clone/components/botaoCustomizado.dart';
import 'package:validadores/Validador.dart';

class NovoAnuncio extends StatefulWidget {
  const NovoAnuncio({super.key});

  @override
  State<NovoAnuncio> createState() => _NovoAnuncioState();
}

class _NovoAnuncioState extends State<NovoAnuncio> {
  List<File> _listaImagens = [];
  List<DropdownMenuItem<String>> _listaItensDropEstados = [];
  List<DropdownMenuItem<String>> _listaItensDropCategorias = [];
  String? _itemSelecionadoEstado;
  String? _itemSelecionadoCategoria;

  final _formKey = GlobalKey<FormState>();

  _selecionarImagemGaleria() async {
    XFile? itemSelecionada;

    itemSelecionada =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    File file = File(itemSelecionada!.path);

    if (file != null) {
      setState(() {
        _listaImagens.add(file);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _carregarItensDropdown();

  }

  _carregarItensDropdown(){

    _listaItensDropCategorias.add(
      DropdownMenuItem(
        child: Text("Automiauvel",),
        value: "auto",
      )
    );
    _listaItensDropCategorias.add(
        DropdownMenuItem(
          child: Text("Imovel",),
          value: "imovel",
        )
    );
    _listaItensDropCategorias.add(
        DropdownMenuItem(
          child: Text("Moda",),
          value: "moda",
        )
    );
    
    
    for (var estado in Estados.listaEstadosSigla){
      _listaItensDropEstados.add(
          DropdownMenuItem(child: Text(estado), value: estado,)
      );

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Adicionar novo anúncio"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FormField<List>(
                  initialValue: _listaImagens,
                  validator: (imagens) {
                    if (imagens?.length == 0) {
                      return "Necessário selecionar uma imagem!";
                    }
                    return null;
                  },
                  builder: (state) {
                    return Column(
                      children: [
                        Container(
                          height: 100,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _listaImagens.length + 1,
                              itemBuilder: (context, index) {
                                if (index == _listaImagens.length) {
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: GestureDetector(
                                      onTap: () {
                                        _selecionarImagemGaleria();
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.grey![400],
                                        radius: 50,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.add_a_photo,
                                              size: 40,
                                              color: Colors.grey![100],
                                            ),
                                            Text(
                                              "Adicionar",
                                              style: TextStyle(
                                                color: Colors.grey![100],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                if (_listaImagens.length > 0) {
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => Dialog(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Image.file(
                                                    _listaImagens[index]),
                                                ElevatedButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        _listaImagens
                                                            .removeAt(index);
                                                        Navigator.of(context)
                                                            .pop();
                                                      });
                                                    },
                                                    child: Text(
                                                      "Excluir",
                                                      style: TextStyle(
                                                          color: Colors.red,
                                                          fontSize: 14),
                                                    )),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage:
                                            FileImage(_listaImagens[index]),
                                        child: Container(
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.5),
                                          alignment: Alignment.center,
                                          child: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return Container();
                              }),
                        ),
                        if (state.hasError)
                          Container(
                            child: Text(
                              "[${state.errorText}]",
                              style: TextStyle(color: Colors.red, fontSize: 14),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                      padding: EdgeInsets.all(8),
                      child: DropdownButtonFormField(
                        value: _itemSelecionadoEstado,
                        hint: Text("Estados"),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20
                          ),
                          items: _listaItensDropEstados,
                          validator: (valor){
                            return Validador()
                                .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                                .valido(valor);
                          },
                          onChanged: (valor){
                            setState(() {
                              _itemSelecionadoEstado = valor;
                            });
                          },
                      ),
                        ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: DropdownButtonFormField(
                          value: _itemSelecionadoCategoria,
                          hint: Text("Categorias"),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20
                          ),
                          items: _listaItensDropCategorias,
                          validator: (valor){
                            return Validador()
                                .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                                .valido(valor);
                          },
                          onChanged: (valor){
                            setState(() {
                              _itemSelecionadoCategoria = valor;
                            });
                          },
                        ),
                      ),
                    ),


                  ],
                ),
                Text("Caixas de textos"),
                BotaoCustomizado(
                  corTexto: Colors.white,
                  texto: "Cadastrar anúncio",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {}
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
