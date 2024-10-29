import 'package:flutter/material.dart';
import 'package:olx_clone/models/anuncio.dart';

class ItemAnuncio extends StatelessWidget {
  ItemAnuncio({
    required this.anuncio,
    this.onTapItem,
    this.onPressedRemover,
    super.key
  });


  Anuncio anuncio;
  Function()? onTapItem;
  Function()? onPressedRemover;



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTapItem,
      child: Card(
        child: Padding(
            padding: EdgeInsets.all(12),
          child: Row(
            children: [

              SizedBox(
                width: 120,
                height: 120,
                child: Image.network(
                  anuncio.fotos[0],
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                  flex: 3,
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                       anuncio.titulo,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Text(
                          anuncio.preco,
                        ),
                      ],
                    ),
                  ),
              ),
              if(this.onPressedRemover != null ) Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                      onPressed: this.onPressedRemover,
                      child: Icon(Icons.delete,color: Colors.white,)
                  ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
