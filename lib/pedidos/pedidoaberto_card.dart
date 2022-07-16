import 'package:allonsyapp/inicio/background.dart';
import 'package:allonsyapp/utils/nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class PedidoabertoCard extends StatefulWidget {
  final String url;
  final String nome;
  final double preco;
  final int qtd;
  final String id;

  PedidoabertoCard(this.url,this.nome,this.preco,this.qtd,this.id);

  @override
  State<PedidoabertoCard> createState() => _PedidoabertoCardState();
}

class _PedidoabertoCardState extends State<PedidoabertoCard> {
  final email = FirebaseAuth.instance.currentUser!.email;

  var index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.h),
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("pedidosemaberto").doc(email).
        collection("pedidosemaberto").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          return Container(
              height: 120.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.sp),
                border: Border.all(
                    width: 3.sp,
                    color: Color(0xFF03A9f4)
                ),
              ),
              child:Padding(
                padding: EdgeInsets.only(top: 4.h, bottom: 4.h, left: 4.w, right: 4.w),
                child: Stack(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          flex: 4,
                          child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(widget.url), fit: BoxFit.cover
                                ),
                                shape: BoxShape.circle,
                                border: Border.all(
                                    width: 3.sp,
                                    color:Color(0xFF03A9f4)
                                )
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 12,
                          child: Container(
                              padding: EdgeInsets.only(top: 5.h, bottom: 5.h,left: 10.w, right: 5.w),
                              child: Column(
                                children: [
                                  Flexible(
                                    flex: 6,
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 250.w,
                                            child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                widget.nome,
                                                maxLines: 1,
                                                style: GoogleFonts.roboto(
                                                    fontSize: 22.sp,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 6,
                                    child: Container(
                                      child: Row(
                                        children: [
                                          Flexible(
                                            flex:7,
                                            child: Container(
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text("R\$"+ (widget.qtd*widget.preco).toStringAsFixed(2),
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 20.sp,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w600
                                                  ),),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 4,
                                            child: Container(
                                              alignment: Alignment.topLeft,
                                              child: Align(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    GestureDetector(
                                                      onTap:(){
                                                        FirebaseFirestore.instance.collection("pedidosemaberto").
                                                        doc(email).collection("pedidosemaberto").doc(widget.id).update({
                                                          "qtd": widget.qtd-1,
                                                          "total":widget.preco*(widget.qtd-1)});
                                                        if(widget.qtd<2){
                                                          FirebaseFirestore.instance.collection("pedidosemaberto").doc(email).
                                                          collection("pedidosemaberto").doc(widget.id).delete();
                                                        }
                                                        if(snapshot.data!.docs.length<2 && widget.qtd<2){
                                                          push(context, BackGroundPage(),replace: true);
                                                        }
                                                      },
                                                      child: Container(
                                                        width: 22.w,
                                                        height: 22.h,
                                                        child: Icon(Icons.remove,
                                                            color: Colors.white,
                                                            size: 18.sp),
                                                        color: Color(0xFF03A9f4),
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Center(
                                                        child: Text("${widget.qtd}",
                                                          style: GoogleFonts.roboto(
                                                              fontSize: 25.sp,
                                                              fontWeight: FontWeight.bold,
                                                              color: Colors.black
                                                          ),),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: (){
                                                        FirebaseFirestore.instance.collection("pedidosemaberto").
                                                        doc(email).collection("pedidosemaberto").doc(widget.id).update({
                                                          "qtd": widget.qtd+1,
                                                          "total":widget.preco*(widget.qtd+1)
                                                        });
                                                      },
                                                      child: Container(
                                                        width: 22.w,
                                                        height: 22.h,
                                                        child: Icon(
                                                            Icons.add,
                                                            color: Colors.white,
                                                            size: 18.sp),
                                                        color: Color(0xFF03A9f4),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                          ),
                        )
                      ],
                    ),
                    GestureDetector(
                      onTap: (){
                        FirebaseFirestore.instance.collection("pedidosemaberto").doc(email).
                        collection("pedidosemaberto").doc(widget.id).delete();
                        if(snapshot.data!.docs.length<2){
                          push(context, BackGroundPage(),replace: true);
                        }
                      },
                      child: Align(
                          alignment: Alignment.topRight,
                          child: Icon(Icons.clear,color:Color(0xFF03A9f4),size: 28.sp,)),
                    )
                  ],
                ),
              )
          );
        },
      )
    );
  }
}
