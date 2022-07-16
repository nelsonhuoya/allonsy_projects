import 'package:allonsyapp/pratos/pratosdetalhes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../utils/nav.dart';

class BebidasListaPage extends StatefulWidget {

  final String subcategoria;


  BebidasListaPage(this.subcategoria);



  @override
  State<BebidasListaPage> createState() => _BebidasListaPageState();
}

class _BebidasListaPageState extends State<BebidasListaPage> {

  bool hasInternet = true;

  @override
  void initState(){
    if (mounted) {
      super.initState();
      InternetConnectionChecker().onStatusChange.listen((status) {
        final hasInternet = status == InternetConnectionStatus.connected;
        setState(() => this.hasInternet = hasInternet);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xF7131313),
      body: _body(),
      appBar: AppBar(
        toolbarHeight: 60.h,
        backgroundColor: Color(0xFF1B1B1B),
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.only(bottom: 8.0.h, top: 8.0.h, left: 8.w, right: 8.w),
          child: GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 32.sp,
            ),
          ),
        ),
        title: Text ( widget.subcategoria == "Cerveja"? "Cervejas": widget.subcategoria == "Refrigerante"? "Refrigerantes" :  widget.subcategoria == "Vinho"? "Vinhos" : widget.subcategoria == "Suco"? "Sucos" : "Outros",
          style: GoogleFonts.dancingScript(
              fontSize: 45.0.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),),
      ),
    );
  }

  _body() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("pratos").where("subcategoria", isEqualTo: widget.subcategoria)
          .where("ativo", isEqualTo: true).orderBy("sugestao",descending: true).orderBy("data", descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.hasError) {
          return Center(
            child: Text(
              "Não foi possível carregar o menu",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 22.sp
              ),
            ),
          );
        }
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return hasInternet == true? ListView.builder(
            scrollDirection: Axis.vertical,
            itemExtent: 240.h,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index){
              return Container(
                child: GestureDetector(
                  onTap: (){
                    push(context, PratosDetalhesPage(
                      snapshot.data!.docs.elementAt(index)['nome'],
                        snapshot.data!.docs.elementAt(index)['url'],
                      snapshot.data!.docs.elementAt(index)['preco'],
                        snapshot.data!.docs.elementAt(index)['descricao'],
                      snapshot.data!.docs.elementAt(index)['tempo'],
                      snapshot.data!.docs.elementAt(index)['categoria'],
                    ));
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 15.h, left: 8.w, right: 8.w),
                    child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.sp),
                                image: DecorationImage(
                                    colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3),BlendMode.darken),
                                    image: NetworkImage(snapshot.data!.docs.elementAt(index)['url']),fit: BoxFit.cover
                                ),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black87,
                                      blurRadius: 4,
                                      offset: Offset(5,10)
                                  )
                                ]
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10.sp),
                                        gradient: LinearGradient(
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight,
                                            stops: [
                                              0.5,
                                              0.9
                                            ],
                                            colors:[
                                              Color(0xFF03A9f4).withOpacity(0.7),
                                              Colors.transparent
                                            ]
                                        )
                                    ),
                                    height: 40.h,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding:EdgeInsets.only(left: 8.0),
                                    child: Text(snapshot.data!.docs.elementAt(index)['nome'],
                                        style: GoogleFonts.dancingScript(
                                            color: Colors.white,
                                            fontSize: 30.sp,
                                            fontWeight: FontWeight.bold
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Padding(
                              padding: EdgeInsets.only(bottom:3.0.h,right:2.0.w),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                    color: Color(0xFF03A9f4).withOpacity(0.8),
                                    boxShadow: [BoxShadow(
                                        color: Colors.black87,
                                        blurRadius: 4,
                                        offset: Offset(4,4)
                                    )
                                    ]
                                ),
                                height: 35.h,
                                width: 95.w,
                                child: Center(
                                  child: Text(
                                    "R\$"+snapshot.data!.docs.elementAt(index)['preco'].toStringAsFixed(2),
                                    style: GoogleFonts.roboto(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]
                    ),
                  ),
                )
              );
            }
        ):Center(
          child: Text(
            "Não foi possível carregar o menu. Verifique sua conexão",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.red,
                fontSize: 22.sp
            ),
          ),
        );
      },
    );
  }
}

