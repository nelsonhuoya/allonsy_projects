import 'package:allonsyapp/utils/delivery_chart.dart';
import 'package:allonsyapp/utils/pedidosreservas_chart.dart';
import 'package:allonsyapp/utils/pedidosreservas_series.dart';
import 'package:allonsyapp/utils/receita_chart.dart';
import 'package:allonsyapp/utils/receita_series.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:allonsyapp/utils/delivery_series.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class FinancialAdminPage extends StatefulWidget {


  @override
  _FinancialAdminPageState createState() => _FinancialAdminPageState();

}

class _FinancialAdminPageState extends State<FinancialAdminPage> {

  var n = 6;

  final pedidosdia1 = FirebaseFirestore.instance.collection("pedidos").where('situacao', isEqualTo: 'Entregue').where('data', isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days:0)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second)));

  final pedidosdia2 = FirebaseFirestore.instance.collection("pedidos").where('situacao', isEqualTo: 'Entregue').where('data', isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days:1)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second))).where('data', isLessThan: DateTime.now().subtract(Duration(days:0)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second)));

  final pedidosdia3 = FirebaseFirestore.instance.collection("pedidos").where('situacao', isEqualTo: 'Entregue').where('data', isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days:2)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second))).where('data', isLessThan: DateTime.now().subtract(Duration(days:1)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second)));

  final pedidosdia4 = FirebaseFirestore.instance.collection("pedidos").where('situacao', isEqualTo: 'Entregue').where('data', isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days:3)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second))).where('data', isLessThan: DateTime.now().subtract(Duration(days:2)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second)));

  final pedidosdia5 = FirebaseFirestore.instance.collection("pedidos").where('situacao', isEqualTo: 'Entregue').where('data', isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days:4)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second))).where('data', isLessThan: DateTime.now().subtract(Duration(days:3)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second)));

  final pedidosdia6 = FirebaseFirestore.instance.collection("pedidos").where('situacao', isEqualTo: 'Entregue').where('data', isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days:5)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second))).where('data', isLessThan: DateTime.now().subtract(Duration(days:4)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second)));

  final pedidosdia7 = FirebaseFirestore.instance.collection("pedidos").where('situacao', isEqualTo: 'Entregue').where('data', isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days:6)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second))).where('data', isLessThan: DateTime.now().subtract(Duration(days:5)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second)));

  final reservasdia1 = FirebaseFirestore.instance.collection("reservas").where('data', isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days:0)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second)));

  final reservasdia2 = FirebaseFirestore.instance.collection("reservas").where('data', isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days:1)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second))).where('data', isLessThan: DateTime.now().subtract(Duration(days:0)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second)));

  final reservasdia3 = FirebaseFirestore.instance.collection("reservas").where('data', isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days:2)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second))).where('data', isLessThan: DateTime.now().subtract(Duration(days:1)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second)));

  final reservasdia4 = FirebaseFirestore.instance.collection("reservas").where('data', isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days:3)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second))).where('data', isLessThan: DateTime.now().subtract(Duration(days:2)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second)));

  final reservasdia5 = FirebaseFirestore.instance.collection("reservas").where('data', isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days:4)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second))).where('data', isLessThan: DateTime.now().subtract(Duration(days:3)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second)));

  final reservasdia6 = FirebaseFirestore.instance.collection("reservas").where('data', isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days:5)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second))).where('data', isLessThan: DateTime.now().subtract(Duration(days:4)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second)));

  final reservasdia7 = FirebaseFirestore.instance.collection("reservas").where('data', isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days:6)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second))).where('data', isLessThan: DateTime.now().subtract(Duration(days:5)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second)));

  final pedidossemana1 = FirebaseFirestore.instance.collection("pedidos").where('situacao', isEqualTo: 'Entregue').where('data', isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days:6)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second)));

  final pedidossemana2 = FirebaseFirestore.instance.collection("pedidos").where('situacao', isEqualTo: 'Entregue').where('data', isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days:13)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second))).where('data', isLessThan: DateTime.now().subtract(Duration(days:6)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second)));

  final pedidossemana3 = FirebaseFirestore.instance.collection("pedidos").where('situacao', isEqualTo: 'Entregue').where('data', isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days:20)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second))).where('data', isLessThan: DateTime.now().subtract(Duration(days:13)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second)));

  final pedidossemana4 = FirebaseFirestore.instance.collection("pedidos").where('situacao', isEqualTo: 'Entregue').where('data', isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days:27)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second))).where('data', isLessThan: DateTime.now().subtract(Duration(days:20)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second)));

  final pedidossemana5 = FirebaseFirestore.instance.collection("pedidos").where('situacao', isEqualTo: 'Entregue').where('data', isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days:34)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second))).where('data', isLessThan: DateTime.now().subtract(Duration(days:27)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second)));

  final reservassemana1 = FirebaseFirestore.instance.collection("reservas").where('data', isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days:6)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second)));

  final reservassemana2 = FirebaseFirestore.instance.collection("reservas").where('data', isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days:13)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second))).where('data', isLessThan: DateTime.now().subtract(Duration(days:6)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second)));

  final reservassemana3 = FirebaseFirestore.instance.collection("reservas").where('data', isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days:20)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second))).where('data', isLessThan: DateTime.now().subtract(Duration(days:13)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second)));

  final reservassemana4 = FirebaseFirestore.instance.collection("reservas").where('data', isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days:27)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second))).where('data', isLessThan: DateTime.now().subtract(Duration(days:20)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second)));

  final reservassemana5 = FirebaseFirestore.instance.collection("reservas").where('data', isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days:34)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second))).where('data', isLessThan: DateTime.now().subtract(Duration(days:27)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
      .subtract(Duration(seconds: DateTime.now().second)));

  final pedidosano1 = FirebaseFirestore.instance.collection("pedidos").where('situacao', isEqualTo: 'Entregue').where('data', isGreaterThanOrEqualTo: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)));

  final pedidosano2 = FirebaseFirestore.instance.collection("pedidos").where('situacao', isEqualTo: 'Entregue').where('data', isGreaterThanOrEqualTo: DateTime(DateTime.now().year,DateTime.now().month-1,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)))
      .where('data', isLessThan: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)));

  final pedidosano3 = FirebaseFirestore.instance.collection("pedidos").where('situacao', isEqualTo: 'Entregue').where('data', isGreaterThanOrEqualTo: DateTime(DateTime.now().year,DateTime.now().month-2,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)))
      .where('data', isLessThan: DateTime(DateTime.now().year,DateTime.now().month-1,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)));

  final pedidosano4 = FirebaseFirestore.instance.collection("pedidos").where('situacao', isEqualTo: 'Entregue').where('data', isGreaterThanOrEqualTo: DateTime(DateTime.now().year,DateTime.now().month-3,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)))
      .where('data', isLessThan: DateTime(DateTime.now().year,DateTime.now().month-2,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)));

  final pedidosano5 = FirebaseFirestore.instance.collection("pedidos").where('situacao', isEqualTo: 'Entregue').where('data', isGreaterThanOrEqualTo: DateTime(DateTime.now().year,DateTime.now().month-4,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)))
      .where('data', isLessThan: DateTime(DateTime.now().year,DateTime.now().month-3,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)));

  final pedidosano6 = FirebaseFirestore.instance.collection("pedidos").where('situacao', isEqualTo: 'Entregue').where('data', isGreaterThanOrEqualTo: DateTime(DateTime.now().year,DateTime.now().month-5,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)))
      .where('data', isLessThan: DateTime(DateTime.now().year,DateTime.now().month-4,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)));

  final pedidosano7 = FirebaseFirestore.instance.collection("pedidos").where('situacao', isEqualTo: 'Entregue').where('data', isGreaterThanOrEqualTo: DateTime(DateTime.now().year,DateTime.now().month-6,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)))
      .where('data', isLessThan: DateTime(DateTime.now().year,DateTime.now().month-5,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)));

  final pedidosano8 = FirebaseFirestore.instance.collection("pedidos").where('situacao', isEqualTo: 'Entregue').where('data', isGreaterThanOrEqualTo: DateTime(DateTime.now().year,DateTime.now().month-7,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)))
      .where('data', isLessThan: DateTime(DateTime.now().year,DateTime.now().month-6,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)));

  final pedidosano9 = FirebaseFirestore.instance.collection("pedidos").where('situacao', isEqualTo: 'Entregue').where('data', isGreaterThanOrEqualTo: DateTime(DateTime.now().year,DateTime.now().month-8,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)))
      .where('data', isLessThan: DateTime(DateTime.now().year,DateTime.now().month-7,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)));

  final pedidosano10 = FirebaseFirestore.instance.collection("pedidos").where('situacao', isEqualTo: 'Entregue').where('data', isGreaterThanOrEqualTo: DateTime(DateTime.now().year,DateTime.now().month-9,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)))
      .where('data', isLessThan: DateTime(DateTime.now().year,DateTime.now().month-8,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)));

  final pedidosano11 = FirebaseFirestore.instance.collection("pedidos").where('situacao', isEqualTo: 'Entregue').where('data', isGreaterThanOrEqualTo: DateTime(DateTime.now().year,DateTime.now().month-10,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)))
      .where('data', isLessThan: DateTime(DateTime.now().year,DateTime.now().month-9,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)));

  final pedidosano12 = FirebaseFirestore.instance.collection("pedidos").where('situacao', isEqualTo: 'Entregue').where('data', isGreaterThanOrEqualTo: DateTime(DateTime.now().year,DateTime.now().month-11,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)))
      .where('data', isLessThan: DateTime(DateTime.now().year,DateTime.now().month-10,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)));

  final reservasano1 = FirebaseFirestore.instance.collection("reservas").where('data', isGreaterThanOrEqualTo: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)));

  final reservasano2 = FirebaseFirestore.instance.collection("reservas").where('data', isGreaterThanOrEqualTo: DateTime(DateTime.now().year,DateTime.now().month-1,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)))
      .where('data', isLessThan: DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)));

  final reservasano3 = FirebaseFirestore.instance.collection("reservas").where('data', isGreaterThanOrEqualTo: DateTime(DateTime.now().year,DateTime.now().month-2,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)))
      .where('data', isLessThan: DateTime(DateTime.now().year,DateTime.now().month-1,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)));

  final reservasano4 = FirebaseFirestore.instance.collection("reservas").where('data', isGreaterThanOrEqualTo: DateTime(DateTime.now().year,DateTime.now().month-3,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)))
      .where('data', isLessThan: DateTime(DateTime.now().year,DateTime.now().month-2,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)));

  final reservasano5 = FirebaseFirestore.instance.collection("reservas").where('data', isGreaterThanOrEqualTo: DateTime(DateTime.now().year,DateTime.now().month-4,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)))
      .where('data', isLessThan: DateTime(DateTime.now().year,DateTime.now().month-3,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)));

  final reservasano6 = FirebaseFirestore.instance.collection("reservas").where('data', isGreaterThanOrEqualTo: DateTime(DateTime.now().year,DateTime.now().month-5,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)))
      .where('data', isLessThan: DateTime(DateTime.now().year,DateTime.now().month-4,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)));

  final reservasano7 = FirebaseFirestore.instance.collection("reservas").where('data', isGreaterThanOrEqualTo: DateTime(DateTime.now().year,DateTime.now().month-6,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)))
      .where('data', isLessThan: DateTime(DateTime.now().year,DateTime.now().month-5,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)));

  final reservasano8 = FirebaseFirestore.instance.collection("reservas").where('data', isGreaterThanOrEqualTo: DateTime(DateTime.now().year,DateTime.now().month-7,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)))
      .where('data', isLessThan: DateTime(DateTime.now().year,DateTime.now().month-6,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)));

  final reservasano9 = FirebaseFirestore.instance.collection("reservas").where('data', isGreaterThanOrEqualTo: DateTime(DateTime.now().year,DateTime.now().month-8,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)))
      .where('data', isLessThan: DateTime(DateTime.now().year,DateTime.now().month-7,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)));

  final reservasano10 = FirebaseFirestore.instance.collection("reservas").where('data', isGreaterThanOrEqualTo: DateTime(DateTime.now().year,DateTime.now().month-9,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)))
      .where('data', isLessThan: DateTime(DateTime.now().year,DateTime.now().month-8,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)));

  final reservasano11 = FirebaseFirestore.instance.collection("reservas").where('data', isGreaterThanOrEqualTo: DateTime(DateTime.now().year,DateTime.now().month-10,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)))
      .where('data', isLessThan: DateTime(DateTime.now().year,DateTime.now().month-9,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)));

  final reservasano12 = FirebaseFirestore.instance.collection("reservas").where('data', isGreaterThanOrEqualTo: DateTime(DateTime.now().year,DateTime.now().month-11,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)))
      .where('data', isLessThan: DateTime(DateTime.now().year,DateTime.now().month-10,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)));



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xF7131313),
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
        title: Text ("Financeiro",
          style: GoogleFonts.dancingScript(
              fontSize: 35.0.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),),
        actions: [
          Container(
            width: 100.w,
            child: Container(
              child: PopupMenuButton(
                color: Colors.white,
                icon: Container(
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(
                        color: Colors.white,  // Text colour here
                        width: 1.0.sp, // Underline width
                      ))
                  ),
                  child: Text(
                    n== 6? "Dias" : n == 34? "Semanas": "Ano",
                    textAlign: TextAlign.end,
                    style: GoogleFonts.roboto(
                      fontSize: 16.sp
                    ),
                    maxLines: 1,
                  ),
                ),
                itemBuilder: (_)=> <PopupMenuItem<String>>[
                  PopupMenuItem(
                    child: Text(
                      "Dias",
                      style: GoogleFonts.roboto(
                          fontSize: 18.sp,
                          color: Colors.black
                      ),
                    ),
                    value: "dias",
                  ),
                  PopupMenuItem(
                    child: Text(
                      "Semanas",
                      style: GoogleFonts.roboto(
                          fontSize: 18.sp,
                          color: Colors.black
                      ),
                    ),
                    value: "semanas",
                  ),
                  PopupMenuItem(
                    child: Text(
                      "Ano",
                      style: GoogleFonts.roboto(
                          fontSize: 18.sp,
                          color: Colors.black
                      ),
                    ),
                    value: "ano",
                  )
                ],
                onSelected: (index) {
                  switch(index) {
                    case 'dias':
                      setState(() {
                        n = 6;
                      });
                      break;
                    case 'semanas':
                      setState(() {
                        n =34;
                      });
                      break;
                    case 'ano':
                      setState(() {
                        n = 365;
                      });
                       break;
                  }
                },
              ),
            ),
          ),
        ],
      ),
      body: _body(),
    );
  }

  _body() {
     return StreamBuilder<List<QuerySnapshot>>(
         stream: CombineLatestStream.list([
           FirebaseFirestore.instance.collection("pedidos").where('situacao', isEqualTo: 'Entregue').where('data', isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days:n)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
               .subtract(Duration(seconds: DateTime.now().second))).snapshots(),
           FirebaseFirestore.instance.collection("pedidos").where('situacao', isEqualTo: 'Entregue').where('data', isGreaterThanOrEqualTo: DateTime(DateTime.now().year,DateTime.now().month-11,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1))).snapshots(),
           pedidosdia1.snapshots(),
           pedidosdia2.snapshots(),
           pedidosdia3.snapshots(),
           pedidosdia4.snapshots(),
           pedidosdia5.snapshots(),
           pedidosdia6.snapshots(),
           pedidosdia7.snapshots(),
           pedidossemana1.snapshots(),
           pedidossemana2.snapshots(),
           pedidossemana3.snapshots(),
           pedidossemana4.snapshots(),
           pedidossemana5.snapshots(),
           pedidosano1.snapshots(),
           pedidosano2.snapshots(),
           pedidosano3.snapshots(),
           pedidosano4.snapshots(),
           pedidosano5.snapshots(),
           pedidosano6.snapshots(),
           pedidosano7.snapshots(),
           pedidosano8.snapshots(),
           pedidosano9.snapshots(),
           pedidosano10.snapshots(),
           pedidosano11.snapshots(),
           pedidosano12.snapshots(),
         ]),
         builder: (BuildContext context, AsyncSnapshot<List<QuerySnapshot>> pedidos){
           if(pedidos.hasError){
             return Center(
               child: Text(
                 "Não foi possível carregar os dados financeiros",
                 style: TextStyle(
                     color: Colors.red,
                     fontSize: 22.sp
                 ),
               ),
             );
           } if (!pedidos.hasData){
             return Center(
               child: CircularProgressIndicator(),
             );
           }
           return StreamBuilder(
               stream: n !=365? FirebaseFirestore.instance.collection("reservas").where("data", isGreaterThan: DateTime.now().subtract(Duration(days:n)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
                   .subtract(Duration(seconds: DateTime.now().second))).snapshots() :
               FirebaseFirestore.instance.collection("reservas").where('data', isGreaterThanOrEqualTo: DateTime(DateTime.now().year,DateTime.now().month-11,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
                   .subtract(Duration(seconds: DateTime.now().second))).snapshots(),
               builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> reservas){
                 if(reservas.hasError) {
                   return Center(
                     child: Text(
                       "Não foi possível carregar os dados financeiros",
                       style: TextStyle(
                           color: Colors.red,
                           fontSize: 22.sp
                       ),
                     ),
                   );
                 } if(!reservas.hasData) {
                   return Center(
                     child: CircularProgressIndicator(),
                   );
                 }
                 var ds = n!=365? pedidos.data![0].docs : pedidos.data![1].docs;
                 double total = 0.00;
                 for(int i = 0; i<ds.length;i++)
                   total+= (ds[i]["total"]);
                 var ds2 = reservas.data!.docs;
                 double pessoas = 0.00;
                 for(int t =0; t<ds2.length;t++)
                   pessoas+= (ds2[t]["pessoas"]);
                 double receitadia1 = 0.00;
                 for(int i = 0; i<pedidos.data![2].docs.length;i++)
                   receitadia1 += (pedidos.data![2].docs[i]["total"]);
                 double receitadia2 = 0.00;
                 for(int i = 0; i<pedidos.data![3].docs.length;i++)
                   receitadia2 += (pedidos.data![3].docs[i]["total"]);
                 double receitadia3 = 0.00;
                 for(int i = 0; i<pedidos.data![4].docs.length;i++)
                   receitadia3 += (pedidos.data![4].docs[i]["total"]);
                 double receitadia4 = 0.00;
                 for(int i = 0; i<pedidos.data![5].docs.length;i++)
                   receitadia4 += (pedidos.data![5].docs[i]["total"]);
                 double receitadia5 = 0.00;
                 for(int i = 0; i<pedidos.data![6].docs.length;i++)
                   receitadia5 += (pedidos.data![6].docs[i]["total"]);
                 double receitadia6 = 0.00;
                 for(int i = 0; i<pedidos.data![7].docs.length;i++)
                   receitadia6 += (pedidos.data![7].docs[i]["total"]);
                 double receitadia7 = 0.00;
                 for(int i = 0; i<pedidos.data![8].docs.length;i++)
                   receitadia7 += (pedidos.data![8].docs[i]["total"]);
                 double receitasemana1 = 0.00;
                 for(int i = 0; i<pedidos.data![9].docs.length;i++)
                   receitasemana1 += (pedidos.data![9].docs[i]["total"]);
                 double receitasemana2 = 0.00;
                 for(int i = 0; i<pedidos.data![10].docs.length;i++)
                   receitasemana2 += (pedidos.data![10].docs[i]["total"]);
                 double receitasemana3 = 0.00;
                 for(int i = 0; i<pedidos.data![11].docs.length;i++)
                   receitasemana3 += (pedidos.data![11].docs[i]["total"]);
                 double receitasemana4 = 0.00;
                 for(int i = 0; i<pedidos.data![12].docs.length;i++)
                   receitasemana4 += (pedidos.data![12].docs[i]["total"]);
                 double receitasemana5 = 0.00;
                 for(int i = 0; i<pedidos.data![13].docs.length;i++)
                   receitasemana5 += (pedidos.data![13].docs[i]["total"]);
                 double receitasano1 = 0.00;
                 for(int i = 0; i<pedidos.data![14].docs.length;i++)
                   receitasano1 += (pedidos.data![14].docs[i]["total"]);
                 double receitasano2 = 0.00;
                 for(int i = 0; i<pedidos.data![15].docs.length;i++)
                   receitasano2 += (pedidos.data![15].docs[i]["total"]);
                 double receitasano3 = 0.00;
                 for(int i = 0; i<pedidos.data![16].docs.length;i++)
                   receitasano3 += (pedidos.data![16].docs[i]["total"]);
                 double receitasano4 = 0.00;
                 for(int i = 0; i<pedidos.data![17].docs.length;i++)
                   receitasano4 += (pedidos.data![17].docs[i]["total"]);
                 double receitasano5 = 0.00;
                 for(int i = 0; i<pedidos.data![18].docs.length;i++)
                   receitasano5 += (pedidos.data![18].docs[i]["total"]);
                 double receitasano6 = 0.00;
                 for(int i = 0; i<pedidos.data![19].docs.length;i++)
                   receitasano6 += (pedidos.data![19].docs[i]["total"]);
                 double receitasano7 = 0.00;
                 for(int i = 0; i<pedidos.data![20].docs.length;i++)
                   receitasano7 += (pedidos.data![20].docs[i]["total"]);
                 double receitasano8 = 0.00;
                 for(int i = 0; i<pedidos.data![21].docs.length;i++)
                   receitasano8 += (pedidos.data![21].docs[i]["total"]);
                 double receitasano9 = 0.00;
                 for(int i = 0; i<pedidos.data![22].docs.length;i++)
                   receitasano9 += (pedidos.data![22].docs[i]["total"]);
                 double receitasano10 = 0.00;
                 for(int i = 0; i<pedidos.data![23].docs.length;i++)
                   receitasano10 += (pedidos.data![23].docs[i]["total"]);
                 double receitasano11 = 0.00;
                 for(int i = 0; i<pedidos.data![24].docs.length;i++)
                   receitasano11 += (pedidos.data![24].docs[i]["total"]);
                 double receitasano12 = 0.00;
                 for(int i = 0; i<pedidos.data![25].docs.length;i++)
                   receitasano12 += (pedidos.data![25].docs[i]["total"]);
                 return Padding(
                   padding: EdgeInsets.all(10.0.sp),
                   child: Column(
                     children: [
                       Container(
                         height: 100.h,
                         decoration: BoxDecoration(
                             color: Color(0xFF1B1B1B),
                             borderRadius: BorderRadius.circular(10.sp)
                         ),
                         child: Center(
                           child: Container(
                             decoration: BoxDecoration(
                                 border: Border(bottom: BorderSide(
                                   color: Color(0xFF03A9f4),  // Text colour here
                                   width: 4.0.sp, // Underline width
                                 ))
                             ),
                             child: Text(
                               "R\$"+total.toStringAsFixed(2),
                               style: GoogleFonts.roboto(
                                 fontSize: 40.sp,
                                 color: Colors.white,
                                 fontWeight: FontWeight.w600
                               ),
                             ),
                           ),
                         ),
                       ),
                       SizedBox(
                         height: 20.h,
                       ),
                       Container(
                         height: 150.h,
                         decoration: BoxDecoration(
                             color: Color(0xFF1B1B1B),
                             borderRadius: BorderRadius.circular(10.sp)
                         ),
                         child: Center(
                           child: Padding(
                             padding: EdgeInsets.only(left: 60.0.w,right:30.w, top: 10.h, bottom: 32.h),
                             child: n==6?
                             ReceitaChart(
                               data: [
                                 ReceitaSeries(
                                       data: 6,
                                       qtd: receitadia1 + receitadia2 + receitadia3 + receitadia4 + receitadia5 +receitadia6 +receitadia7,
                                 ),
                                 ReceitaSeries(
                                   data: 5,
                                   qtd: receitadia7 + receitadia6 + receitadia5 + receitadia4 + receitadia3 +receitadia2,
                                 ),
                                 ReceitaSeries(
                                   data: 4,
                                   qtd: receitadia7 + receitadia6 + receitadia5 + receitadia4 + receitadia3,
                                 ),
                                 ReceitaSeries(
                                   data: 3,
                                   qtd:  receitadia7 + receitadia6 + receitadia5 + receitadia4,
                                 ),
                                 ReceitaSeries(
                                   data: 2,
                                   qtd: receitadia7 + receitadia6 + receitadia5,
                                 ),
                                 ReceitaSeries(
                                   data: 1,
                                   qtd: receitadia7 + receitadia6,
                                 ),
                                 ReceitaSeries(
                                   data: 0,
                                   qtd: receitadia7,
                                 )
                               ],
                               maxvalue: total,
                               minvalue: 0,
                               desiredTickCount: 7,
                               customFormatterSpec: charts.BasicNumericTickFormatterSpec((value){
                                 if(value == 6){
                                   return DateFormat(DateFormat.ABBR_WEEKDAY,'pt_Br').format(DateTime.now().subtract(Duration(days: 0))).toString().toUpperCase();
                                 } else if (value == 5){
                                   return DateFormat(DateFormat.ABBR_WEEKDAY,'pt_Br').format(DateTime.now().subtract(Duration(days: 1))).toString().toUpperCase();
                                 } else if (value == 4){
                                   return DateFormat(DateFormat.ABBR_WEEKDAY,'pt_Br').format(DateTime.now().subtract(Duration(days: 2))).toString().toUpperCase();
                                 } else if (value == 3){
                                   return DateFormat(DateFormat.ABBR_WEEKDAY,'pt_Br').format(DateTime.now().subtract(Duration(days: 3))).toString().toUpperCase();
                                 } else if (value == 2){
                                   return DateFormat(DateFormat.ABBR_WEEKDAY,'pt_Br').format(DateTime.now().subtract(Duration(days: 4))).toString().toUpperCase();
                                 }else if (value == 1){
                                   return DateFormat(DateFormat.ABBR_WEEKDAY,'pt_Br').format(DateTime.now().subtract(Duration(days: 5))).toString().toUpperCase();
                                 } return DateFormat(DateFormat.ABBR_WEEKDAY,'pt_Br').format(DateTime.now().subtract(Duration(days: 6))).toString().toUpperCase();
                               })): n==34?
                             ReceitaChart(
                               data: [
                                 ReceitaSeries(
                                   data: 4,
                                   qtd: receitasemana5 + receitasemana4  +receitasemana3 +receitasemana2 +receitasemana1,
                                 ),
                                 ReceitaSeries(
                                   data: 3,
                                   qtd:  receitasemana5 + receitasemana4 + receitasemana3 +receitasemana2,
                                 ),
                                 ReceitaSeries(
                                   data: 2,
                                   qtd: receitasemana5 + receitasemana4 + receitasemana3 ,
                                 ),
                                 ReceitaSeries(
                                   data: 1,
                                   qtd: receitasemana5 + receitasemana4 ,
                                 ),
                                 ReceitaSeries(
                                   data: 0,
                                   qtd: receitasemana5,
                                 )
                               ],
                               maxvalue: total,
                               minvalue: 0,
                               desiredTickCount: 5,
                                 customFormatterSpec: charts.BasicNumericTickFormatterSpec((value){
                                   if(value == 4){
                                     return DateFormat(DateFormat.DAY,'pt_Br').format(DateTime.now().subtract(Duration(days:6))).toString() + '/'+DateFormat(DateFormat.NUM_MONTH,'pt_Br').format(DateTime.now().subtract(Duration(days:6))).toString()+'-'+ DateFormat(DateFormat.DAY,'pt_Br').format(DateTime.now().subtract(Duration(days: 0))).toString()+'/'+DateFormat(DateFormat.NUM_MONTH,'pt_Br').format(DateTime.now().subtract(Duration(days:0))).toString();
                                   } else if (value ==3){
                                     return DateFormat(DateFormat.DAY,'pt_Br').format(DateTime.now().subtract(Duration(days:13))).toString() + '/'+ DateFormat(DateFormat.NUM_MONTH,'pt_Br').format(DateTime.now().subtract(Duration(days:13))).toString() +'-'+ DateFormat(DateFormat.DAY,'pt_Br').format(DateTime.now().subtract(Duration(days: 7))).toString() + '/' + DateFormat(DateFormat.NUM_MONTH,'pt_Br').format(DateTime.now().subtract(Duration(days:7))).toString();
                                   } else if (value ==2){
                                     return DateFormat(DateFormat.DAY,'pt_Br').format(DateTime.now().subtract(Duration(days:20))).toString() + '/' + DateFormat(DateFormat.NUM_MONTH,'pt_Br').format(DateTime.now().subtract(Duration(days:20))).toString() +'-'+ DateFormat(DateFormat.DAY,'pt_Br').format(DateTime.now().subtract(Duration(days: 14))).toString() + '/' + DateFormat(DateFormat.NUM_MONTH,'pt_Br').format(DateTime.now().subtract(Duration(days:14))).toString();
                                   } else if (value ==1){
                                     return DateFormat(DateFormat.DAY,'pt_Br').format(DateTime.now().subtract(Duration(days:27))).toString() + '/'+ DateFormat(DateFormat.NUM_MONTH,'pt_Br').format(DateTime.now().subtract(Duration(days:27))).toString() +'-'+ DateFormat(DateFormat.DAY,'pt_Br').format(DateTime.now().subtract(Duration(days: 21))).toString() + '/' + DateFormat(DateFormat.NUM_MONTH,'pt_Br').format(DateTime.now().subtract(Duration(days:21))).toString();
                                   } return DateFormat(DateFormat.DAY,'pt_Br').format(DateTime.now().subtract(Duration(days:34))).toString() + '/'+ DateFormat(DateFormat.NUM_MONTH,'pt_Br').format(DateTime.now().subtract(Duration(days:34))).toString()+'-'+ DateFormat(DateFormat.DAY,'pt_Br').format(DateTime.now().subtract(Duration(days: 28))).toString() + '/' + DateFormat(DateFormat.NUM_MONTH,'pt_Br').format(DateTime.now().subtract(Duration(days:28))).toString();
                                 })
                             ):
                             ReceitaChart(
                               data: [
                                 ReceitaSeries(
                                   data: 11,
                                   qtd: receitasano12+receitasano11+receitasano10+receitasano9+receitasano8+receitasano7+receitasano6+receitasano5+
                                       receitasano4+receitasano3+receitasano2+receitasano1,
                                 ),
                                 ReceitaSeries(
                                   data: 10,
                                   qtd: receitasano2+receitasano3+receitasano4+receitasano5+receitasano6+receitasano7+receitasano8+
                                       receitasano9+receitasano10+receitasano11+receitasano12,
                                 ),
                                 ReceitaSeries(
                                   data: 9,
                                   qtd: receitasano3+receitasano4+receitasano5+receitasano6+receitasano7+receitasano8+
                                       receitasano9+receitasano10+receitasano11+receitasano12,
                                 ),
                                 ReceitaSeries(
                                   data: 8,
                                   qtd:  receitasano4+receitasano5+receitasano6+receitasano7+receitasano8+
                                       receitasano9+receitasano10+receitasano11+receitasano12,
                                 ),
                                 ReceitaSeries(
                                   data: 7,
                                   qtd: receitasano5+receitasano6+receitasano7+receitasano8+
                                       receitasano9+receitasano10+receitasano11+receitasano12,
                                 ),
                                 ReceitaSeries(
                                   data: 6,
                                   qtd: receitasano6+receitasano7+receitasano8+
                                       receitasano9+receitasano10+receitasano11+receitasano12,
                                 ),
                                 ReceitaSeries(
                                   data: 5,
                                   qtd: receitasano7+receitasano8+
                                       receitasano9+receitasano10+receitasano11+receitasano12,
                                 ),
                                 ReceitaSeries(
                                   data: 4,
                                   qtd: receitasano8+receitasano9+receitasano10+receitasano11+receitasano12,
                                 ),
                                 ReceitaSeries(
                                   data: 3,
                                   qtd:  receitasano9+receitasano10+receitasano11+receitasano12,
                                 ),
                                 ReceitaSeries(
                                   data: 2,
                                   qtd: receitasano10+receitasano11+receitasano12,
                                 ),
                                 ReceitaSeries(
                                   data: 1,
                                   qtd: receitasano11+receitasano12,
                                 ),
                                 ReceitaSeries(
                                   data: 0,
                                   qtd: receitasano12,
                                 )
                               ],
                               maxvalue: total,
                               minvalue: 0,
                               desiredTickCount: 12,
                               customFormatterSpec: charts.BasicNumericTickFormatterSpec((value){
                                 if(value == 11){
                                   return DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)).month.toString();
                                 } else if (value ==10){
                                   return DateTime(DateTime.now().year,DateTime.now().month-1,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)).month.toString();
                                 } else if (value ==9){
                                   return DateTime(DateTime.now().year,DateTime.now().month-2,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)).month.toString();
                                 } else if (value ==8){
                                   return DateTime(DateTime.now().year,DateTime.now().month-3,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)).month.toString();
                                 } else if (value ==7){
                                   return DateTime(DateTime.now().year,DateTime.now().month-4,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)).month.toString();
                                 } else if (value ==6){
                                   return DateTime(DateTime.now().year,DateTime.now().month-5,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)).month.toString();
                                 } else if (value ==5){
                                   return DateTime(DateTime.now().year,DateTime.now().month-6,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)).month.toString();
                                 }else if (value == 4){
                                   return DateTime(DateTime.now().year,DateTime.now().month-7,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)).month.toString();
                                 } else if (value ==3){
                                   return DateTime(DateTime.now().year,DateTime.now().month-8,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)).month.toString();
                                 } else if (value ==2){
                                   return DateTime(DateTime.now().year,DateTime.now().month-9,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)).month.toString();
                                 }  else if (value == 1){
                                   return DateTime(DateTime.now().year,DateTime.now().month-10,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)).month.toString();
                                 } return DateTime(DateTime.now().year,DateTime.now().month-11,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)).month.toString();
                               }),
                             ),
                           )
                         ),
                       ),
                       SizedBox(
                         height: 20.h,
                       ),
                       Expanded(
                         child: Container(
                           width: 393.w,
                           child: GridView.count(
                             crossAxisCount: 2,
                             scrollDirection: Axis.horizontal,
                             childAspectRatio: 0.49,
                             crossAxisSpacing: 10.sp,
                             mainAxisSpacing: 15.sp,
                             children: [
                               Container(
                                 decoration: BoxDecoration(
                                     color: Color(0xFF1B1B1B),
                                     borderRadius: BorderRadius.circular(10.sp)
                                 ),
                                 width: 300.w,
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   children: [
                                     Text(
                                       n!=365? pedidos.data![0].docs.length.toString() : pedidos.data![1].docs.length.toString(),
                                       style: GoogleFonts.roboto(
                                         fontSize: 40.sp,
                                         color: Color(0xFF03A9f4),
                                         fontWeight: FontWeight.bold
                                       ),
                                     ),
                                     Text(
                                       n!=365? pedidos.data![0].docs.length>1?
                                         'Pedidos' : 'Pedido':pedidos.data![1].docs.length>1?'Pedidos' : 'Pedido',
                                       style: GoogleFonts.roboto(
                                         fontSize: 30.sp,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w300,
                                       ),
                                     )
                                   ],
                                 ),
                               ),
                               Container(
                                   decoration: BoxDecoration(
                                       color: Color(0xFF1B1B1B),
                                       borderRadius: BorderRadius.circular(10.sp)
                                   ),
                                   child: StreamBuilder<QuerySnapshot>(
                                       stream: n!=365?FirebaseFirestore.instance.collection("pedidos").where('data', isGreaterThanOrEqualTo: DateTime.now().subtract(Duration(days:n)).subtract(Duration(hours: DateTime.now().hour)).subtract(Duration(minutes: DateTime.now().minute))
                                           .subtract(Duration(seconds: DateTime.now().second))).where("retirada", isEqualTo: false)
                                           .where("situacao", isEqualTo: "Entregue").snapshots():
                                       FirebaseFirestore.instance.collection("pedidos").where('situacao', isEqualTo: 'Entregue').where("retirada", isEqualTo: false).where('data', isGreaterThanOrEqualTo: DateTime(DateTime.now().year,DateTime.now().month-11,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1))).snapshots(),
                                       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> delivery){
                                         if(delivery.hasError){
                                           return Center(
                                             child: Text(
                                               "Não foi possível carregar os dados financeiros",
                                               textAlign: TextAlign.center,
                                               style: TextStyle(
                                                   color: Colors.red,
                                                   fontSize: 22.sp
                                               ),
                                             ),
                                           );
                                         }
                                         if(!delivery.hasData){
                                           return Center(
                                             child: CircularProgressIndicator(),
                                           );
                                         }
                                         return Row(
                                           children: [
                                             Flexible(
                                               flex:10,
                                               child: Container(
                                                   child: Padding(
                                                     padding: EdgeInsets.only(left: 5.0.w),
                                                     child: DeliveryChart(
                                                         data: [
                                                           DeliverySeries(
                                                               entrega: 'delivery',
                                                               pedidos: delivery.data!.docs.length,
                                                               barcolor: charts.ColorUtil.fromDartColor(Color(0xff03a9f4))
                                                           ),
                                                           DeliverySeries(
                                                               entrega: 'take-out/restaurante',
                                                               pedidos: n!=365? pedidos.data![0].docs.length - delivery.data!.docs.length:pedidos.data![1].docs.length - delivery.data!.docs.length,
                                                               barcolor: charts.ColorUtil.fromDartColor(Color(0xff2c7695))
                                                           ),
                                                         ]
                                                     ),
                                                   )),
                                             ),
                                             Flexible(
                                               flex: 15,
                                               child: Container(
                                                 child: Center(
                                                   child: Column(
                                                     crossAxisAlignment: CrossAxisAlignment.center,
                                                     mainAxisAlignment: MainAxisAlignment.center,
                                                     children: [
                                                       Text(
                                                         n!=365?pedidos.data![0].docs.length>0?
                                                         ((delivery.data!.docs.length/pedidos.data![0].docs.length)*100).toStringAsFixed(0)+"%":'0%':
                                                         pedidos.data![1].docs.length>0?
                                                         ((delivery.data!.docs.length/pedidos.data![1].docs.length)*100).toStringAsFixed(0)+"%":'0%',
                                                         style: GoogleFonts.roboto(
                                                             fontSize: 35.sp,
                                                             color: Color(0xFF03A9f4),
                                                             fontWeight: FontWeight.bold
                                                         ),
                                                       ),
                                                       Text(
                                                         "dos pedidos sendo delivery",
                                                         textAlign: TextAlign.center,
                                                         style: GoogleFonts.roboto(
                                                           fontSize: 15.sp,
                                                           color: Colors.white,
                                                           fontWeight: FontWeight.w300,
                                                         ),
                                                       ),
                                                     ],
                                                   ),
                                                 ),
                                               ),
                                             )
                                           ],
                                         );
                                       },
                                     )
                                   ),
                               Container(
                                 decoration: BoxDecoration(
                                     color: Color(0xFF1B1B1B),
                                     borderRadius: BorderRadius.circular(10.sp)
                                 ),
                                 child: Column(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   children: [
                                     Text(
                                       reservas.data!.docs.length.toString(),
                                       style: GoogleFonts.roboto(
                                           fontSize: 40.sp,
                                           color: Color(0xffa8d8ef),
                                           fontWeight: FontWeight.bold
                                       ),
                                     ),
                                     Text(
                                         reservas.data!.docs.length>1?
                                         'Reservas' : 'Reserva',
                                       style: GoogleFonts.roboto(
                                         fontSize: 30.sp,
                                         color: Colors.white,
                                         fontWeight: FontWeight.w300,
                                       ),
                                     )
                                   ],
                                 ),
                               ),
                               Container(
                                 decoration: BoxDecoration(
                                     color: Color(0xFF1B1B1B),
                                     borderRadius: BorderRadius.circular(10.sp)
                                 ),
                                 child: Row(
                                   mainAxisAlignment: MainAxisAlignment.center,
                                   crossAxisAlignment: CrossAxisAlignment.center,
                                   children: [
                                     Container(
                                       child: Center(
                                         child: Text(
                                           pessoas.toStringAsFixed(0),
                                           textAlign: TextAlign.center,
                                           style: GoogleFonts.roboto(
                                               fontSize: 35.sp,
                                               color: Color(0xffa8d8ef),
                                               fontWeight: FontWeight.bold
                                           ),
                                         ),
                                       ),
                                     ),
                                     SizedBox(
                                       width: 5.w,
                                     ),
                                     Container(
                                       width: pessoas>999?80.w:100.w,
                                       child: Center(
                                         child: Text(
                                             pessoas>1?
                                             'Clientes Atendidos no Restaurante' : 'Cliente Atendido no Restaurante',
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.roboto(
                                             fontSize: pessoas>999?12.sp:15.sp,
                                             color: Colors.white,
                                             fontWeight: FontWeight.w300,
                                           ),
                                         ),
                                       ),
                                     ),
                                   ],
                                 ),
                               )
                             ],
                           ),
                         ),
                       ),
                       SizedBox(
                         height: 20.h,
                       ),
                       Container(
                         height: 150.h,
                         decoration: BoxDecoration(
                             color: Color(0xFF1B1B1B),
                             borderRadius: BorderRadius.circular(10.sp)
                         ),
                         child: Center(
                           child: Padding(
                             padding: EdgeInsets.only(left: 25.0.w, right: 25.w, top: 10.h, bottom: 22.h),
                             child: StreamBuilder<List<QuerySnapshot>>(
                               stream: CombineLatestStream.list([
                                 pedidosdia1.snapshots(),
                                 pedidosdia2.snapshots(),
                                 pedidosdia3.snapshots(),
                                 pedidosdia4.snapshots(),
                                 pedidosdia5.snapshots(),
                                 pedidosdia6.snapshots(),
                                 pedidosdia7.snapshots(),
                                 pedidossemana1.snapshots(),
                                 pedidossemana2.snapshots(),
                                 pedidossemana3.snapshots(),
                                 pedidossemana4.snapshots(),
                                 pedidossemana5.snapshots(),
                                 reservasdia1.snapshots(),
                                 reservasdia2.snapshots(),
                                 reservasdia3.snapshots(),
                                 reservasdia4.snapshots(),
                                 reservasdia5.snapshots(),
                                 reservasdia6.snapshots(),
                                 reservasdia7.snapshots(),
                                 reservassemana1.snapshots(),
                                 reservassemana2.snapshots(),
                                 reservassemana3.snapshots(),
                                 reservassemana4.snapshots(),
                                 reservassemana5.snapshots(),
                                 pedidosano1.snapshots(),
                                 pedidosano2.snapshots(),
                                 pedidosano3.snapshots(),
                                 pedidosano4.snapshots(),
                                 pedidosano5.snapshots(),
                                 pedidosano6.snapshots(),
                                 pedidosano7.snapshots(),
                                 pedidosano8.snapshots(),
                                 pedidosano9.snapshots(),
                                 pedidosano10.snapshots(),
                                 pedidosano11.snapshots(),
                                 pedidosano12.snapshots(),
                                 reservasano1.snapshots(),
                                 reservasano2.snapshots(),
                                 reservasano3.snapshots(),
                                 reservasano4.snapshots(),
                                 reservasano5.snapshots(),
                                 reservasano6.snapshots(),
                                 reservasano7.snapshots(),
                                 reservasano8.snapshots(),
                                 reservasano9.snapshots(),
                                 reservasano10.snapshots(),
                                 reservasano11.snapshots(),
                                 reservasano12.snapshots(),
                               ])
                                 ,
                               builder: (context, AsyncSnapshot<List<QuerySnapshot>> grafico2){
                                 if(grafico2.hasError){
                                   Center(
                                   );
                                 }
                                 if(!grafico2.hasData){
                                   return Center(
                                     child: CircularProgressIndicator(),
                                   );
                                 }
                                 if(n==6){
                                   return PedidosReservasChart(
                                     data: [
                                       for(var i = 6; i >= 0; --i)
                                         PedidosReservasSeries(
                                             data: DateFormat(DateFormat.ABBR_WEEKDAY,'pt_Br').format(DateTime.now().subtract(Duration(days: i))).toString().toUpperCase(),
                                             qtd: grafico2.data![i].docs.length,
                                            barcolor: charts.ColorUtil.fromDartColor(Color(0xff03a9f4))
                                         )],
                                     data2: [
                                       for(var i = 18; i >= 12; --i)
                                         PedidosReservasSeries(
                                             data: DateFormat(DateFormat.ABBR_WEEKDAY,'pt_Br').format(DateTime.now().subtract(Duration(days: i-12))).toString().toUpperCase(),
                                             qtd: grafico2.data![i].docs.length,
                                             barcolor: charts.ColorUtil.fromDartColor(Color(
                                                 0xffa8d8ef))
                                         )
                                     ],
                                   );
                                 } if(n==34){
                                   return PedidosReservasChart(
                                     data: [
                                       for(var i = 11; i >= 7; --i)
                                         PedidosReservasSeries(
                                             data: DateFormat(DateFormat.DAY,'pt_Br').format(DateTime.now().subtract(Duration(days:6+(7*(i-7))))).toString() + '/' + DateFormat(DateFormat.NUM_MONTH,'pt_Br').format(DateTime.now().subtract(Duration(days:6+(7*(i-7))))).toString() +'-'+ DateFormat(DateFormat.DAY,'pt_Br').format(DateTime.now().subtract(Duration(days: 7*(i-7)))).toString()
                                             + '/' + DateFormat(DateFormat.NUM_MONTH,'pt_Br').format(DateTime.now().subtract(Duration(days: 7*(i-7)))).toString(),
                                             qtd: grafico2.data![i].docs.length,
                                             barcolor: charts.ColorUtil.fromDartColor(Color(0xff03a9f4))
                                         )
                                     ],
                                     data2: [
                                       for(var i = 23; i >= 19; --i)
                                         PedidosReservasSeries(
                                             data: DateFormat(DateFormat.DAY,'pt_Br').format(DateTime.now().subtract(Duration(days:6+(7*(i-19))))).toString() + '/' + DateFormat(DateFormat.NUM_MONTH,'pt_Br').format(DateTime.now().subtract(Duration(days:6+(7*(i-19))))).toString() +'-'+ DateFormat(DateFormat.DAY,'pt_Br').format(DateTime.now().subtract(Duration(days: 7*(i-19)))).toString()
                                                 + '/' + DateFormat(DateFormat.NUM_MONTH,'pt_Br').format(DateTime.now().subtract(Duration(days: 7*(i-19)))).toString(),
                                             qtd: grafico2.data![i].docs.length,
                                             barcolor: charts.ColorUtil.fromDartColor(Color(
                                                 0xffa8d8ef))
                                         )
                                     ],
                                   );
                                 }
                                 return PedidosReservasChart(
                                   data: [
                                     for(var i = 35; i >= 24; --i)
                                       PedidosReservasSeries(
                                           data: DateTime(DateTime.now().year,DateTime.now().month-i,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)).month.toString(),
                                           qtd: grafico2.data![i].docs.length,
                                           barcolor: charts.ColorUtil.fromDartColor(Color(0xff03a9f4))
                                       )
                                   ],
                                   data2: [
                                     for(var i = 47; i >= 36; --i)
                                       PedidosReservasSeries(
                                           data: DateTime(DateTime.now().year,DateTime.now().month-i,DateTime.now().day).subtract(Duration(days:DateTime.now().day-1)).month.toString(),
                                           qtd: grafico2.data![i].docs.length,
                                           barcolor: charts.ColorUtil.fromDartColor(Color(
                                               0xffa8d8ef))
                                       )
                                   ],
                                 );
                                 }
                             ),
                           ),
                         ),
                       ),
                     ],
                   ),
                 );
               });
         });
  }
}

class MyCustomClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size){
    final Path path = Path()
    ..lineTo(0,size.height)
    ..lineTo(size.width,size.height)
    ..lineTo(size.width,0)
    ..lineTo(size.width/2+10,0)
    ..quadraticBezierTo(size.width/2,0,size.width/2, 10)
    ..lineTo(size.width/2,size.height/3)
    ..quadraticBezierTo(size.width/2, size.height/3+10, size.width/2-10, size.height/3+10)
    ..lineTo(10,size.height/3+10)
    ..quadraticBezierTo(0,size.height/3+10, 0, size.height/3+20)
    ..lineTo(0, size.height)
    ..close();


    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper)=> false;
}
