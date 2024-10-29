import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olx_clone/components/botaoCustomizado.dart';
import 'package:olx_clone/components/inputCustomizado.dart';
import 'package:olx_clone/models/anuncio.dart';
import 'package:olx_clone/routeGenerator.dart';
import 'package:olx_clone/utils/configuracoes.dart';
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
  TextEditingController _tituloController = TextEditingController();
  TextEditingController _precoController = TextEditingController();
  TextEditingController _telefoneController = TextEditingController();
  TextEditingController _descricaoController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  late Anuncio _anuncio;
  late BuildContext _dialogContext;

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
   _anuncio = Anuncio.gerarId();

  }

  _carregarItensDropdown() {

    _listaItensDropCategorias = Configuracoes.getCategorias();

    _listaItensDropEstados = Configuracoes.getEstados();

  }
  _salvarAnuncio() async{

    _abrirDialog( _dialogContext );
    await _uploadImagens();
    
    print("lista imagens: ${_anuncio.fotos.toString()}");

    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser;
    String idUsuarioLogado = usuarioLogado!.uid;
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("meus_anuncios")
    .doc(idUsuarioLogado)
    .collection("anuncios")
    .doc(_anuncio.id)
    .set(_anuncio.toMap()).then((_){

      // Salvar anuncio publico
      db.collection("anuncios")
      .doc( _anuncio.id )
      .set(_anuncio.toMap()).then((_){

        Navigator.pop(_dialogContext);
        Navigator.pop(context);

      });

    });

  }

  _abrirDialog( BuildContext context ){

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: ( BuildContext context ){
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20,),
                Text("Salvando anúncio..."),
              ],
            ),
          );
        }
    );


  }

  Future _uploadImagens() async{

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference raiz = storage.ref();

    for ( var imagem in _listaImagens  ){

      String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();
      Reference arquivo = raiz
          .child("meus_anuncios")
          .child(_anuncio.id)
          .child(nomeImagem);

      UploadTask uploadTask = arquivo.putFile(imagem);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete((){

      });

      String url = await taskSnapshot.ref.getDownloadURL();
      _anuncio.fotos.add(url);

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
                                          builder: (context) =>
                                              Dialog(
                                                child: Column(
                                                  mainAxisSize: MainAxisSize
                                                      .min,
                                                  children: [
                                                    Image.file(
                                                        _listaImagens[index]),
                                                    ElevatedButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            _listaImagens
                                                                .removeAt(
                                                                index);
                                                            Navigator.of(
                                                                context)
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
                          onSaved: (estado){
                            _anuncio.estado = estado!;
                          },
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20
                          ),
                          items: _listaItensDropEstados,
                          validator: (valor) {
                            return Validador()
                                .add(
                                Validar.OBRIGATORIO, msg: "Campo obrigatório")
                                .valido(valor);
                          },
                          onChanged: (valor) {
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
                          onSaved: (categoria){
                            _anuncio.categoria = categoria!;
                          },
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20
                          ),
                          items: _listaItensDropCategorias,
                          validator: (valor) {
                            return Validador()
                                .add(
                                Validar.OBRIGATORIO, msg: "Campo obrigatório")
                                .valido(valor);
                          },
                          onChanged: (valor) {
                            setState(() {
                              _itemSelecionadoCategoria = valor;
                            });
                          },
                        ),
                      ),
                    ),


                  ],
                ),

               Padding(
                   padding: EdgeInsets.only(bottom: 15, top: 15),
                 child: InputCustomizado(
                   controller: _tituloController,
                   hint: "Título",
                   onSaved: (titulo){
                     _anuncio.titulo = titulo!;
                   },
                   validator: (valor){
                     return Validador()
                         .add(Validar.OBRIGATORIO,msg: "Campo obrigatório")
                         .valido(valor);
                   },
                 ),
               ),

                Padding(
                  padding: EdgeInsets.only(bottom: 15,),
                  child: InputCustomizado(
                    controller: _precoController,
                    hint: "Preço",
                    onSaved: (preco){
                      _anuncio.preco = preco!;
                    },
                    type: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      RealInputFormatter(moeda: true),
                    ],
                    validator: (valor){
                      return Validador()
                          .add(Validar.OBRIGATORIO,msg: "Campo obrigatório")
                          .valido(valor);
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 15,),
                  child: InputCustomizado(
                    controller: _telefoneController,
                    hint: "Telefone",
                    onSaved: (telefone){
                      _anuncio.telefone = telefone!;
                    },
                    type: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      TelefoneInputFormatter(),
                    ],
                    validator: (valor){
                      return Validador()
                          .add(Validar.OBRIGATORIO,msg: "Campo obrigatório")
                          .valido(valor);
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: InputCustomizado(
                    controller: _descricaoController,
                    hint: "Descrição (200 caracteres)",
                    onSaved: (descricao){
                      _anuncio.descricao = descricao!;
                    },
                    maxLines: null,
                    validator: (valor){
                      return Validador()
                          .add(Validar.OBRIGATORIO,msg: "Campo obrigatório")
                      .maxLength(200, msg: "Maximo de 200 caracteres")
                          .valido(valor);
                    },
                  ),
                ),

                BotaoCustomizado(
                  corTexto: Colors.white,
                  texto: "Cadastrar anúncio",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {

                      //salvar campos
                      _formKey.currentState?.save();

                      // configura contexto do dialog
                      _dialogContext = context;

                      // salvar anuncio
                      _salvarAnuncio();
                    }
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
