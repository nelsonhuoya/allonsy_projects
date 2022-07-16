import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EnderecoCard extends StatefulWidget {

  final String rua;
  final String CEP;
  final String bairro;
  final String cidade;
  final String complemento;
  final String numero;
  final String id;
  final bool ativo;

  EnderecoCard(this.rua, this.CEP, this.bairro,this.cidade,this.complemento,this.numero, this.id, this.ativo);

  @override
  _EnderecoCardState createState() => _EnderecoCardState();
}

class _EnderecoCardState extends State<EnderecoCard> {


  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0.sp),
      child: Container(
        decoration: BoxDecoration(
          color:Colors.white,
          border: Border.all(
            width: 5.sp,
              color: widget.ativo == true ? Color(0xFF03A9f4): Colors.grey.shade400
          ),
          borderRadius: BorderRadius.circular(20.sp)
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 4.w, top: 4.h),
              child: Container(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: (){
                      setState(() {
                        FirebaseFirestore.instance.collection("users").doc(user!.email).
                        collection("endereços").doc(widget.id).delete();
                      });
                  },
                  child: Icon(
                      Icons.clear,
                      size: 28.sp,
                      color: widget.ativo == true ? Color(0xFF03A9f4): Colors.grey.shade400
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0.sp),
              child: Column(
                children: [
                  Container(
                    child: Row(
                      children: [
                        Icon(
                          Icons.where_to_vote_outlined,
                          color: widget.ativo == true ? Color(0xFF03A9f4): Colors.grey.shade400,
                          size: 28.sp,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                            "Endereço de Entrega:",
                          style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w600
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 35.0.w, top: 3.h),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: 280.w,
                                child: Text(
                                  widget.rua+" nº "+ widget.numero + ", "+ widget.bairro + ", "+ widget.cidade + ", "+widget.CEP,
                                  style: GoogleFonts.roboto(
                                    fontSize: 20.sp,
                                    color: Colors.black
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Container(
                              height: 50.h,
                              child: Stack(
                                children: [
                                  Row(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          width: 230.w,
                                          child: Text(
                                            widget.complemento,
                                            textAlign: TextAlign.start,
                                            style: GoogleFonts.roboto(
                                              fontSize: 18.sp,
                                              color: Colors.grey.shade900.withOpacity(0.7),
                                            ),
                                          )
                                        ),
                                      ),
                                    ],
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      width: 75.w,
                                      child: FlutterSwitch(
                                        value: widget.ativo,
                                        activeColor: Color(0xFF03A9f4),
                                        inactiveColor: Colors.white.withOpacity(
                                            0.9),
                                        toggleColor: Colors.white.withOpacity(0.9),
                                        valueFontSize: 16.sp,
                                        toggleSize: 20.sp,
                                        activeText: "Ativo",
                                        inactiveText: "",
                                        inactiveToggleColor: Colors.grey.shade600,
                                        activeTextColor: Colors.white,
                                        borderRadius: 30.sp,
                                        inactiveSwitchBorder: Border.all(
                                            color: Colors.grey.shade400,
                                            width: 3.w
                                        ),
                                        width: 100.w,
                                        height: 40.h,
                                        showOnOff: true,
                                        onToggle: (val) {
                                            FirebaseFirestore.instance.collection("users").
                                            doc(user!.email).collection("endereços").get().then((value) {
                                              for (var data in value.docs){
                                                if(data.id != widget.id){
                                                  FirebaseFirestore.instance.collection("users").doc(user!.email).
                                                  collection("endereços").doc(data.id).update({
                                                    "ativo":false
                                                  });
                                                }
                                                FirebaseFirestore.instance.collection("users").doc(user!.email)
                                                    .collection("endereços").doc(widget.id).update({
                                                  "ativo":val
                                                });
                                              }
                                            });
                                        },
                                      ),
                                    ),
                                  )
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
            ),
          ],
        ),
      ),
    );
  }
}
