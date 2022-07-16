import 'package:allonsyapp/endereco/endereco_card.dart';
import 'package:allonsyapp/endereco/endereco.dart';
import 'package:allonsyapp/inicio/background.dart';
import 'package:allonsyapp/utils/nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EnderecoListaPage extends StatelessWidget {

  final user = FirebaseAuth.instance.currentUser;

  final String lastroute;

  bool? drawer;

  EnderecoListaPage({required this.lastroute, this.drawer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
      backgroundColor: Color(0xF7131313),
      appBar: AppBar(
        toolbarHeight: 60.h,
        centerTitle: true,
        leading: Padding(
          padding: EdgeInsets.only(bottom: 8.0.h, top: 8.0.h, left: 8.w, right: 8.w),
          child: GestureDetector(
            onTap: (){
              if(drawer == true){
                BackGroundPage();
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 32.sp,
            ),
          ),
        ),
        backgroundColor: Color(0xFF1B1B1B),
        title: Text("Endereços",
          style: GoogleFonts.dancingScript(
              fontSize: 40.0.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 8.0.w, bottom: 8.0.h, top: 8.0.h, left: 8.w),
            child: GestureDetector(
              onTap: (){
                push(context, EnderecoPage(lastroute: lastroute, cidade: '', rua: '', complemento: '', bairro: '', numero: '', CEP: '',atualizacao: false));
              },
              child: Icon(
                Icons.add,
                size: 32.sp,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  _body() {
    return Padding(
      padding: EdgeInsets.only(top:10.h),
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("users").doc(user!.email).collection("endereços").orderBy("ativo", descending: true).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.hasError) {
              return Center(
                child: Text(
                  "Não foi possível carregar os endereços",
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
            return Container(
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index){
                    return GestureDetector(
                      onTap: (){
                        push(context, EnderecoPage(lastroute: lastroute,rua: snapshot.data!.docs.elementAt(index)['rua'], CEP: snapshot.data!.docs.elementAt(index)['CEP'],
                            bairro: snapshot.data!.docs.elementAt(index)['bairro'], cidade: snapshot.data!.docs.elementAt(index)['cidade'],
                            complemento: snapshot.data!.docs.elementAt(index)['complemento'], numero: snapshot.data!.docs.elementAt(index)['numero'],
                            id: snapshot.data!.docs[index].id,
                            atualizacao: true));
                      },
                      child: EnderecoCard(snapshot.data!.docs.elementAt(index)['rua'],
                        snapshot.data!.docs.elementAt(index)['CEP'],
                        snapshot.data!.docs.elementAt(index)['bairro'],
                        snapshot.data!.docs.elementAt(index)['cidade'],
                        snapshot.data!.docs.elementAt(index)['complemento'],
                        snapshot.data!.docs.elementAt(index)['numero'],
                        snapshot.data!.docs[index].id,
                        snapshot.data!.docs.elementAt(index)['ativo']),
                    );
                  }),
            );
          }),
    );
  }
}
