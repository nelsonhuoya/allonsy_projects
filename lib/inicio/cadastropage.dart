import 'package:allonsyapp/firebase/firebase_service.dart';
import 'package:allonsyapp/inicio/background.dart';
import 'package:allonsyapp/utils/nav.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../firebase/alert.dart';

class CadastroPage extends StatefulWidget {

  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  bool _password = true;

  final _formKey = GlobalKey<FormState>();

  final _tNome = TextEditingController();

  final _tEmail = TextEditingController();

  final _tSenha = TextEditingController();

  var _progress = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.h,
        backgroundColor: Color(0xFF1B1B1B),
        centerTitle: true,
        title: Text ("Cadastro",
          style: GoogleFonts.dancingScript(
              fontSize: 47.0.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),),
      ),
      backgroundColor: Color(0xF7131313),
      body: _body(),
    );
  }

  _body() {
    return Center(
      child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _textFormField(
                      "Nome",
                      "Digite seu Nome",
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      controller: _tNome,
                      validator: _validateNome,
                      prefixicon: Icon(Icons.person,color:Colors.grey,)),
                  SizedBox(height: 20.h),
                  _textFormField(
                      "Email",
                      "Digite seu email",
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      controller: _tEmail,
                      validator: _validateEmail,
                      prefixicon: Icon(Icons.person,color:Colors.grey,)),
                  SizedBox(height: 20.h),
                  _textFormField(
                      "Senha",
                      "Digite sua senha",
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
                  SizedBox(height: 20.h),
                  GestureDetector(
                    onTap:(){
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();}
                      _onClickCadastrar();
                    },
                    child: Container(
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: Color(0xFF03A9f4),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Center(
                        child: _progress? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ) : Text(
                          "Criar Conta",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.sp
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }

  String? _validateNome(String? text){
    if(text!.trim().isEmpty){
      return "Digite o nome" ;
    }
    return null;
  }

  String? _validateEmail(String? text){
    if(text!.trim().isEmpty){
      return "Digite o email";
    }
    return null;
  }

  String? _validateSenha(String? text){
    if(text!.trim().isEmpty){
      return "Digite a senha" ;
    }
    if(text.trim().length < 6){
      return "A senha precisa ter 6 ou mais caracteres";
    }
    return null;
  }

  _textFormField(
      String text,
      String hint,
      {bool password = false,
        TextInputType? keyboardType,
        TextInputAction? textInputAction,
        controller,
        String? Function(String? text)? validator,
        IconButton? suffixicon,
        Icon? prefixicon,
        TextCapitalization textCapitalization = TextCapitalization.none,
      }) {
    return TextFormField(
      textCapitalization: textCapitalization,
      validator: validator,
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: password,
      style: TextStyle(
        color: Colors.white,
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



  _onClickCadastrar() async {
    print("Cadastrar!");

    String nome = _tNome.text.trim();
    String email = _tEmail.text.trim();
    String senha = _tSenha.text.trim();

    print("Nome $nome, Email $email, Senha $senha");

    if(!_formKey.currentState!.validate()){
      return;
    }

    setState(() {
      _progress = true;
    });

    final response = await FirebaseService().cadastrar(nome, email, senha);

    if(response.ok!){
      push(context, BackGroundPage(), replace: true);
    } else {
      alert(context, response.msg!);
    }

    setState(() {
      _progress = false;
    });

  }
}
