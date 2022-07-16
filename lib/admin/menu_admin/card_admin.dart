import 'package:allonsyapp/admin/menu_admin/pratosdetalhes_admin.dart';
import 'package:allonsyapp/utils/nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_text/circular_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';


class CardPratoAdmin extends StatefulWidget {

  final String img;
  final String nome;
  final String text;
  final double preco;
  final int tempo;
  bool ativo;
  final String categoria;
  final String id;
  final bool sugestao;
  final String subcategoria;
  final data;

  CardPratoAdmin(this.img, this.nome, this.text, this.preco, this.tempo, this.ativo, this.categoria, this.id, this.sugestao, this.subcategoria, this.data);

  @override
  _CardPratoAdminState createState() => _CardPratoAdminState();
}

class _CardPratoAdminState extends State<CardPratoAdmin> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 15.h, left: 8.w, right: 8.w),
      child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.sp),
                  image: DecorationImage(
                      colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2),BlendMode.darken),
                      image: NetworkImage(widget.img),fit: BoxFit.cover
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
                      child: Text(widget.nome,
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
                      "R\$"+widget.preco.toStringAsFixed(2),
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
            GestureDetector(
              onTap: (){
                push(context, PratosDetalhesAdmin(widget.nome, widget.img, widget.preco, widget.text, widget.tempo, widget.categoria, widget.id,widget.subcategoria, widget.data));
              },
              onLongPress: (){
                FirebaseFirestore.instance.collection("pratos").doc(widget.id).update({
                  'ativo': widget.ativo == true ? false : true
                });
              },
              child: Container(
                color: widget.ativo == true? Colors.transparent : Colors.black.withOpacity(0.5),
              ),
            ),
            GestureDetector(
              onLongPress: (){
                FirebaseFirestore.instance.collection("pratos").doc(widget.id).delete();
              },
              child: Align(
                alignment: Alignment.topRight,
                child: Icon(
                  Icons.close,
                  size: 40.sp,
                  color: Colors.red
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 20.w, top: 25.h),
                  child: GestureDetector(
                    onTap: (){
                      FirebaseFirestore.instance.collection("pratos").doc(widget.id).update({
                        'sugestao': widget.sugestao == true? false : true
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.sugestao == true? Colors.green:Colors.red,
                          image: DecorationImage(
                              image: AssetImage("assets/hat.png")
                          )
                      ),
                      child: CircularText(
                          radius: 28,
                          position: CircularTextPosition.outside,
                          backgroundPaint: Paint()..color= Colors.transparent,
                          children: [
                            TextItem(
                                text: Text(
                                  "Sugestão do Chef",
                                  style: GoogleFonts.dancingScript(
                                      fontSize: 18.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                space: 10,
                                startAngle: -87,
                                startAngleAlignment: StartAngleAlignment.center,
                                direction: CircularTextDirection.clockwise
                            )

                          ]),
                    ),
                  )
                ),
              ),
            )
          ]
      ),
    );
  }
}
