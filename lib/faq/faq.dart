import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({Key? key}) : super(key: key);

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
        title: Text ( "FAQ",
          style: GoogleFonts.dancingScript(
              fontSize: 40.0.sp,
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
    return Container(
    );
  }
}
