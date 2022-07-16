import 'package:allonsyapp/faleconosco/faleconosco.dart';
import 'package:allonsyapp/pedidos/pedidoaberto_lista.dart';
import 'package:allonsyapp/pedidos/pedidos_detalhes.dart';
import 'package:allonsyapp/utils/nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class PedidosCard extends StatefulWidget {

  final user = FirebaseAuth.instance.currentUser;
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


  PedidosCard(this.data, this.numero, this.qtditens,this.qtdprimeiroprato, this.primeiroprato, this.retirada, this.situacao, this.timer, this.id, this.endereco, this.complemento);

  @override
  _PedidosCardState createState() => _PedidosCardState();
}

class _PedidosCardState extends State<PedidosCard> {
  var ativo;

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
                DateFormat(DateFormat.ABBR_WEEKDAY,'pt_Br').format(widget.data).toString().characters.first.toUpperCase()+
                    DateFormat(DateFormat.ABBR_WEEKDAY,'pt_Br').format(widget.data).toString().substring(1)+ ", "+
                    DateFormat(DateFormat.YEAR_MONTH_DAY,'pt_Br').format(widget.data).toString(),
              style: TextStyle(
                  fontSize: 26.sp,
                  color: Colors.grey.withOpacity(0.9)
              ),
            ),
          ),
          SizedBox(height: 15.h,
          ),
          GestureDetector(
            onTap: (){
              push(context, PedidosDetalhes(id:widget.id, data: widget.data, retirada: widget.retirada, endereco: widget.endereco, complemento: widget.complemento));
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0.sp),
                  border: Border.all(
                      width: 5.w,
                      color: Color(0xFF03A9f4)
                  )
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 8.h,bottom: 8.h,right: 8.w, left: 8.w),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Pedido: #${widget.numero}",
                          style: GoogleFonts.roboto(
                              fontSize: 20.sp,
                              color: Colors.black
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: widget.situacao == "Entregue"? Colors.green :
                              widget.situacao == "Enviado"? Colors.yellow :
                              widget.situacao == "Cancelado"? Colors.red :
                              Color(0xFF03A9f4),
                              borderRadius: BorderRadius.circular(40)
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child:
                            widget.situacao == "Entregue"?
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
                            ):
                            widget.situacao == "Enviado"?
                            Row(
                              children: [
                                Text(
                                  "Enviado",
                                  style: GoogleFonts.roboto(
                                      fontSize: 18.sp,
                                      color: Colors.black
                                  ),
                                ),
                              ],
                            ):
                            widget.situacao == "Cancelado"?
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
                            ):
                            Text(
                              widget.situacao,
                              style: GoogleFonts.roboto(
                                  fontSize: 18.sp,
                                  color: Colors.black
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
                                widget.retirada == false? Icons.delivery_dining: Icons.store,
                                size: 28.sp,
                                color: Colors.grey.shade600,
                              )
                            ],
                          ),
                          SizedBox(height: 6.h),
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
                                        fontSize: 22.sp,
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
                              widget.qtditens>1? Container(
                                margin: EdgeInsets.only(top:6.h),
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  widget.qtditens>2?
                                  "mais " + (widget.qtditens-1).toString()+ " itens":
                                  "mais 1 item",
                                  style: GoogleFonts.roboto(
                                      fontSize: 20.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ): Container(),
                            ],
                          ),

                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey.withOpacity(0.2),
                      thickness: 2.sp,
                    ),
                    SizedBox(
                      height: 3.h,
                    ),
                    Row(
                      children: [
                        Flexible(
                          flex: 1,
                          child: GestureDetector(
                            onTap: (){
                              push(context, FaleConoscoPage());
                            },
                            child: Center(
                              child: Text(
                                "Ajuda",
                                style: GoogleFonts.roboto(
                                    fontSize: 20.sp,
                                    color: Color(0xFF03A9f4)
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () async {
                                await FirebaseFirestore.instance.collection("pedidos").
                                doc(widget.numero).collection("itens").get().then((value) {
                                  for (var data in value.docs){
                                    FirebaseFirestore.instance.collection("pratos").where("nome", isEqualTo: data.data()['nome'])
                                        .get().then((QuerySnapshot querySnapshot){
                                      querySnapshot.docs.forEach((doc) {
                                        if(doc["ativo"] == true){
                                          FirebaseFirestore.instance.collection("pedidosemaberto").doc((widget.user!.email).toString()).collection("pedidosemaberto").doc().set({
                                            'nome':data.data()["nome"],
                                            'qtd':data.data()["qtd"],
                                            'preco':data.data()["preco"],
                                            'total':data.data()["total"],
                                            'observacao': data.data()["observacao"],
                                            'url': data.data()["url"]
                                          });
                                        } else {
                                          final snackBar = SnackBar(
                                            padding: EdgeInsets.only(left: 40.w, right: 40.w),
                                            content: Text(data.data()['nome']+ " não está disponível atualmente no nosso menu.",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.roboto(
                                                  color: Colors.black,
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.bold
                                              ),),
                                            backgroundColor: Colors.white,
                                          );
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        }
                                      });
                                    });
                                  }
                                });
                                await FirebaseFirestore.instance.collection("pedidosemaberto").doc((widget.user!.email).toString()).collection("pedidosemaberto").get().then((pedidosemaberto) {
                                  print(pedidosemaberto.docs.length);
                                });
                              push(context, PedidoabertoPage());
                            },
                            child: Center(
                              child: Text(
                                "Repetir Pedido",
                                style: GoogleFonts.roboto(
                                    fontSize: 20.sp,
                                    color: Color(0xFF03A9f4)
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 3.h,
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
