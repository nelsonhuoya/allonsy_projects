import 'package:allonsyapp/pedidos/pedidoaberto_lista.dart';
import 'package:allonsyapp/utils/nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class PratosDetalhesPage extends StatefulWidget {

  final String nome;
  final String img;
  final double preco;
  final String text;
  final int tempo;
  final String categoria;

  PratosDetalhesPage(this.nome, this.img, this.preco, this.text, this.tempo, this.categoria);


  @override
  _PratosDetalhesPageState createState() => _PratosDetalhesPageState();
}

class _PratosDetalhesPageState extends State<PratosDetalhesPage> {

  final user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  final _tObservacao = TextEditingController();

  getData() async {
    return await FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xF7131313),
      appBar: AppBar(
        toolbarHeight: 60.h,
        leadingWidth: 50.w,
        leading: GestureDetector(
          onTap: (){
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: Container(
              width: 20.sp,
              height: 20.sp,
              decoration: BoxDecoration(
                color: Color(0xFF03A9f4),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 32.sp,
                ),
              ),
            ),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: _body(),
    );
  }

  _body() {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 350.h,
                decoration: BoxDecoration(
                 image: DecorationImage(
                     colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2),BlendMode.darken),
                     image: NetworkImage(widget.img),fit: BoxFit.cover
                 ),
               ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top:320.h),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2.sp,
                  color: Colors.white.withOpacity(0.8)
                ),
                color: Color(0xF7131313),
                  borderRadius: BorderRadius.circular(40)
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 8.0.h, left: 15.w, right: 15.w
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 5.h
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      height: 40.h,
                      child: Text(
                        widget.nome,
                        style: GoogleFonts.roboto(
                          fontSize: 30.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Container(
                      child: Column(
                        children: [
                          widget.tempo>0?
                          Row(
                            children: [
                              Container(
                                alignment: Alignment.centerLeft,
                                width: 40.w,
                                child: Icon(
                                  Icons.watch_later_outlined,
                                  color: Color(0xFF03A9f4),
                                  size: 32.sp,
                                ),
                              ),
                              Container(
                                width: 100.w,
                                child: Text(
                                  widget.tempo.toString()+" min",
                                  style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: 26.sp
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment.centerRight,
                                width: 214.w,
                                child: Text(
                                  "R\$"+widget.preco.toStringAsFixed(2),
                                  style: GoogleFonts.roboto(
                                      color: Color(0xFF03A9f4),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 32.sp
                                  ),
                                ),
                              ),
                            ],
                          ):
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "R\$"+widget.preco.toStringAsFixed(2),
                              style: GoogleFonts.roboto(
                                  color: Color(0xFF03A9f4),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 32.sp
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      height: 142.h,
                      child: Text(
                        widget.text,
                        textAlign: TextAlign.justify,
                        style: GoogleFonts.roboto(
                            fontSize: 20.sp,
                            color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Container(
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  flex:1,
                                  child: Container(
                                    child: Text(
                                      "Observações:",
                                      style: GoogleFonts.roboto(
                                          fontSize: 22.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            alignment: Alignment.centerLeft,
                            height: 30.h,
                          ),
                          Container(
                            padding: EdgeInsets.only(top:15.h),
                            height: 90.h,
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                textCapitalization: TextCapitalization.sentences,
                                controller: _tObservacao,
                                style: GoogleFonts.roboto(
                                    color: Colors.white,
                                    fontSize: 20.sp
                                ),
                                decoration: InputDecoration(
                                    labelText: "Alguma observação no seu pedido?",
                                    labelStyle: GoogleFonts.roboto(
                                        color: Colors.grey.withOpacity(0.5),
                                        fontSize: 20.sp
                                    ),
                                    fillColor: Colors.white,
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                      borderSide: BorderSide(
                                        color: Color(0xFF03A9f4),
                                        width: 2.sp,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25),
                                        borderSide: BorderSide(
                                          color: Color(0xFF03A9f4),
                                          width: 2.sp,
                                        )
                                    )
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    GestureDetector(
                      onTap: (){
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();
                        }
                        FirebaseFirestore.instance.collection("pedidosemaberto").doc(user?.email)
                            .collection("pedidosemaberto").doc().set({
                          'nome': widget.nome,
                          'qtd':1,
                          'url':widget.img,
                          'preco':widget.preco,
                          'total': widget.preco,
                          'observacao': _tObservacao.text.trim(),
                          'categoria': widget.categoria
                        });
                        push(context,PedidoabertoPage());
                      },
                      child: Container(
                        height: 60.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xFF03A9f4)
                        ),
                        child: Center(
                          child: Text(
                            "Adicionar à pedido",
                            style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 26.sp,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
