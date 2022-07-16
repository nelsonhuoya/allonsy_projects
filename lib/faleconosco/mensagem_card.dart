import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class MensagemCard extends StatelessWidget {

  final String texto;
  final bool enviado;
  var data;

  MensagemCard(this.texto,this.enviado,this.data);

  final email = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    if(email == "nelsonhouya@gmail.com"){
      return Container(
        padding: EdgeInsets.only(left: 14.w,right: 14.w,top: 10.h,bottom: 10.h),
        child: Align(
          alignment: enviado == true? Alignment.topRight: Alignment.topLeft,
          child: Stack(
            children: [
              ConstrainedBox(
                  constraints: BoxConstraints(
                      maxWidth: 300.w,
                      minHeight: 50.h
                  ),
                  child: Container(
                    padding: EdgeInsets.only(bottom: 5.h),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.sp),
                        color: enviado == false? Colors.white : Color(0xFF03A9f4)
                    ),
                    child: Padding(
                      padding: texto.length <6? EdgeInsets.only(bottom: 16.h, top: 16.h, right: 30.h,left: 16.h) :
                      EdgeInsets.only(bottom: 16.h, top: 16.h, right: 16.h,left: 16.h),
                      child: Text(
                        texto,
                        style: GoogleFonts.roboto(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            color: enviado == false? Color(0xFF03A9f4) : Colors.white
                        ),
                      ),
                    ),
                  )),
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.only(bottom:3.h,right: 8.0.w),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      DateFormat(DateFormat.HOUR24_MINUTE,'pt_Br').format(data).toString(),
                      style: GoogleFonts.roboto(
                          color: enviado == false? Color(0xFF03A9f4) : Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } return Container(
      padding: EdgeInsets.only(left: 14.w,right: 14.w,top: 10.h,bottom: 10.h),
      child: Align(
        alignment: enviado == false? Alignment.topRight: Alignment.topLeft,
        child: Stack(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 300.w,
                minHeight: 50.h
              ),
              child: Container(
                padding: EdgeInsets.only(bottom: 5.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.sp),
                color: enviado == false? Colors.white : Color(0xFF03A9f4)
              ),
              child: Padding(
                padding: texto.length <6? EdgeInsets.only(bottom: 16.h, top: 16.h, right: 30.h,left: 16.h) :
                EdgeInsets.only(bottom: 16.h, top: 16.h, right: 16.h,left: 16.h),
                child: Text(
                  texto,
                  style: GoogleFonts.roboto(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: enviado == false? Color(0xFF03A9f4) : Colors.white
                  ),
                ),
              ),
            )),
            Positioned.fill(
              child: Padding(
                padding: EdgeInsets.only(bottom:3.h,right: 8.0.w),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                      DateFormat(DateFormat.HOUR24_MINUTE,'pt_Br').format(data).toString(),
                    style: GoogleFonts.roboto(
                      color: enviado == false? Color(0xFF03A9f4) : Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400
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
