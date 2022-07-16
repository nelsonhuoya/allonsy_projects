import 'package:allonsyapp/inicio/background.dart';
import 'package:allonsyapp/firebase/api_response.dart';
import 'package:allonsyapp/firebase/firebase_service.dart';
import 'package:allonsyapp/utils/nav.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:allonsyapp/firebase/alert.dart';
import 'package:google_fonts/google_fonts.dart';



class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 60.h,
        width: 400.w,
        margin: EdgeInsets.only(top: 12.h),
      child: _isSigningIn == true? CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      )
          : GoogleAuthButton(
          text: "Entre com sua conta do Google",
          style: AuthButtonStyle(
              textStyle: GoogleFonts.roboto(
                fontSize: 20.sp,
                color: Colors.black
              ),
              iconType: AuthIconType.outlined,
          ),
          onPressed: () async {
            setState(() {
              _isSigningIn = true;
            });
            final service = FirebaseService();
            ApiResponse response = await service.loginGoogle();
            if(response.ok!){
              push(context, BackGroundPage(),replace: true);
            } else {
              alert(context,response.msg!);
              setState(() {
                _isSigningIn = false;
              });
            }
          })
    );
  }
}
