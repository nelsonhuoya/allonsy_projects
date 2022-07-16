import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:allonsyapp/inicio/background.dart';
import 'package:allonsyapp/inicio/loginpage.dart';
import 'package:allonsyapp/utils/nav.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xF7131313),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 11,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Text('Allons-y',
                  style: GoogleFonts.dancingScript(
                    fontSize: 100.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  )),
                ),
              ),
              Flexible(
                flex: 10,
                child: Container(
                  padding: EdgeInsets.only(bottom: 50.h),
                  alignment: Alignment.bottomCenter,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF03A9f4)
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void startTimer() {
    Timer(Duration(seconds: 2), () {
      _navigateUser();
    });
  }

  Future<Null> _navigateUser() async {
    final user = FirebaseAuth.instance.currentUser;
    if(user != null){
      push(context, BackGroundPage(), replace: true);
    } else {
      push(context, LoginPage(), replace: true);
    }
  }
}
