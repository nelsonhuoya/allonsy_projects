import 'package:allonsyapp/admin/pedidos_admin/pedidos_lista.dart';
import 'package:allonsyapp/firebase/firebase_service.dart';
import 'package:allonsyapp/inicio/loginpage.dart';
import 'package:allonsyapp/utils/nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class PedidosAdmin extends StatefulWidget {


  @override
  _PedidosAdminState createState() => _PedidosAdminState();
}

class _PedidosAdminState extends State<PedidosAdmin> {

  String? email = FirebaseAuth.instance.currentUser!.email;

  bool search = false;

  bool numero = false;

  var selectedItem = 0;

  var _tUser = TextEditingController();

  List children = [
    "Recebido",
    "Enviado",
    "Entregue",
    "Cancelado",
    "Todos",
  ];

  String filtro ="";

  late FocusNode myFocusNode;

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

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
          IconButton(
            icon: Icon(Icons.search),
            iconSize: 32.sp,
            color: Colors.white,
            onPressed: (){
              setState(() {
                search == true? FocusScope.of(context).unfocus(): myFocusNode.requestFocus();
                search == false? search = true : search = false;
              });
            },
          ),
        ],
      ),
      backgroundColor: Color(0xF7131313),
      body: _body(),
    );
  }

  _body() {
    return SingleChildScrollView(
      child: Container(
        color: Color(0xFF1B1B1B),
        child: Column(
          children: [
            Container(
              height: 58.h,
              child: _situacao(),
            ),
            Container(
              child: Column(
                children: [
                  SizedBox(
                    height: search == false?0 : 10.h,
                  ),
                  Container(
                    height: search == false? 0 : 60.h,
                    child: TextFormField(
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 23.sp,
                      ),
                      controller: _tUser,
                      focusNode: myFocusNode,
                      onChanged: (String user) async {
                        setState(() {
                          filtro = _tUser.text;
                        });
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.sp),
                        prefixIcon: GestureDetector(
                          onTap: (){
                            setState(() {
                              numero == false? numero = true : numero = false;
                            });
                          },
                          child: Icon(search == false? null: numero == false? Icons.person : Icons.format_list_numbered, size: 32.sp,color: Color(0xFF03A9f4),
                          ),
                        ),
                        hoverColor: Color(0xFF1B1B1B),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            width: 3.w,
                            color: Color(0xFF03A9f4),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            width: 3.w,
                            color: search == false? Colors.transparent: Color(0xFF03A9f4),
                          ),
                        ),
                        labelText: numero == false? "Usuario" : "Pedido",
                        labelStyle: TextStyle(
                            fontSize: 23.sp,
                            color: Colors.grey.withOpacity(0.9)
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
                height: search == false? 564.h: 494.h,
                child: PedidosListaAdm(children[selectedItem], filtro, numero)
            ),
          ],
        ),
      ),
    );
  }

  _situacao() {
    List <Situacao>situacao = [
      Situacao('Recebidos'),
      Situacao('Enviados'),
      Situacao('Entregues'),
      Situacao('Cancelados'),
      Situacao('Todos')
    ];

    return Container(
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: situacao.length,
          itemExtent: 98.w,
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
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF1B1B1B),
          borderRadius: BorderRadius.circular(20.sp),
          border: Border.all(
              width:3,color: selectedItem == index? Color(0xFF03A9f4): Colors.transparent
          ),
        ),
        child: Center(
            child: Text(status.text,
            style: GoogleFonts.roboto(
              fontSize: 16.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),)
        ),
      ),
    );
  }
}

class Situacao {
  String text;
  Situacao(this.text);
}
