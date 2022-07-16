import 'package:allonsyapp/pratos/card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class PratosPage extends StatefulWidget {
  String categoria;

  PratosPage(this.categoria);

  @override
  _PratosPageState createState() => _PratosPageState();

}

class _PratosPageState extends State<PratosPage> {

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
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("pratos").where("categoria", isEqualTo: widget.categoria)
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
                child: CardPage(snapshot.data!.docs.elementAt(index)['url'],
                    snapshot.data!.docs.elementAt(index)['nome'],
                    snapshot.data!.docs.elementAt(index)['descricao'],
                    snapshot.data!.docs.elementAt(index)['preco'].toDouble(),
                    snapshot.data!.docs.elementAt(index)['tempo'],
                    snapshot.data!.docs.elementAt(index)['categoria'],
                    snapshot.data!.docs.elementAt(index)['data'].toDate(),
                    snapshot.data!.docs.elementAt(index)['sugestao'],
                ),

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


