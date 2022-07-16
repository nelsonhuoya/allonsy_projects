import 'dart:math';
import 'package:allonsyapp/pedidos/pedidoaberto_lista.dart';
import 'package:allonsyapp/pedidos/pedidos_lista.dart';
import 'package:allonsyapp/pratos/menu.dart';
import 'package:allonsyapp/reservas/reservas_lista.dart';
import 'package:allonsyapp/inicio/sobrenos.dart';
import 'package:allonsyapp/utils/nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class HomePage extends StatefulWidget {

  final String? index;

  HomePage({this.index});

  @override
  _HomePageState createState() => _HomePageState();
}

var scaffoldKey = GlobalKey<ScaffoldState>();

class _HomePageState extends State<HomePage> {

  String? email = FirebaseAuth.instance.currentUser!.email;


  List children = [
    MenuPage(),
    ReservaListaPage(),
    PedidosPage(),
    SobrenosPage()
  ];

  List children2 = [
    MenuPage(),
    PedidosPage(),
    SobrenosPage()
  ];

  var scaffoldKey = GlobalKey<ScaffoldState>();

  double value = 0;

  var selectedItem = 0;

  var selectedItem2 = 2;

  var selectedItem1 = 1;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: value),
        duration: Duration(milliseconds: 500),
        builder: (_, double val, __){
      return Transform(
        alignment: Alignment.center,
          transform: Matrix4.identity()
          ..setEntry(3,2, 0.001)
          ..setEntry(0, 3, 200.sp * val)
          ..rotateY((pi/5.sp) * val),
      child: Scaffold(
        backgroundColor: Color(0xF7131313),
        key: scaffoldKey,
        appBar: AppBar(
          toolbarHeight: 60.h,
          leading: IconButton(
            icon: Icon(Icons.dehaze_rounded),
            iconSize: 32.sp,
            color: Colors.white,
            onPressed: (){
              scaffoldKey.currentState!.openDrawer();
              setState(() {
                value == 0? value = 1 : value= 0;
              });
            },
          ),
          backgroundColor: Color(0xFF1B1B1B),
          centerTitle: true,
          title: Text ("Allons-y",
            style: GoogleFonts.dancingScript(
                fontSize: 38.0.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold
            ),),
          actions: [
            StreamBuilder<QuerySnapshot>(
              stream: (
                FirebaseFirestore.instance.collection("pedidosemaberto").
                doc(email).collection("pedidosemaberto").snapshots()),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                 if(!snapshot.hasData){
                  return Text("");
                 }
                 if(snapshot.data!.docs.length<1){
                   return Container(
                     color: Color(0xFF1B1B1B),
                     width: 50.w,
                   );
                 }
                 return GestureDetector(
                   onTap: (){
                     push(context, PedidoabertoPage());
                   },
                   child: Stack(
                     children: [
                       Padding(
                         padding: EdgeInsets.only(right: 20.w),
                         child: Center(
                           child: Container(
                             child: Icon(
                               Icons.local_grocery_store,
                               size: 32.sp,
                             ),
                           ),
                         ),
                       ),
                       Positioned(
                         left: 22.w,
                         bottom: 34.h,
                         child: Container(
                           width: 20.sp,
                           height: 20.sp,
                           decoration: BoxDecoration(
                               shape: BoxShape.circle,
                               color: Colors.red
                           ),
                           child: Padding(
                             padding: EdgeInsets.only(top:2.w,right: 1),
                             child: Align(
                               alignment: Alignment.center,
                               child: Text(
                                 snapshot.data!.docs.length.toString(),
                                 style: GoogleFonts.roboto(
                                     fontSize: 14.sp,
                                     color: Colors.white,
                                     fontWeight: FontWeight.bold
                                 ),
                               ),
                             ),
                           ),
                         ),
                       ),
                     ],
                   ),
                 );
                })
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("funcionamento").snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.hasError) {
              return Center(
                child: Text(
                  "Não foi possível carregar as datas",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 22.sp
                  ),
                ),
              );
            } if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if(snapshot.data!.docs.elementAt(2)["reservas"] == false){
             return _body2();
            }
            return _body();
          },
        ),
        bottomNavigationBar: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection("funcionamento").snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(snapshot.hasError) {
              return Center(
                child: Text(
                  "Não foi possível carregar as datas",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 22.sp
                  ),
                ),
              );
            } if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if(snapshot.data!.docs.elementAt(2)["reservas"] == true){
              return BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Color(0xFF1B1B1B),
                selectedItemColor: Color(0xFF03A9f4),
                iconSize: 27.0.sp,
                currentIndex: widget.index == "reservas"? selectedItem1: widget.index == "pedidos"? selectedItem2 :selectedItem,
                unselectedLabelStyle: GoogleFonts.dancingScript(fontSize: 20.0.sp,color: Color(0xFF1B1B1B)),
                selectedLabelStyle: GoogleFonts.dancingScript(fontSize: 20.0.sp,
                    fontWeight: FontWeight.w600),
                unselectedItemColor: Color(0xFF888888),
                onTap: (currentIndex) {
                  setState(() {
                    selectedItem1 = currentIndex;
                    selectedItem = currentIndex;
                    selectedItem2 = currentIndex;
                  });
                },
                items:  [
                  _bottomNavigationBarItem('Cardápio',Icon(Icons.home,size: 30.sp)),
                  _bottomNavigationBarItem('Reservas',Icon(Icons.event_available, size:30.sp)),
                  _bottomNavigationBarItem('Pedidos',Icon(Icons.shopping_bag, size:30.sp)),
                  _bottomNavigationBarItem('Sobre Nós',Icon(Icons.import_contacts,size:30.sp)),
                ],
              );
            }
            return BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Color(0xFF1B1B1B),
              selectedItemColor: Color(0xFF03A9f4),
              iconSize: 27.0.sp,
              currentIndex: widget.index == "pedidos"? selectedItem1 :selectedItem,
              unselectedLabelStyle: GoogleFonts.dancingScript(fontSize: 20.0.sp,color: Color(0xFF1B1B1B)),
              selectedLabelStyle: GoogleFonts.dancingScript(fontSize: 20.0.sp,
                  fontWeight: FontWeight.w600),
              unselectedItemColor: Color(0xFF888888),
              onTap: (currentIndex) {
                setState(() {
                  selectedItem1 = currentIndex;
                  selectedItem = currentIndex;
                });
              },
              items:  [
                _bottomNavigationBarItem('Cardápio',Icon(Icons.home,size: 30.sp)),
                _bottomNavigationBarItem('Pedidos',Icon(Icons.shopping_bag, size:30.sp)),
                _bottomNavigationBarItem('Sobre Nós',Icon(Icons.import_contacts,size:30.sp)),
              ],
            );
          },
        ),
      )
          );
    });
  }

  BottomNavigationBarItem _bottomNavigationBarItem(String text, Icon icon) {
    return BottomNavigationBarItem(
            icon: icon,
            backgroundColor: Color(0xFF1B1B1B),
            label:text
        );
  }

  _body() {
    if (value == 0){
      return Container(
        child: widget.index == "reservas"? children[selectedItem1] : widget.index == "pedidos"? children[selectedItem2]: children[selectedItem],
      );
    } return Stack(
      children: [
        widget.index == "reservas"? children[selectedItem1] : widget.index == "pedidos"? children[selectedItem2]: children[selectedItem],
        GestureDetector(
          onTap: (){
            scaffoldKey.currentState!.openDrawer();
            setState(() {
              value == 0? value = 1 : value= 0;
            });
          },
          child: Scaffold(
            backgroundColor: Colors.black.withOpacity(0.1),
          ),
        )
      ],
    );
  }

  _body2() {
    if (value == 0){
      return Container(
        child: widget.index == "pedidos"? children2[selectedItem1]: children2[selectedItem],
      );
    } return Stack(
      children: [
        widget.index == "pedidos"? children2[selectedItem1]: children2[selectedItem],
        GestureDetector(
          onTap: (){
            scaffoldKey.currentState!.openDrawer();
            setState(() {
              value == 0? value = 1 : value= 0;
            });
          },
          child: Scaffold(
            backgroundColor: Colors.black.withOpacity(0.1),
          ),
        )
      ],
    );
  }
}