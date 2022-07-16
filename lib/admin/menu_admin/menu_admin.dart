import 'package:allonsyapp/admin/menu_admin/pratos_admin.dart';
import 'package:allonsyapp/firebase/firebase_service.dart';
import 'package:allonsyapp/icons/salad1.dart';
import 'package:allonsyapp/inicio/loginpage.dart';
import 'package:allonsyapp/utils/nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

import 'package:google_fonts/google_fonts.dart';

class MenuAdmin extends StatefulWidget {

  @override
  _MenuAdminState createState() => _MenuAdminState();
}

class _MenuAdminState extends State<MenuAdmin> {

  String categoria ="entradas";

  var selectedItem = 0;

  List children = [
    PratosAdmin("entradas"),
    PratosAdmin("pratosprincipais"),
    PratosAdmin("sobremesas"),
    PratosAdmin("bebidas"),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1B1B1B),
        toolbarHeight: 60.h,
        leading: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: IconButton(
            icon: Icon(Icons.exit_to_app),
            iconSize: 32.sp,
            color: Colors.white,
            onPressed: (){
              FirebaseService().logout();
              push(context, LoginPage(), replace: true);
            },
          ),
        ),
        centerTitle: true,
        title: Text ("Allons-y",
          style: GoogleFonts.dancingScript(
              fontSize: 38.0.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.add,
                size: 32.sp,
                color: Colors.white),
            itemBuilder: (_)=> <PopupMenuItem<String>>[
              PopupMenuItem(
                padding: EdgeInsets.only(left: 10.w),
                child: Container(
                  child: Text(
                    "Entradas",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                        fontSize: 18.sp,
                        color: Colors.black
                    ),
                  ),
                ),
                value: "entradas",
              ),
              PopupMenuItem(
                padding: EdgeInsets.only(left: 10.w),
                child: Container(
                  child: Text(
                    "Principais",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                        fontSize: 18.sp,
                        color: Colors.black
                    ),
                  ),
                ),
                value: "principais",
              ),
              PopupMenuItem(
                padding: EdgeInsets.only(left: 10.w),
                child: Container(
                  child: Text(
                    "Sobremesas",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                        fontSize: 18.sp,
                        color: Colors.black
                    ),
                  ),
                ),
                value: "sobremesas",
              ),
              PopupMenuItem(
                padding: EdgeInsets.only(left: 10.w),
                child: Container(
                  child: Text(
                    "Bebidas",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                        fontSize: 18.sp,
                        color: Colors.black
                    ),
                  ),
                ),
                value: "bebidas",
              )
            ],
            onSelected: (index) async {
              switch(index) {
                case 'entradas':
                  setState(() {
                    selectedItem = 0;
                    categoria = "entradas";
                    FirebaseFirestore.instance.collection("pratos").doc().set({
                      "data": DateTime.now(),
                      "ativo":false,
                      "descricao":"Lorem ipsum dolor sit amet. At totam voluptatibus id quos quia ut consequuntur placeat hic beatae excepturi. Aut laborum quia vel quos nostrum ea amet maxime aut blanditiis suscipit 33 ullam cumque aut illo quia et quidem voluptatem",
                      "nome": "Nova Entrada",
                      "preco":9.99,
                      "tempo":25,
                      "url": "https://blog.bancadoramon.com.br/wp-content/uploads/2018/10/salada-grega-e1539208425134.jpg",
                      "categoria": "entradas",
                      "sugestao":false,
                      "subcategoria": "",
                    });
                  });
                  break;
                case 'principais':
                  setState(() {
                    selectedItem = 1;
                    categoria = "pratosprincipais";
                    FirebaseFirestore.instance.collection("pratos").doc().set({
                      "data": DateTime.now(),
                      "ativo":false,
                      "descricao":"Lorem ipsum dolor sit amet. At totam voluptatibus id quos quia ut consequuntur placeat hic beatae excepturi. Aut laborum quia vel quos nostrum ea amet maxime aut blanditiis suscipit 33 ullam cumque aut illo quia et quidem voluptatem",
                      "nome": "Prato Novo",
                      "preco": 29.99,
                      "tempo": 25,
                      "url": "https://vocegastro.com.br/app/uploads/2021/05/como-fazer-salmao-no-forno.jpg",
                      "categoria": "pratosprincipais",
                      "sugestao":false,
                      "subcategoria": "",
                    });
                  });
                  break;
                case 'sobremesas':
                  setState(() {
                    selectedItem = 2;
                    categoria = "sobremesas";
                    FirebaseFirestore.instance.collection("pratos").doc().set({
                      "data": DateTime.now(),
                      "ativo":false,
                      "descricao":"Lorem ipsum dolor sit amet. At totam voluptatibus id quos quia ut consequuntur placeat hic beatae excepturi. Aut laborum quia vel quos nostrum ea amet maxime aut blanditiis suscipit 33 ullam cumque aut illo quia et quidem voluptatem",
                      "nome": "Sobremesas Nova",
                      "preco": 12.99,
                      "tempo": 25,
                      "url": "https://img.itdg.com.br/tdg/images/recipes/000/014/338/319490/319490_original.jpg?w=1200",
                      "categoria": "sobremesas",
                      "sugestao":false,
                      "subcategoria": "",
                    });
                  });
                  break;
                case 'bebidas':
                  setState(() {
                    selectedItem = 3;
                    categoria = "bebidas";
                    FirebaseFirestore.instance.collection("pratos").doc().set({
                      "data": DateTime.now(),
                      "ativo":false,
                      "descricao":"Lorem ipsum dolor sit amet. At totam voluptatibus id quos quia ut consequuntur placeat hic beatae excepturi. Aut laborum quia vel quos nostrum ea amet maxime aut blanditiis suscipit 33 ullam cumque aut illo quia et quidem voluptatem",
                      "nome": "Nova bebida",
                      "preco": 5.99,
                      "tempo": 25,
                      "url": "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTrR0nLrYdS7hPJj-CS-Q1s4inYKLXiTx_fZqpNK9edVpWPrHUkXz1ekxaSU5cTqIrnTyA&usqp=CAU",
                      "categoria": "bebidas",
                      "subcategoria": "Cerveja",
                      "sugestao":false
                    });
                  });
                  break;
              }
            },
          ),
        ],
      ),
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
            child: children[selectedItem],
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
