import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';

class Configuracoes{

  static List<DropdownMenuItem<String>> getCategorias(){

    List<DropdownMenuItem<String>> itensDropCategorias = [];

    itensDropCategorias.add(
        DropdownMenuItem(
          child: Text(
            "Categoria",
            style: TextStyle(
              color: Colors.purple
            ),
          ),
          value: null,
        )
    );

    itensDropCategorias.add(
        DropdownMenuItem(
          child: Text("Veiculo",),
          value: "auto",
        )
    );
    itensDropCategorias.add(
        DropdownMenuItem(
          child: Text("Imovel",),
          value: "imovel",
        )
    );

    itensDropCategorias.add(
        DropdownMenuItem(
          child: Text("Moda",),
          value: "moda",
        )
    );
    itensDropCategorias.add(
        DropdownMenuItem(
          child: Text("Livro",),
          value: "livro",
        )
    );

    return itensDropCategorias;

  }

  static List<DropdownMenuItem<String>> getEstados(){

    List<DropdownMenuItem<String>> listaItensDropEstados = [];

    listaItensDropEstados.add(
        DropdownMenuItem(
          child: Text(
            "Região",
            style: TextStyle(
                color: Colors.purple
            ),
          ),
          value: null,
        )
    );

    for (var estado in Estados.listaEstadosSigla) {
      listaItensDropEstados.add(
          DropdownMenuItem(child: Text(estado), value: estado,)
      );
    }

    return listaItensDropEstados;

  }



}
