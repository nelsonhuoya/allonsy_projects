import 'dart:async';
import 'package:allonsyapp/inicio/background.dart';
import 'package:allonsyapp/utils/nav.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class AnimacaoPage extends StatefulWidget {
  final String objetivo;

  AnimacaoPage({required this.objetivo});

  @override
  _AnimacaoPageState createState() => _AnimacaoPageState();
}

class _AnimacaoPageState extends State<AnimacaoPage> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xF7131313),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: Lottie.asset("assets/lf20_xigjqt0e.json",
              reverse: false,
              repeat: false,
              animate: true),
            ),
            Container(
              child: Text(widget.objetivo == "pedidos"? "Pedido Enviado" : "Reserva Realizada",
                  style: GoogleFonts.dancingScript(
                    fontSize: 48.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                  )
              ),
            )
          ],
        ),
      ),
    );
  }

  void startTimer() {
    Timer(Duration(seconds: 3), () {
      _push();
    });
  }

  Future<Null> _push() async {
    if(widget.objetivo == "pedidos"){
      push(context,BackGroundPage(index:"pedidos"),replace: true);
    } else {
      push(context,BackGroundPage(index:"reservas"),replace: true);
    }
  }
}