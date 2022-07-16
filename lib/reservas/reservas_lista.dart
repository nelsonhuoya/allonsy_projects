import 'package:allonsyapp/reservas/qrcode_details.dart';
import 'package:allonsyapp/reservas/reservas.dart';
import 'package:allonsyapp/utils/nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReservaListaPage extends StatefulWidget {

  @override
  _ReservaListaPageState createState() => _ReservaListaPageState();
}

class _ReservaListaPageState extends State<ReservaListaPage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xF7131313),
      body: _body(),
    );
  }

  _body() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: 8.0.w, right: 8.w, top: 10.h),
        child: Column(
          children: [
            Flexible(
              flex: 9,
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection("reservas").where("user", isEqualTo:user!.email).orderBy("data").where("data", isGreaterThan: DateTime.now()).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                    if(snapshot.hasError) {
                      return Center(
                        child: Text(
                          "Não foi possível carregar as reservas",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 22.sp
                          ),
                        ),
                      );
                    }
                    if(!snapshot.hasData){
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if(snapshot.data!.docs.isEmpty){
                      return Container(
                        child: Center(
                          child: Text(
                            "Você não tem reservas",
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 22.sp
                            ),
                          ),
                        ),
                      );
                    }
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 8.0.w, right: 8.0.w, top: 5.h,bottom: 20.h),
                          child: Container(
                            height: 30.h,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                child: Text(
                                  "Suas Reservas",
                                  style: GoogleFonts.roboto(
                                      fontSize: 26.sp,
                                      color: Colors.grey.withOpacity(0.9)
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 490.h,
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (BuildContext context, int index){
                                return Stack(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 15.h),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Colors.white,
                                          border: Border.all(
                                            width: 5.sp,
                                            color: Color(0xFF03A9f4)
                                          )
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 10.w, right: 10.w, bottom: 5.h),
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Container(
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        child: Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: Text(
                                                            "Allons-y",
                                                            style: GoogleFonts.dancingScript(
                                                                fontSize: 45.sp,
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.bold
                                                            ),
                                                          ),
                                                        ),
                                                        padding: EdgeInsets.only(left: 5.w),
                                                      ),
                                                      Container(
                                                        child: Row(
                                                          children: [
                                                            Icon(Icons.where_to_vote_outlined,
                                                            size: 25.sp,
                                                            color: Color(0xFF03A9f4)),
                                                            Text("  Largo da Carioca, Rio das Ostras/RJ",
                                                            style: GoogleFonts.roboto(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: 18.sp
                                                            ),),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(left: 5.w),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 5.h,
                                                      ),
                                                      Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: Container(
                                                          height: 40.h,
                                                          width: 250.h,
                                                          child: Align(
                                                            alignment: Alignment.centerLeft,
                                                            child: Text(snapshot.data!.docs.elementAt(index)["dia"],
                                                              style: GoogleFonts.roboto(
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.bold,
                                                                fontSize: 22.sp
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          height: 5.h
                                                      ),
                                                      Container(
                                                        child: Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: Text(
                                                            "Horário: " + snapshot.data!.docs.elementAt(index)["hora"],
                                                            style: GoogleFonts.roboto(
                                                                fontSize: 18.sp,
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.w600
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          height: 5.h
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            "Nº de pessoas: ",
                                                            style: GoogleFonts.roboto(
                                                                fontSize: 18.sp,
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.w600
                                                            ),
                                                          ),
                                                          Text(
                                                            snapshot.data!.docs.elementAt(index)["pessoas"].toString(),
                                                            style: GoogleFonts.roboto(
                                                                fontSize: 18.sp,
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.w500
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ),
                                    ),
                                    Positioned.fill(
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 20.0.h,right: 10.w),
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: Container(
                                            child: GestureDetector(
                                              onTap: (){
                                                push(context, QrCodePage(snapshot.data!.docs.elementAt(index).id
                                                ));
                                                },
                                              child: QrImage(
                                                data: snapshot.data!.docs.elementAt(index).id,
                                                version: QrVersions.auto,
                                                size: 100.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10.0.h,right: 10.w),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          child: GestureDetector(
                                            onTap:(){
                                              FirebaseFirestore.instance.collection("reservas").doc(snapshot.data!.docs[index].id).delete();
                                            },
                                            child: Icon(
                                              Icons.clear,
                                              size: 32.sp,
                                              color: Color(0xFF03A9f4),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ),
                      ],
                    );
                  }
              ),
            ),
            Flexible(
              flex: 1,
              child: GestureDetector(
                onTap: () async {
                  if(await InternetConnectionChecker().hasConnection == false){
                    showSimpleNotification(
                        Text(
                          "Sem Internet",
                          style: TextStyle(color: Colors.white, fontSize: 20.sp),
                        ),
                        background: Colors.red
                    );
                  } else {
                    push(context,ReservasPage());
                  }

                },
                child: Container(
                  height: 60.h,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFF03A9f4)
                  ),
                  child: Center(
                    child: Text(
                        "Reserve uma mesa",
                        style: GoogleFonts.roboto(
                            fontSize: 26.sp,
                            color: Colors.white
                        )
                    ),
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

