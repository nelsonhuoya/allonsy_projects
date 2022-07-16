import 'package:allonsyapp/admin/chat_admin/pedidos_user.dart';
import 'package:allonsyapp/admin/chat_admin/reservas_user.dart';
import 'package:allonsyapp/faleconosco/mensagem_card.dart';
import 'package:allonsyapp/utils/nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ChatDetalhesPage extends StatefulWidget {

  final String email;
  final String user;
  final String url;

  ChatDetalhesPage(this.email, this.user, this.url);


  @override
  _ChatDetalhesPageState createState() => _ChatDetalhesPageState();
}

class _ChatDetalhesPageState extends State<ChatDetalhesPage> {


  final _tTexto = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xF7131313),
      appBar: AppBar(
        centerTitle: false,
        leading: Container(
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            iconSize: 32.sp,
            color: Colors.white,
            onPressed: (){
              Navigator.pop(context);
              FocusScope.of(context).unfocus();
            },
          ),
        ),
        title: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 2.sp,
                        color: Color(0xFF03A9f4))
                ),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(widget.url),
                  radius: 25.r,
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Container(
                width: 220.w,
                child: Text (widget.user,
                  style: GoogleFonts.roboto(
                      fontSize: 25.0.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic
                  ),),
              ),
            ],
          ),
        ),
        toolbarHeight: 60.h,
        leadingWidth: 50.w,
        titleSpacing: 0,
        backgroundColor: Color(0xFF1B1B1B),
        actions: [
          Container(
            padding: EdgeInsets.only(right: 8.w),
            child: Center(child: PopupMenuButton(
              icon: Icon(Icons.dehaze_rounded,
              size: 32.sp,
              color: Colors.white),
              itemBuilder: (_)=> <PopupMenuItem<String>>[
                PopupMenuItem(
                    child: Container(
                      child: Text(
                        "Pedidos",
                        style: GoogleFonts.roboto(
                          fontSize: 18.sp,
                          color: Colors.black
                        ),
                      ),
                    ),
                  value: "pedidos",
                ),
                PopupMenuItem(
                  child: Container(
                    child: Text(
                        "Reservas",
                      style: GoogleFonts.roboto(
                        fontSize: 18.sp,
                        color: Colors.black
                      ),
                    ),
                  ),
                  value: "reservas",
                )
              ],
              onSelected: (index) async {
                switch(index) {
                  case 'pedidos':
                    push(context, PedidosUserAdmin(widget.email, widget.user));
                    break;
                  case 'reservas':
                    push(context,ReservasUserAdmin(widget.email, widget.user));
                    break;
                }
              },
            )
            ),
          ),
        ],
      ),
      body: _body(),
    );
  }

  _body() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(right: 8.w, left: 8.w),
        child: Stack(
          children: [
            Column(
              children: [
                Column(
                  children: [
                    Container(
                      height: 620.h,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection("mensagens").doc(widget.email).collection("mensagens").orderBy("data",descending: true).snapshots(),
                        builder: (BuildContext context, AsyncSnapshot <QuerySnapshot> snapshot){
                          if(!snapshot.hasData){
                            return Text("");
                          }
                          return ListView.builder(
                              shrinkWrap: true,
                              reverse: true,
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (BuildContext context, int index){
                                if(index == snapshot.data!.docs.length - 1 || DateFormat(DateFormat.YEAR_MONTH_DAY,'pt_Br').format(snapshot.data!.docs.elementAt(index)['data'].toDate()).toString()
                                    != DateFormat(DateFormat.YEAR_MONTH_DAY,'pt_Br').format(snapshot.data!.docs.elementAt(index+1)['data'].toDate()).toString()){
                                  return Column(
                                    children: [
                                      Container(
                                        child: Text(
                                          DateFormat(DateFormat.YEAR_MONTH_DAY,'pt_Br').format(snapshot.data!.docs.elementAt(index)['data'].toDate()).toString(),
                                          style: GoogleFonts.roboto(
                                              color:Colors.grey.withOpacity(0.9),
                                              fontSize: 22.sp,
                                              fontWeight: FontWeight.w600
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      MensagemCard(
                                          snapshot.data!.docs.elementAt(index)['texto'],
                                          snapshot.data!.docs.elementAt(index)['enviado'],
                                          snapshot.data!.docs.elementAt(index)['data'].toDate()
                                      ),
                                      SizedBox(
                                          height: 10.h
                                      )
                                    ],
                                  );
                                } else {
                                  return Column(
                                    children: [
                                      MensagemCard(
                                          snapshot.data!.docs.elementAt(index)['texto'],
                                          snapshot.data!.docs.elementAt(index)['enviado'],
                                          snapshot.data!.docs.elementAt(index)['data'].toDate()
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      )
                                    ],
                                  );
                                }
                              }
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                Row(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: 400.h,
                        minHeight: 65.h
                      ),
                      child: Container(
                        width: 310.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.sp),
                          color: Colors.white,
                          border: Border.all(
                              width: 4.sp,
                              color: Color(0xFF03A9f4)
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              child: Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 15.w, right: 15.w),
                                    child: TextField(
                                      style: GoogleFonts.roboto(
                                        fontSize: 22.sp,
                                      ),
                                      decoration: InputDecoration(
                                          hintText: "Escreva sua mensagem...",
                                          hintStyle: GoogleFonts.roboto(
                                            fontSize: 20.sp,
                                            color: Colors.grey.withOpacity(0.9),
                                          ),
                                          border: InputBorder.none
                                      ),
                                      controller: _tTexto,
                                      maxLines: null,
                                      textCapitalization: TextCapitalization.sentences,
                                      keyboardType: TextInputType.multiline,
                                    ),
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: 72.h,
                  width: 65.w,
                  child: FloatingActionButton(
                    onPressed: (){
                      if(_tTexto.text.trim().isNotEmpty){
                        FirebaseFirestore.instance.collection("mensagens").doc(widget.email).update({
                          "usuariomsg": "Allons-y",
                          "texto":_tTexto.text.trim(),
                          "data": DateTime.now()

                        });
                        FirebaseFirestore.instance.collection("mensagens").doc(widget.email).collection("mensagens").doc().set({
                          "texto": _tTexto.text.trim(),
                          "data": DateTime.now(),
                          "enviado": false,
                        });
                      }
                      _tTexto.clear();
                      FocusScope.of(context).unfocus();
                    },
                    child: Icon(Icons.send,
                        color: Colors.white,
                        size: 32.sp),
                    backgroundColor: Color(0xFF03A9f4),
                    elevation: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
