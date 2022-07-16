import 'package:allonsyapp/admin/chat_admin/chat_detalhes.dart';
import 'package:allonsyapp/firebase/firebase_service.dart';
import 'package:allonsyapp/inicio/loginpage.dart';
import 'package:allonsyapp/utils/nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'dart:math' as math;

class ChatAdmin extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1B1B1B),
        toolbarHeight: 60.h,
        leading: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: IconButton(
            icon: Icon(Icons.exit_to_app),
            iconSize: 32.sp,
            color: Colors.white,
            onPressed: (){
              FirebaseService().logout();
              push(context, LoginPage(), replace: true);
            },
          ),
        ),
        centerTitle: true,
        title: Text ("Allons-y",
          style: GoogleFonts.dancingScript(
              fontSize: 38.0.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),),
      ),
      backgroundColor: Color(0xF7131313),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("mensagens").orderBy("data",descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(snapshot.hasError) {
            return Center(
              child: Text(
                "Não foi possível carregar as mensagens",
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
          if(snapshot.data!.docs.length<1){
            return Center(
                child: Text(
                  "Você ainda não tem mensagens",
                  style: GoogleFonts.roboto(
                      fontSize: 22.sp,
                      color: Color(0xFF03A9f4)
                  ),
                )
            );
          }
          return Padding(
            padding: EdgeInsets.only(top: 5.h),
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (BuildContext context, int index){
                  return Padding(
                    padding: EdgeInsets.only(top: 8.0.h, left: 8.0.w, right: 8.0.w),
                    child: GestureDetector(
                      onTap: (){
                        push(context, ChatDetalhesPage(
                          snapshot.data!.docs.elementAt(index)["email"],
                            snapshot.data!.docs.elementAt(index)["usuario"],
                            snapshot.data!.docs.elementAt(index)["url"]
                        ));
                      },
                      child: Container(
                        height: 100.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.sp),
                          border: Border.all(width: 4.sp, color:Color(0xFF03A9f4))
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(top: 4.0.h, left: 8.0.w, right: 8.0.w,bottom: 4.0.h),
                          child: Row(
                            children: [
                              Flexible(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(width: 2.sp,
                                          color: Color(0xFF03A9f4))
                                  ),
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(snapshot.data!.docs.elementAt(index)["url"]),
                                    radius: 40.r,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Flexible(
                                flex: 3,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(snapshot.data!.docs.elementAt(index)["usuario"],
                                                textAlign: TextAlign.start,
                                                maxLines: 1,
                                                style: GoogleFonts.roboto(
                                                  fontSize: 25.sp,
                                                  fontWeight: FontWeight.w400,
                                                  fontStyle: FontStyle.italic
                                                )),
                                              ),
                                              width: 150.w,
                                            ),
                                            Container(
                                              child: Center(
                                                child: Text(DateFormat(DateFormat.DAY).format(snapshot.data!.docs.elementAt(index)["data"].toDate()).toString() == DateTime.now().day.toString()?
                                                DateFormat(DateFormat.HOUR24_MINUTE,'pt_Br').format(snapshot.data!.docs.elementAt(index)["data"].toDate()).toString():
                                                DateFormat('dd/MM/yyyy').format(snapshot.data!.docs.elementAt(index)["data"].toDate()).toString(),
                                                style: GoogleFonts.roboto(
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Container(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(snapshot.data!.docs.elementAt(index)["usuariomsg"]+ ": "+snapshot.data!.docs.elementAt(index)["texto"],
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                style: GoogleFonts.roboto(
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                          ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
            ),
          );
        },
      ),
    );
  }
}
