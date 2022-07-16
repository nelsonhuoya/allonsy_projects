import 'package:allonsyapp/inicio/background.dart';
import 'package:allonsyapp/inicio/cadastropage.dart';
import 'package:allonsyapp/firebase/alert.dart';
import 'package:allonsyapp/firebase/api_response.dart';
import 'package:allonsyapp/utils/nav.dart';
import 'package:allonsyapp/firebase/google_sign_in_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../firebase/firebase_service.dart';

class LoginPage extends StatefulWidget {

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _password = true;

  final _formKey = GlobalKey<FormState>();
  final _resetKey = GlobalKey<FormFieldState>();
  final _tEmail = TextEditingController();
  final _tSenha = TextEditingController();
  final _tResetar = TextEditingController();

  bool _isSigningIn = false;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xF7131313),
      body: _body(),
    );
  }

  _body() {
    return Center(
      child: SingleChildScrollView(
        child: SafeArea(
          child: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h, bottom: 10.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Allons-y",
                      style: GoogleFonts.dancingScript(
                          fontSize: 90.0.sp,
                          textStyle: TextStyle(color: Colors.white)
                      ),
                    ),
                    SizedBox(height: 15.h),
                    _textFormField(
                      "Email",
                      "Digite seu email",
                      Colors.white,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      controller: _tEmail,
                      validator: _validateEmail,
                      prefixicon: Icon(Icons.person,color:Colors.grey,)),
                    SizedBox(height: 10.h),
                    _textFormField(
                      "Senha",
                      "Digite sua senha",
                      Colors.white,
                      keyboardType: TextInputType.multiline ,
                      textInputAction: TextInputAction.done,
                      controller: _tSenha,
                      validator: _validateSenha,
                      password: _password,
                        prefixicon: Icon(Icons.lock,color:Colors.grey,),
                        suffixicon: IconButton(
                          icon: Icon(
                            _password? Icons.visibility: Icons.visibility_off,
                            color: Colors.grey.withOpacity(0.5)
                        ),
                        onPressed: (){
                          setState(() {
                            _password =!_password;
                          });
                        },
                      )
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 5.w),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          child: GestureDetector(
                            onTap: (){
                              showDialog(
                                  barrierColor: Colors.transparent,
                                  context: context,
                                  builder: (context){
                                    return AlertDialog(
                                      insetPadding:EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                          side: BorderSide(color: Color(0xFF03A9f4),
                                              width: 2.sp),
                                          borderRadius: BorderRadius.all(Radius.circular(20.sp))
                                      ),
                                      title: Text(
                                        "Informe Seu Email",
                                        style: GoogleFonts.roboto(
                                        ),
                                      ),
                                      content: Container(
                                          width: 300.w,
                                          child: _textFormField(
                                              "Email",
                                              "Digite Seu Email",
                                              Colors.black,
                                              key: _resetKey,
                                              controller: _tResetar,
                                              validator: _validadeReset,
                                              prefixicon: Icon(Icons.person,color:Colors.grey))
                                      ),
                                      actions: <Widget>[
                                        ElevatedButton(
                                            child: Text("Cancelar",
                                              style: GoogleFonts.roboto(
                                                  fontSize: 18.sp,
                                                  color: Colors.black
                                              ),),
                                            onPressed: (){
                                              Navigator.pop(context);
                                              _tResetar.clear();
                                            }),
                                        ElevatedButton(
                                            child: Text("Resetar Senha",
                                              style: GoogleFonts.roboto(
                                                  fontSize: 18.sp,
                                                  color: Colors.black
                                              ),),
                                            onPressed: (){
                                              FocusScopeNode currentFocus = FocusScope.of(context);
                                              if (!currentFocus.hasPrimaryFocus) {
                                                currentFocus.unfocus();}
                                              _resetPassword();
                                              _tResetar.clear();
                                            }),

                                      ],
                                    );
                                  });
                            },
                            child: Container(
                              child: Text(
                                "Esqueceu a senha?",
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 18.sp
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    GestureDetector(
                      onTap: (){
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) {
                          currentFocus.unfocus();}
                        _onClickLogin();
                      },
                      child: Container(
                        height: 60.h,
                        decoration: BoxDecoration(
                          color: Color(0xFF03A9f4),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Center(
                        child: _isSigningIn == false? Text(
                            "Entrar",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.sp
                            ),
                          ) : CircularProgressIndicator(
                          color: Colors.white,
                        ),)
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top:15.h, bottom: 1.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Não tem uma conta?",
                            style: TextStyle(
                              color: Color(0xFF03A9f4).withOpacity(0.7),
                              fontSize: 20.sp
                            ),
                          ),
                          GestureDetector(
                            onTap: (){
                              push(context, CadastroPage());
                            },
                            child: Text(
                              " Cadastre-se",
                              style: TextStyle(
                                color: Color(0xFF03A9f4).withOpacity(0.9),
                                fontWeight: FontWeight.bold,
                                fontSize: 20.sp
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 2.h),
                      child: Row(
                        children: <Widget> [
                          buildDivider(),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Text("ou",
                              style: TextStyle(
                                color: Colors.grey.withOpacity(0.8),
                                fontSize: 22.sp,
                              ),
                            ),
                          ),
                          buildDivider(),
                        ],
                      ),
                    ),
                   GoogleSignInButton()
                  ],
                ),
              )
          ),
        ),
      ),
    );
  }

  Expanded buildDivider() {
    return Expanded(
        child: Divider(
          color:Colors.grey.withOpacity(0.8),
          height: 10.h,
          thickness: 1.2.sp,
        )
    );
  }

  _resetPassword() async {
    if(!_resetKey.currentState!.validate()){
      return;
    }
    String email = _tResetar.text.trim();
    try{
      Navigator.pop(context);
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      final snackBar = SnackBar(
        width: 320.w,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
        ),
        content: Text("O email de redefinição de senha foi enviado com sucesso",
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
              color: Colors.black,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold
          ),),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } on FirebaseAuthException catch(e){
      if(e.code == 'user-not-found'){
        final snackBar = SnackBar(
          width: 320.w,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)
          ),
          content: Text("Nenhum usuário foi encontrado para esse email informado",
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
                color: Colors.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold
            ),),
          backgroundColor: Colors.red.shade700,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  _onClickLogin() async {
    if(!_formKey.currentState!.validate()){
      return;
    }
    setState(() {
      _isSigningIn = true;
    });
    String email = _tEmail.text.trim();
    String senha = _tSenha.text.trim();

    print("Login: $email, Senha: $senha");

    final service = FirebaseService();
    ApiResponse response = await service.login(email, senha);

    if(response.ok!){
      push(context, BackGroundPage(), replace: true);
    } else {
      setState(() {
        _isSigningIn = false;
      });
      alert(context, response.msg!);
    }
  }


  String? _validateEmail(String? text){
    if(text!.isEmpty){
      return "Digite o email";
    }
    return null;
  }

  String? _validateSenha(String? text){
    if(text!.isEmpty){
      return "Digite a senha" ;
    }
    return null;
  }

  String? _validadeReset(String? text){
    if(text!.isEmpty){
      return "Digite o seu email" ;
    }
    return null;
  }

  _textFormField(
      String text,
      String hint,
      Color color,
      {bool password =false,
        TextInputType? keyboardType,
        TextInputAction? textInputAction,
        controller,
        String? Function(String? text)? validator,
        IconButton? suffixicon,
        Icon? prefixicon, GlobalKey<FormFieldState>? key}) {
    return TextFormField(
              key: key,
              validator: validator,
              controller: controller,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              obscureText: password,
              style: GoogleFonts.roboto(
                  color: color,
                fontSize: 23.sp,
              ),
              decoration: InputDecoration(
                  suffixIcon: suffixicon,
                  prefixIcon: prefixicon,
                  errorStyle: TextStyle(
                    fontSize: 20.sp
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      width: 2.w,
                      color: Color(0xFF03A9f4).withOpacity(0.5),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      width: 3.w,
                      color: Color(0xFF03A9f4),
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      width: 2.w,
                      color: Colors.red
                    )
                  ),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                          width: 2.w,
                          color: Colors.red
                      )
                  ),
                  labelText: text,
                  labelStyle: TextStyle(
                      fontSize: 23.sp,
                      color: Colors.grey.withOpacity(0.9)
                  ),
                  hintText: hint,
                  hintStyle: TextStyle(
                      fontSize: 20.sp,
                      color: Colors.grey.withOpacity(0.5)
                  ),
              ),
            );
  }


}
