
import 'package:allonsyapp/pedidos/resumopedido.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class PedidosDetalhesAdmin extends StatelessWidget {

  final user = FirebaseAuth.instance.currentUser;

  final String? id;

  final data;

  final bool? retirada;

  final String? endereco;

  final String? complemento;

  PedidosDetalhesAdmin({this.id, this.data, this.retirada, this.endereco, this.complemento});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          iconSize: 32.sp,
          color: Colors.white,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        toolbarHeight: 60.h,
        backgroundColor: Color(0xFF1B1B1B),
        centerTitle: true,
        title: Text("Pedido #"+id!,
          style: GoogleFonts.roboto(
              fontSize: 40.0.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),),
        actions: <Widget>[
        ],
      ),
      body: _body(),
    );
  }

  _body() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("pedidos").doc(id).collection("itens").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot ){
          if(!snapshot.hasData){
            return Text("");
          }
          var ds = snapshot.data!.docs;
          double total = 0.00;
          for(int i = 0; i<ds.length;i++)
            total+= (ds[i]["total"]);
          double taxaentrega =  0.00;
          return Padding(
            padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 5.h),
            child: Column(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: 559.h,
                      minHeight: 400.h
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 90.h,
                            child: Padding(
                              padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 8.w),
                              child: Container(
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Icon(
                                            Icons.calendar_today_sharp,
                                            color: Color(0xFF03A9f4),
                                            size: 28.sp,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8.w),
                                          child: Container(
                                            child: Text(
                                              "Data do Pedido:",
                                              style: GoogleFonts.roboto(
                                                  color: Colors.black,
                                                  fontSize: 22.sp,
                                                  fontWeight: FontWeight.w600
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 38.w),
                                      child: Container(
                                        height: 35.h,
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 10.h),
                                          child: Text(
                                            DateFormat(DateFormat.YEAR_MONTH_DAY,'pt_Br').format(data).toString()
                                                + " às "+ DateFormat(DateFormat.HOUR24_MINUTE,'pt_Br').format(data).toString(),
                                            style: GoogleFonts.roboto(
                                              color: Colors.black,
                                              fontSize: 18.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 2.sp,
                            height: 1.h,
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          Container(
                            height: 90.h,
                            child: Padding(
                              padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 8.w),
                              child: Container(
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Icon(
                                            Icons.person,
                                            color: Color(0xFF03A9f4),
                                            size: 28.sp,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 8.w),
                                          child: Container(
                                            child: Text(
                                              "Email:",
                                              style: GoogleFonts.roboto(
                                                  color: Colors.black,
                                                  fontSize: 22.sp,
                                                  fontWeight: FontWeight.w600
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 38.w),
                                      child: Container(
                                        height: 40.h,
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 10.h),
                                          child: Text(
                                            user!.email.toString(),
                                            style: GoogleFonts.roboto(
                                              color: Colors.black,
                                              fontSize: 18.sp,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 2.sp,
                            height: 1.h,
                            color: Colors.grey.withOpacity(0.3),
                          ),
                          Container(
                            child: Column(
                              children: [
                                Container(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 8.w, top: 15.h, bottom: 10.h),
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                child: Icon(
                                                  Icons.description_outlined,
                                                  color: Color(0xFF03A9f4),
                                                  size: 28.sp,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  "Resumo do Pedido:",
                                                  style: GoogleFonts.roboto(
                                                      color: Colors.black,
                                                      fontSize: 22.sp,
                                                      fontWeight: FontWeight.w600
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 15.h, left: 6.w),
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                scrollDirection: Axis.vertical,
                                                itemCount: snapshot.data!.docs.length,
                                                itemBuilder: (BuildContext context, int index){
                                                  return ResumoCard(
                                                      snapshot.data!.docs.elementAt(index)["qtd"],
                                                      snapshot.data!.docs.elementAt(index)["nome"],
                                                      snapshot.data!.docs.elementAt(index)["total"],
                                                      snapshot.data!.docs.elementAt(index)["observacao"]);
                                                }
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Divider(
                                  thickness: 2.sp,
                                  height: 1.h,
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 8.h, top: 10.h),
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              child: Icon(
                                                Icons.where_to_vote_outlined,
                                                color: Color(0xFF03A9f4),
                                                size: 28.sp,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 9.w,
                                            ),
                                            Container(
                                              alignment: Alignment.centerLeft,
                                              child: Text(retirada == false
                                                  ? "Endereço de Entrega:"
                                                  : "Pedido Retirado em",
                                                style: GoogleFonts.roboto(
                                                    color: Colors.black,
                                                    fontSize: 22.sp,
                                                    fontWeight: FontWeight.w600
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 40.w, right: 90.w),
                                          child: Container(
                                            alignment: Alignment.topLeft,
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 10.h),
                                              child: Text(endereco!,
                                                style: GoogleFonts.roboto(
                                                  color: Colors.black,
                                                  fontSize: 18.sp,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 40.w, right: 100.w, bottom: 10.h),
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 10.h),
                                            child: complemento!.length>0? Container(
                                              child: Align(
                                                alignment: Alignment.bottomLeft,
                                                child: Text(complemento!,
                                                  style: GoogleFonts.roboto(
                                                    color: Colors.grey.shade900.withOpacity(0.7),
                                                    fontSize: 18.sp,
                                                  ),
                                                ),
                                              ),
                                            ): null,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 2.sp,
                  height: 1.h,
                  color: Color(0xFF03A9f4).withOpacity(0.5),
                ),
                Container(
                  height: 90.h,
                  child: Padding(
                    padding: EdgeInsets.only(top: 5.h, right: 8.w, left: 8.w),
                    child: Container(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Subtotal",
                                style: GoogleFonts.roboto(
                                    fontSize: 25.sp,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(
                                "R\$"+total.toStringAsFixed(2),
                                style: GoogleFonts.roboto(
                                    fontSize: 25.sp,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Taxa de Entrega",
                                style: GoogleFonts.roboto(
                                    fontSize: 25.sp,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(
                                "R\$"+taxaentrega.toStringAsFixed(2),
                                style: GoogleFonts.roboto(
                                    fontSize: 25.sp,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(
                  thickness: 2.sp,
                  height: 1.h,
                  color: Color(0xFF03A9f4).withOpacity(0.5),
                ),
                Container(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total",
                            style: GoogleFonts.roboto(
                                fontSize: 40.sp,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            "R\$"+(total+taxaentrega).toStringAsFixed(2),
                            style: GoogleFonts.roboto(
                                fontSize: 40.sp,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}

