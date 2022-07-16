import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

alert(BuildContext context, String msg, {Function? callback}){
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context){
        return WillPopScope(onWillPop: () async => false,
          child: AlertDialog(
            content: Text(msg,
            textAlign: TextAlign.justify,
            style: GoogleFonts.roboto(
              color: Colors.black,
              fontSize: 20.sp
            ),
            ),
            actions: <Widget> [
              TextButton(
              child: Text("Ok",
                  style: GoogleFonts.roboto(
                    fontSize:18.sp,
                    color: Colors.black
                  )),
              onPressed: () {
                Navigator.pop(context);
                if(callback !=null){
                  callback();
                }
            })
            ],
          )
        );
      }
  );
}