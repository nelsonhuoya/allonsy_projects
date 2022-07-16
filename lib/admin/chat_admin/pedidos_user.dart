import 'package:allonsyapp/admin/pedidos_admin/pedidos_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PedidosUserAdmin extends StatefulWidget {
  final String email;
  final String user;

  PedidosUserAdmin(this.email, this.user);

  @override
  _PedidosUserAdminState createState() => _PedidosUserAdminState();
}

class _PedidosUserAdminState extends State<PedidosUserAdmin> {
  var selectedItem = 0;

  String filtro = "Todos";

  List <String> filtros = [
    'Todos',
    'Recebido',
    'Enviado',
    'Entregue',
    'Cancelado'
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1B1B1B),
        toolbarHeight: 60.h,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          iconSize: 32.sp,
          color: Colors.white,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text ("Pedidos do " + widget.user,
          style: GoogleFonts.dancingScript(
              fontSize: 35.0.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),),
      ),
      backgroundColor: Color(0xF7131313),
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: _situacao(),
          ),
          Flexible(
            flex: 10,
            child: Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: filtro == "Todos"? FirebaseFirestore.instance.collection('pedidos').where("email", isEqualTo: widget.email).orderBy("data", descending: true).snapshots() :
                FirebaseFirestore.instance.collection('pedidos').where("email", isEqualTo: widget.email).where("situacao", isEqualTo: filtro).orderBy("data", descending: true).snapshots(),
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
                          "O usuário ainda não tem pedidos",
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
            ),
          ),
        ],
      ),
    );
  }
  _situacao() {
    List <Situacao> situacao = [
      Situacao('Todos'),
      Situacao('Recebidos'),
      Situacao('Enviados'),
      Situacao('Entregues'),
      Situacao('Cancelados')
  ];

    return Container(
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: situacao.length,
          itemExtent: 105.w,
          itemBuilder: (context, int index){
            return _pedidos(situacao,index);
          }),
    );
  }

  _pedidos(List situacao, int index) {
    Situacao status = situacao[index];
    return GestureDetector(
      onTap: (){
        setState(() {
          selectedItem = index;
          filtro = (filtros[index]);
        });
        },
      child: Container(
        color: Color(0xFF1B1B1B),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.sp),
            color: Color(0xFF1B1B1B),
            border: Border.all(
                width:3,color: selectedItem == index? Color(0xFF03A9f4): Colors.transparent
            ),
          ),
          child: Center(
              child: Text(status.text,
                style: GoogleFonts.roboto(
                    fontSize: 18.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ),)
          ),
        ),
      ),
    );
  }
}

class Situacao {
  String text;
  Situacao(this.text);
}
