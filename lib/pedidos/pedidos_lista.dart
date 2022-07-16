import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:allonsyapp/pedidos/pedidos_card.dart';
import 'package:google_fonts/google_fonts.dart';




class PedidosPage extends StatefulWidget {


  @override
  State<PedidosPage> createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {

  final email = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xF7131313),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('pedidos').where("email", isEqualTo: email).orderBy("data", descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.hasError) {
            return Center(
              child: Text(
                "Não foi possível carregar os pedidos",
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
          if(snapshot.data!.docs.length<1){
            return Center(
              child: Text(
                "Você ainda não tem pedidos",
                style: GoogleFonts.roboto(
                  fontSize: 22.sp,
                    color: Color(0xFF03A9f4)
                ),
              )
            );
          }
          return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index){
                return Container(
                  child: PedidosCard(
                      snapshot.data!.docs.elementAt(index)["data"].toDate(),
                      snapshot.data!.docs.elementAt(index)["numero"],
                      snapshot.data!.docs.elementAt(index)["qtditens"],
                      snapshot.data!.docs.elementAt(index)["qtdprimeiroprato"],
                      snapshot.data!.docs.elementAt(index)["primeiroprato"],
                      snapshot.data!.docs.elementAt(index)["retirada"],
                      snapshot.data!.docs.elementAt(index)["situacao"],
                      snapshot.data!.docs.elementAt(index)["timer"],
                      snapshot.data!.docs[index].id,
                      snapshot.data!.docs.elementAt(index)["endereco"],
                      snapshot.data!.docs.elementAt(index)["complemento"]
                  ),
                );
              }
          );
        },
      ),
    );
  }
}

