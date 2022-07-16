import 'package:allonsyapp/pratos/pratosdetalhes.dart';
import 'package:allonsyapp/utils/nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_text/circular_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CardPage extends StatefulWidget {

  final String img;
  final String nome;
  final String text;
  final double preco;
  final int tempo;
  final String categoria;
  final data;
  final bool sugestao;

  CardPage(this.img, this.nome, this.text, this.preco, this.tempo, this.categoria, this.data, this.sugestao);

  @override
  _CardPageState createState() => _CardPageState();
}

class _CardPageState extends State<CardPage> {

  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
     onTap: (){
       push(context, PratosDetalhesPage(widget.nome, widget.img, widget.preco, widget.text, widget.tempo, widget.categoria));
     },
      child: Padding(
        padding: EdgeInsets.only(bottom: 15.h, left: 8.w, right: 8.w),
        child: ClipRect(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.sp),
                    image: DecorationImage(
                        colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3),BlendMode.darken),
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
              DateTime.now().millisecondsSinceEpoch-widget.data.millisecondsSinceEpoch<=86400000*60? Banner(
                textStyle: GoogleFonts.roboto(
                  fontSize: 13.5.sp,
                    color:Color(0xFF03A9f4),
                  fontWeight: FontWeight.bold
                ),
                message: "Novo",
                location: BannerLocation.topStart,
                color: Colors.white,
              ):Container(),
              widget.sugestao == true? Positioned.fill(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 22.w, top: 22.h),
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
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
                  ),
                ),
              ) : Container()
            ]
          ),
        ),
      ),
    );
  }
}