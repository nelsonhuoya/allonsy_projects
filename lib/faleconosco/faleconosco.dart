import 'package:allonsyapp/faleconosco/mensagem_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class FaleConoscoPage extends StatefulWidget {

  final user = FirebaseAuth.instance.currentUser;

  @override
  _FaleConoscoPageState createState() => _FaleConoscoPageState();
}

class _FaleConoscoPageState extends State<FaleConoscoPage> {

  final _tTexto = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xF7131313),
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          iconSize: 32.sp,
          color: Colors.white,
          onPressed: (){
            Navigator.pop(context);
            FocusScope.of(context).unfocus();
          },
        ),
        title: Text ( "Fale Conosco",
          style: GoogleFonts.dancingScript(
              fontSize: 45.0.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),),
        toolbarHeight: 60.h,
        backgroundColor: Color(0xFF1B1B1B),
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
                      height: 621.h,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection("mensagens").doc(widget.user!.email).collection("mensagens").orderBy("data",descending: true).snapshots(),
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
                  height: 68.h,
                  width: 60.w,
                  child: FloatingActionButton(
                    onPressed: (){
                      if(_tTexto.text.trim().isNotEmpty){
                        FirebaseFirestore.instance.collection("mensagens").doc(widget.user!.email).set({
                          "texto":_tTexto.text.trim(),
                          'email': widget.user!.email,
                          'usuario':widget.user!.displayName== null? widget.user!.email: widget.user!.displayName,
                          "usuariomsg":widget.user!.displayName== null? widget.user!.email: widget.user!.displayName,
                          "url":widget.user!.photoURL== null? "https://i1.wp.com/terracoeconomico.com.br/wp-content/uploads/2019/01/default-user-image.png?ssl=1": widget.user!.photoURL,
                          "data": DateTime.now()

                        });
                        FirebaseFirestore.instance.collection("mensagens").doc(widget.user!.email).collection("mensagens").doc().set({
                          "texto": _tTexto.text.trim(),
                          "data": DateTime.now(),
                          "enviado": true,
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
