import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class ReservasUserAdmin extends StatefulWidget {

  final String email;
  final String user;

  ReservasUserAdmin(this.email, this.user);

  @override
  _ReservasUserAdminState createState() => _ReservasUserAdminState();
}

class _ReservasUserAdminState extends State<ReservasUserAdmin> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        title: Text ("Reservas do " + widget.user,
          style: GoogleFonts.dancingScript(
              fontSize: 35.0.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),),
      ),
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
                  stream: FirebaseFirestore.instance.collection("reservas").orderBy("data").where("user", isEqualTo: widget.email).where("data", isGreaterThan: DateTime.now()).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                    if(!snapshot.hasData){
                      return Text("");
                    }
                    if(snapshot.data!.docs.isEmpty){
                      return Container(
                        child: Center(
                          child: Text(
                            "O usuário ainda não tem reservas",
                            style: GoogleFonts.roboto(
                                color: Color(0xFF03A9f4),
                                fontSize: 22.sp
                            ),
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemExtent: 230.h,
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
                                      padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 5.h, bottom: 10.h),
                                      child: Container(
                                        child: Column(
                                          children: [
                                            Container(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons.person,
                                                            size: 32.sp,
                                                            color: Color(0xFF03A9f4)),
                                                        SizedBox(
                                                          width: 10.w,
                                                        ),
                                                        Text(snapshot.data!.docs.elementAt(index)["user"],
                                                          style: GoogleFonts.roboto(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: 25.sp
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
                                                  Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Container(
                                                      height: 50.h,
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
                                                  Container(
                                                    child: Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text(
                                                        "Horário: " + snapshot.data!.docs.elementAt(index)["hora"],
                                                        style: GoogleFonts.roboto(
                                                            fontSize: 20.sp,
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.bold
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: 5.h
                                                  ),
                                                  Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(
                                                      "Nº de pessoas: " + snapshot.data!.docs.elementAt(index)["pessoas"].toString(),
                                                      style: GoogleFonts.roboto(
                                                          fontSize: 20.sp,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: 5.h
                                                  ),
                                                  Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Text(
                                                      "ID: " + snapshot.data!.docs.elementAt(index).id,
                                                      style: GoogleFonts.roboto(
                                                          fontSize: 20.sp,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w400
                                                      ),
                                                    ),
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
                        });
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}