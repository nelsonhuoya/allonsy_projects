import 'package:allonsyapp/pratos/bebidas.dart';
import 'package:allonsyapp/pratos/pratos_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:allonsyapp/icons/salad1.dart';

class MenuPage extends StatefulWidget {


  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {

  String categoria ="entradas";

  var selectedItem = 0;

  List children = [
    PratosPage("entradas"),
    PratosPage("pratosprincipais"),
    PratosPage("sobremesas"),
    BebidasPage(),
  ];

  String titulo = "Entradas";

  List <String> titulos = [
    'Entradas',
    'Pratos',
    'Sobremesas',
    'Bebidas'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xF7131313),
      body: _body(),
    );
  }

  _body() {

    return Column(
      children: [
        Flexible(
          flex: 1,
          child: _categorias()
        ),
        Flexible(
          flex:10,
          child: Container(
            child: Stack(
              children: [
                Container(
                  child: children[selectedItem],
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
                        color: Colors.black.withOpacity(0.5)
                    ),
                    width:160.w,
                    height: 50.h,
                    child: Container(
                      alignment: Alignment.topCenter,
                      child: Text(titulo,
                        style:GoogleFonts.dancingScript(
                          color: Colors.white,
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold
                        ),),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _categorias() {
    List <Categoria> categorias = [
      Categoria(Icon(Salad1.icone_salada_4,size: 42.sp,color: Colors.white), 'Entradas'),
      Categoria(Icon(Icons.local_dining,size: 32.sp,color: Colors.white,), 'Pratos'),
      Categoria(Icon(Icons.icecream,size: 32.sp,color: Colors.white,), 'Sobremesas'),
      Categoria(Icon(Icons.local_bar,size: 30.sp,color: Colors.white,), 'Bebidas'),
    ];

    return Container(
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categorias.length,
          itemExtent: 100.w,
          itemBuilder: (context, int index){
            return _cardapio(categorias,index);
          }),
    );
  }

  _cardapio(List categorias, int index) {
    Categoria categoria = categorias[index];

    return GestureDetector(
      onTap: (){
        setState(() {
          selectedItem = index;
          titulo = (titulos[index]);
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF1B1B1B),
          border: Border(
            bottom: BorderSide(width:3,color: selectedItem == index? Color(0xFF03A9f4): Colors.transparent)
          ),
        ),
        child: categoria.icon,
      ),
    );
  }
}

class Categoria {
  Icon icon;
  String text;

  Categoria(this.icon, this.text);
}




