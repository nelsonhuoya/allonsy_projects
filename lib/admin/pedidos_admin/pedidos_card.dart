import 'package:allonsyapp/admin/pedidos_admin/pedidos_detalhes.dart';
import 'package:allonsyapp/utils/nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class PedidosCardAdmin extends StatefulWidget {
  final data;
  final String numero;
  final int qtditens;
  final int qtdprimeiroprato;
  final String primeiroprato;
  final bool retirada;
  final String situacao;
  var timer;
  final String id;
  final String endereco;
  final String complemento;
  final String email;


  PedidosCardAdmin(this.data, this.numero, this.qtditens,this.qtdprimeiroprato, this.primeiroprato, this.retirada, this.situacao, this.timer, this.id, this.endereco, this.complemento, this.email);

  @override
  _PedidosCardAdminState createState() => _PedidosCardAdminState();
}

class _PedidosCardAdminState extends State<PedidosCardAdmin> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 16.w, left: 16.w),
      child: Column(
        children: [
          SizedBox(
            height: 20.h,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              DateFormat(DateFormat.ABBR_WEEKDAY, 'pt_Br')
                  .format(widget.data)
                  .toString()
                  .characters
                  .first
                  .toUpperCase() +
                  DateFormat(DateFormat.ABBR_WEEKDAY, 'pt_Br').format(
                      widget.data).toString().substring(1) + ", " +
                  DateFormat(DateFormat.YEAR_MONTH_DAY, 'pt_Br').format(
                      widget.data).toString(),
              style: TextStyle(
                  fontSize: 24.sp,
                  color: Colors.grey.withOpacity(0.9)
              ),
            ),
          ),
          SizedBox(height: 20.h,
          ),
          GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              push(context, PedidosDetalhesAdmin(id: widget.id,
                  data: widget.data,
                  retirada: widget.retirada,
                  endereco: widget.endereco,
                  complemento: widget.complemento));
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0.sp),
                  border: Border.all(
                      width: 5.w,
                      color: Color(0xFF03A9f4)
                  ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    top: 10.h, bottom: 10.h, right: 10.w, left: 10.w),
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: Icon(Icons.person,
                              size: 30.sp,
                              color:Color(0xFF03A9f4),),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Container(
                            width: 280.w,
                            child: Text(
                              widget.email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.roboto(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 22.sp,
                              ),),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey.withOpacity(0.2),
                      thickness: 2.sp,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Pedido: #${widget.numero}",
                          style: GoogleFonts.roboto(
                              fontSize: 24.sp,
                              color: Colors.black
                          ),
                        ),
                        GestureDetector(
                          onTap: (){
                            setState(() {
                              showDialog(
                                  barrierDismissible: true,
                                  context: context,
                                  builder: (context){
                                    return AlertDialog(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(20))),
                                      content: ListView(
                                        shrinkWrap: true,
                                        children: [
                                          Container(
                                              height: 80.h,
                                              width: 100.w,
                                              child: Center(
                                                child: Text("Alterar a situação do pedido para Enviado?",
                                                  textAlign: TextAlign.center,

                                                  softWrap: true,
                                                  style: TextStyle(
                                                    fontSize: 23.sp,
                                                    color: Colors.black,
                                                  ),),
                                              )),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          Container(
                                            height: 50.h,
                                            width: 70.w,
                                            child: GestureDetector(
                                                onTap: (){
                                                  FirebaseFirestore.instance.collection("pedidos").doc((widget.numero).toString()).update({
                                                    'situacao': 'Enviado',
                                                    'horario do envio': DateFormat(DateFormat.HOUR24_MINUTE,'pt_Br').format(Timestamp.now().toDate()).toString()
                                                  });
                                                  Navigator.pop(context);
                                                },
                                                child: Center(
                                                  child: Container(
                                                      width: 220.w,
                                                      decoration: BoxDecoration(
                                                          color: Color(0xFF03A9f4),
                                                          borderRadius: BorderRadius.circular(10)
                                                      ),
                                                      child: Center(
                                                        child: Text("Sim",
                                                          style: TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 20.sp
                                                          ),),
                                                      )),
                                                )),
                                          )
                                        ],
                                      ),
                                    );
                                  });
                            });
                          },
                          onDoubleTap: (){
                            showDialog(
                                barrierDismissible: true,
                                context: context,
                                builder: (context){
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(20))),
                                    content: ListView(
                                      shrinkWrap: true,
                                      children: [
                                        Container(
                                            height: 80.h,
                                            width: 100.w,
                                            child: Center(
                                              child: Text("Alterar a situação do pedido para Entregue?",
                                                textAlign: TextAlign.center,

                                                softWrap: true,
                                                style: TextStyle(
                                                  fontSize: 23.sp,
                                                  color: Colors.black,
                                                ),),
                                            )),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        Container(
                                          height: 50.h,
                                          width: 70.w,
                                          child: GestureDetector(
                                              onTap: (){
                                                FirebaseFirestore.instance.collection("pedidos").doc((widget.numero).toString()).update({
                                                  'situacao': 'Entregue',
                                                });
                                                Navigator.pop(context);
                                              },
                                              child: Center(
                                                child: Container(
                                                    width: 230.w,
                                                    decoration: BoxDecoration(
                                                        color: Color(0xFF03A9f4),
                                                        borderRadius: BorderRadius.circular(10)
                                                    ),
                                                    child: Center(
                                                      child: Text("Sim",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20.sp
                                                        ),),
                                                    )),
                                              )),
                                        )
                                      ],
                                    ),
                                  );
                                });
                          },
                          onLongPress: (){
                            showDialog(
                                barrierDismissible: true,
                                context: context,
                                builder: (context){
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(20))),
                                    content: ListView(
                                      shrinkWrap: true,
                                      children: [
                                        Container(
                                            height: 80.h,
                                            width: 110.w,
                                            child: Center(
                                              child: Text("Alterar a situação do pedido para Cancelado?",
                                                textAlign: TextAlign.center,

                                                softWrap: true,
                                                style: TextStyle(
                                                  fontSize: 23.sp,
                                                  color: Colors.black,
                                                ),),
                                            )),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        Container(
                                          height: 50.h,
                                          width: 70.w,
                                          child: GestureDetector(
                                              onTap: (){
                                                FirebaseFirestore.instance.collection("pedidos").doc((widget.numero).toString()).update({
                                                  'situacao': 'Cancelado',
                                                });
                                                Navigator.pop(context);
                                              },
                                              child: Center(
                                                child: Container(
                                                    width: 240.w,
                                                    decoration: BoxDecoration(
                                                        color: Color(0xFF03A9f4),
                                                        borderRadius: BorderRadius.circular(10)
                                                    ),
                                                    child: Center(
                                                      child: Text("Sim",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20.sp
                                                        ),),
                                                    )),
                                              )),
                                        )
                                      ],
                                    ),
                                  );
                                });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: widget.situacao == "Entregue" ? Colors.green :
                                widget.situacao == "Enviado" ? Colors.yellow :
                                widget.situacao == "Cancelado" ? Colors.red :
                                Color(0xFF03A9f4),
                                borderRadius: BorderRadius.circular(40)
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child:
                              widget.situacao == "Entregue" ?
                              Row(
                                children: [
                                  Text(
                                    "Entregue",
                                    style: GoogleFonts.roboto(
                                        fontSize: 18.sp,
                                        color: Colors.black
                                    ),
                                  ),
                                  Icon(
                                    Icons.check,
                                    size: 18,
                                    color: Colors.black,
                                  )
                                ],
                              ) :
                              widget.situacao == "Enviado" ?
                              Row(
                                children: [
                                  Icon(
                                    Icons.delivery_dining,
                                    size: 20,
                                    color: Colors.black,
                                  ),
                                  Text(
                                    " Enviado",
                                    style: GoogleFonts.roboto(
                                        fontSize: 18.sp,
                                        color: Colors.black
                                    ),
                                  ),
                                ],
                              ) :
                              widget.situacao == "Cancelado" ?
                              Row(
                                children: [
                                  Text(
                                    "Cancelado",
                                    style: GoogleFonts.roboto(
                                        fontSize: 18.sp,
                                        color: Colors.black
                                    ),
                                  ),
                                  Icon(
                                    Icons.clear,
                                    size: 18,
                                    color: Colors.black,
                                  ),
                                ],
                              ) :
                              Text(
                                widget.situacao,
                                style: GoogleFonts.roboto(
                                    fontSize: 18.sp,
                                    color: Colors.black
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Divider(
                      color: Colors.grey.withOpacity(0.2),
                      thickness: 2.sp,
                    ),
                    Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                "Tipo de Entrega:",
                                style: GoogleFonts.roboto(
                                    fontSize: 20.sp,
                                    color: Colors.grey
                                ),
                              ),
                              SizedBox(width: 5.w),
                              Icon(
                                widget.retirada == false
                                    ? Icons.delivery_dining
                                    : Icons.store,
                                size: 28.sp,
                                color: Colors.grey.shade600,
                              )
                            ],
                          ),
                          SizedBox(height: 8.h,),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    color: Colors.grey.withOpacity(0.5),
                                    child: Text(
                                      widget.qtdprimeiroprato.toString(),
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.roboto(
                                        color: Colors.black,
                                        fontSize: 20.sp,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10.w
                                  ),
                                  Text(
                                    widget.primeiroprato,
                                    style: GoogleFonts.roboto(
                                        fontSize: 20.sp,
                                        color: Colors.grey.shade800
                                    ),
                                  ),
                                ],
                              ),
                              widget.qtditens > 1 ? Container(
                                margin: EdgeInsets.only(top: 8.h),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.qtditens > 2 ?
                                  "mais " + (widget.qtditens - 1).toString() +
                                      " itens" :
                                  "mais 1 item",
                                  style: GoogleFonts.roboto(
                                      fontSize: 20.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ) : Container(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}