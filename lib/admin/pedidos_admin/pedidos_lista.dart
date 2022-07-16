import 'package:allonsyapp/admin/pedidos_admin/pedidos_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';


class PedidosListaAdm extends StatefulWidget {
  String situacao;
  String filtro;
  bool numero;

  PedidosListaAdm(this.situacao, this.filtro, this.numero);

  @override
  State<PedidosListaAdm> createState() => _PedidosListaAdmState();
}

class _PedidosListaAdmState extends State<PedidosListaAdm> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xF7131313),
      body: StreamBuilder<QuerySnapshot>(
        stream:
        widget.filtro != ""? widget.situacao == "Todos"? FirebaseFirestore.instance.collection('pedidos').where(widget.numero == false? "email" : "numero", isGreaterThanOrEqualTo: widget.filtro).where(widget.numero == false? "email" : "numero", isLessThanOrEqualTo: widget.filtro + "\uf7ff" ).orderBy(widget.numero == false? "email" : "numero",descending: true).orderBy("data", descending: true).snapshots():
        FirebaseFirestore.instance.collection('pedidos').where(widget.numero == false? "email" : "numero", isGreaterThanOrEqualTo: widget.filtro).where(widget.numero == false? "email" : "numero", isLessThanOrEqualTo: widget.filtro + "\uf7ff" ).where("situacao", isEqualTo: widget.situacao).orderBy(widget.numero == false? "email" : "numero",descending: true).orderBy("data", descending: true).snapshots():
        widget.situacao != "Todos"? FirebaseFirestore.instance.collection('pedidos').where("situacao", isEqualTo: widget.situacao).orderBy("data", descending: true).snapshots() :
        FirebaseFirestore.instance.collection('pedidos').orderBy("data", descending: true).snapshots(),
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
          return Padding(
            padding: EdgeInsets.only(top: 5.h),
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index){
                  return PedidosCardAdmin(
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
                      snapshot.data!.docs.elementAt(index)["complemento"],
                      snapshot.data!.docs.elementAt(index)["email"]
                  );
                }
            ),
          );
        },
      ),
    );
  }
}