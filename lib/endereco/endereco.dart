import 'package:allonsyapp/pedidos/confirmacao.dart';
import 'package:allonsyapp/utils/nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:brasil_fields/brasil_fields.dart';


class EnderecoPage extends StatefulWidget {

  final String lastroute;
  final String rua;
  final String CEP;
  final String bairro;
  final String cidade;
  final String complemento;
  final String numero;
  final String? id;
  bool atualizacao;

  EnderecoPage({required this.lastroute, required this.rua, required this.CEP, required this.bairro, required this.cidade, required this.complemento, required this.numero,@required this.id,required bool this.atualizacao});

  @override
  _EnderecoPageState createState() => _EnderecoPageState();
}

class _EnderecoPageState extends State<EnderecoPage> {

   late TextEditingController _tRua;

   late TextEditingController _tCidade;

   late TextEditingController _tBairro;

   late TextEditingController _tComplemento;

   late TextEditingController _tCEP;

   late TextEditingController _tNumero;

  @override
  void initState() {
    super.initState();
    _tRua = TextEditingController(text: widget.rua);

    _tCidade = TextEditingController(text: widget.cidade);

    _tBairro = TextEditingController(text: widget.bairro);

    _tComplemento = TextEditingController(text: widget.complemento);

    _tCEP = TextEditingController(text: widget.CEP);

    _tNumero = TextEditingController(text: widget.numero);
  }

  final email = FirebaseAuth.instance.currentUser!.email;

  final _formKey = GlobalKey<FormState>();

