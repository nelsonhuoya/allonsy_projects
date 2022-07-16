import 'package:allonsyapp/admin/menu_admin/card_admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PratosAdmin extends StatefulWidget {
  String categoria;
  
  
  PratosAdmin(this.categoria);


  @override
  _PratosAdminState createState() => _PratosAdminState();
}

class _PratosAdminState extends State<PratosAdmin> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("pratos").where("categoria",isEqualTo: widget.categoria).orderBy("ativo", descending: true).orderBy("nome").snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if(snapshot.hasError) {
          return Center(
            child: Text(
              "Não foi possível carregar o menu",
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
        return ListView.builder(
            scrollDirection: Axis.vertical,
            itemExtent: 240.h,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index){
              return Container(
                child: CardPratoAdmin(snapshot.data!.docs.elementAt(index)['url'],
                    snapshot.data!.docs.elementAt(index)['nome'],
                    snapshot.data!.docs.elementAt(index)['descricao'],
                    snapshot.data!.docs.elementAt(index)['preco'],
                    snapshot.data!.docs.elementAt(index)['tempo'],
                    snapshot.data!.docs.elementAt(index)['ativo'],
                    widget.categoria,
                    snapshot.data!.docs.elementAt(index).id,
                    snapshot.data!.docs.elementAt(index)['sugestao'],
                    snapshot.data!.docs.elementAt(index)['subcategoria'],
                    snapshot.data!.docs.elementAt(index)["data"]),
              );
            }
        );
      },
    );
  }
}