  var _progress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xF7131313),
      body: _body(),
      appBar: AppBar(
          toolbarHeight: 60.h,
          backgroundColor: Color(0xFF1B1B1B),
          centerTitle: true,
          leading: Padding(
            padding: EdgeInsets.only(bottom: 8.0.h, top: 8.0.h, left: 8.w, right: 8.w),
            child: GestureDetector(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 32.sp,
              ),
            ),
          ),
          title: Text ( "Endereço",
            style: GoogleFonts.dancingScript(
                fontSize: 45.0.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold
          ),),
        ),
      );
  }

  _body() {
    return Center(
      child: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                Stack(
                  children: [
                    ClipPath(
                      clipper: TopWaveClipper(),
                      child: Container(
                        height: 180.h,
                        color: Color(0xFF03A9f4),
                      ),
                    ),
                    Container(
                      height: 190.h,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          height: 180.h,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/delivery.png")
                              )
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0.w, right: 8.0.w, bottom: 8.h, top: 20.h),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.sp),
                      border: Border.all(
                        width: 2.sp,
                        color: Colors.white
                      )
                    ),
                    padding: EdgeInsets.only(left: 15.0.w, right: 15.0.w, top: 15.h, bottom: 15.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          child:Row(
                            children: [
                              Flexible(
                                flex: 5,
                                child: _textFormField(
                                    "Cidade",
                                    "Digite sua cidade",
                                    textCapitalization: TextCapitalization.words,
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.next,
                                    controller: _tCidade,
                                    validator: _validateCidade),
                              ),
                              SizedBox(width: 10.w),
                              Flexible(
                                flex: 5,
                                  child: _textFormField(
                                      "CEP",
                                      "Digite seu CEP",
                                    textCapitalization: TextCapitalization.words,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      controller: _tCEP,
                                      validator: _validateCEP,
                                      inputformatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                        CepInputFormatter()
                                    ],
                                  ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        _textFormField(
                            "Rua",
                            "Digite sua rua",
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.next,
                            controller: _tRua,
                            validator: _validateRua),
                        SizedBox(height:10.h),
                        Container(
                          child:Row(
                            children: [
                              Flexible(
                                flex: 7,
                                child: _textFormField(
                                    "Bairro",
                                    "Digite seu bairro",
                                    textCapitalization: TextCapitalization.words,
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.next,
                                    controller: _tBairro,
                                    validator: _validateBairro),
                              ),
                              SizedBox(width: 10.w),
                              Flexible(
                                flex: 3,
                                child: _textFormField(
                                  "Número",
                                  "Digite o número",
                                  textCapitalization: TextCapitalization.words,
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.next,
                                  controller: _tNumero,
                                  validator: _validateNumero,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10.h),
                        _textFormField(
                            "Complemento",
                            "Digite o complemento de seu endereço",
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.done,
                            controller: _tComplemento),
                        SizedBox(height: 10.h),
                        GestureDetector(
                          onTap:(){
                            FocusScopeNode currentFocus = FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) {
                              currentFocus.unfocus();}
                            _onClickCadastrar();
                          },
                          child: Container(
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: Color(0xFF03A9f4),
                              borderRadius: BorderRadius.circular(10.0.sp),
                            ),
                            child: Center(
                              child: _progress== true? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(Colors.white),
                              ) : Text(
                                widget.atualizacao == true? "Atualizar Endereço":"Adicionar Endereço",
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
                ),
              ],
            )
        ),
      ),
    );
  }

  String? _validateRua(String? text){
    if(text!.trim().isEmpty){
      return "Digite a rua" ;
    }
    return null;
  }

  String? _validateCEP(String? text){
    if(text!.trim().isEmpty){
      return "Digite o CEP" ;
    }
    if (text.trim().length<8){
      return "Digite CEP válido";
    }
    return null;
  }

  String? _validateCidade(String? text){
    if(text!.trim().isEmpty){
      return "Digite a cidade";
    }
    return null;
  }

  String? _validateBairro(String? text){
    if(text!.trim().isEmpty){
      return "Digite o bairro";
    }
    return null;
  }

  String? _validateNumero(String? text){
    if(text!.trim().isEmpty){
      return "" ;
    }
    return null;
  }

  _textFormField(
      String text,
      String hint,
      { TextInputType? keyboardType,
        TextInputAction? textInputAction,
        controller,
        String? Function(String? text)? validator,
        TextCapitalization textCapitalization = TextCapitalization.none, List<TextInputFormatter>? inputformatters,
      }) {
    return TextFormField(
      inputFormatters: inputformatters,
      textCapitalization: textCapitalization,
      validator: validator,
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: GoogleFonts.roboto(
        color: Colors.white,
        fontSize: 20.sp,
      ),
      decoration: InputDecoration(
        errorStyle: TextStyle(
            fontSize: 17.sp
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.sp),
          borderSide: BorderSide(
            width: 2.w,
            color: Color(0xFF03A9f4).withOpacity(0.5),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.sp),
          borderSide: BorderSide(
            width: 3.w,
            color: Color(0xFF03A9f4),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.sp),
            borderSide: BorderSide(
                width: 2.w,
                color: Colors.red
            )
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.sp),
            borderSide: BorderSide(
                width: 2.w,
                color: Colors.red
            )
        ),
        labelText: text,
        labelStyle: GoogleFonts.roboto(
            fontSize: 20.sp,
            color: Colors.grey.withOpacity(0.9)
        ),
        hintText: hint,
        hintStyle: GoogleFonts.roboto(
            fontSize: 20.sp,
            color: Colors.grey.withOpacity(0.5)
        ),
      ),
    );
  }

   _onClickCadastrar() async {
     if(!_formKey.currentState!.validate()){
       return;
     }
     _progress = true;
       await FirebaseFirestore.instance.collection("users").
       doc(email).collection("endereços").get().then((value) {
         for (var data in value.docs){
           FirebaseFirestore.instance.collection("users").doc(email).
           collection("endereços").doc(data.id).update({
             "ativo":false
           });
         };
       });
       if(widget.atualizacao == true){
         await FirebaseFirestore.instance.collection("users").doc(email).collection("endereços").doc(widget.id).update({
           "rua": _tRua.text.trim(),
           "cidade": _tCidade.text.trim(),
           "bairro": _tBairro.text.trim(),
           "CEP": _tCEP.text.trim(),
           "numero": _tNumero.text.trim(),
           "complemento": _tComplemento.text.trim(),
           "ativo": true,
         });
       } else {
         await FirebaseFirestore.instance.collection("users").doc(email).collection("endereços").doc().set({
           "rua": _tRua.text.trim(),
           "cidade": _tCidade.text.trim(),
           "bairro": _tBairro.text.trim(),
           "CEP": _tCEP.text.trim(),
           "numero": _tNumero.text.trim(),
           "complemento": _tComplemento.text.trim(),
           "ativo": true,
         });
       }
       if(widget.lastroute == 'enderecos'){
         Navigator.of(context).pop();
         setState(() {
           _progress = false;
         });
       } else {
         await push(context, ConfirmacaoPage(retirada: false));
         setState(() {
           _progress = false;
         });
       }
  }
}

class TopWaveClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size){
    var path = Path();
    path.lineTo(0,size.height);
    path.lineTo(size.width,size.height);
    path.lineTo(size.width, size.height-100.h);
    path.quadraticBezierTo(size.width, size.height-230.h,
        size.width/2, size.height-100.h);
    path.quadraticBezierTo(size.width/2, size.height-230.h,
        0, size.height-50.h);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper)=> false;
}
