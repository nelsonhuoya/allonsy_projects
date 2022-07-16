import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

class SecurityAdminPage extends StatefulWidget {
  const SecurityAdminPage({Key? key}) : super(key: key);

  @override
  _SecurityAdminPageState createState() => _SecurityAdminPageState();
}

class _SecurityAdminPageState extends State<SecurityAdminPage> {

  var _tSenha = TextEditingController();

  var _tAdminAdd = TextEditingController();

  var _tAdminSearch = TextEditingController();

  late FocusNode myFocusNode;

  late FocusNode my2FocusNode;

  late FocusNode my3FocusNode;

  bool search = false;

  bool adicionar = false;

  String teste ="";

  String senha ="";

  String filtro ="";

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    my2FocusNode = FocusNode();
    my3FocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xF7131313),
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
        title: Text ("Segurança",
          style: GoogleFonts.dancingScript(
              fontSize: 35.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),),
      ),
      body: _body(),
    );
  }

  _body() {
    return StreamBuilder<QuerySnapshot>(
      stream: filtro == ""? FirebaseFirestore.instance.collection("admins").orderBy("ativo", descending: true).orderBy("email", descending: false).snapshots()
          : FirebaseFirestore.instance.collection("admins").where("email", isGreaterThanOrEqualTo: filtro).where("email", isLessThanOrEqualTo: filtro + "\uf7ff" ).orderBy("email", descending: false).orderBy("ativo", descending: true).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(snapshot.hasError){
          return Center(
            child: Text(
              "Não foi possível carregar os dados financeiros",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 22.sp
              ),
            ),
          );
        } if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(),
          );
        } return Container(
          padding: EdgeInsets.only(right: 16.w, left: 16.w),
          child: Column(
            children: [
              SizedBox(height: 20.h,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Alterar Senha Adm.",
                  style: TextStyle(
                      fontSize: 24.sp,
                      color: Colors.grey.withOpacity(0.9)
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              TextFormField(
                obscureText: true,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly
                ],
                maxLength: 6,
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 23.sp,
                ),
                controller: _tSenha,
                focusNode: myFocusNode,
                onFieldSubmitted: (String senha) async {
                  setState(() {
                    senha = _tSenha.text;
                    FirebaseFirestore.instance.collection("senha").doc("senha").set({
                      "senha": senha
                    });
                    _tSenha.clear();
                    showDialog(
                        context: context,
                        builder: (context){
                          return Center(
                            child: Container(
                              width: 300.w,
                              child: AlertDialog(
                                insetPadding:EdgeInsets.zero,
                                content: Text(
                                  "A Senha da adminstração foi alterada.",
                                  style: GoogleFonts.roboto(
                                    fontSize: 20.sp
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          );
                        });
                  });
                },
                decoration: InputDecoration(
                  counterStyle: TextStyle(
                      fontSize: 15.sp,
                      color:Color(0xFF03A9f4)),
                  contentPadding: EdgeInsets.all(10.sp),
                  prefixIcon: Icon(Icons.lock,
                  color: Color(0xFF03A9f4),),
                  hoverColor: Color(0xFF1B1B1B),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      width: 3.w,
                      color: Color(0xFF03A9f4),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      width: 3.w,
                      color: Color(0xFF03A9f4),
                    ),
                  ),
                  labelText: "Senha",
                  labelStyle: TextStyle(
                      fontSize: 23.sp,
                      color: Colors.grey.withOpacity(0.9)
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.zero,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                        "Administradores",
                        style: TextStyle(
                            fontSize: 24.sp,
                            color: Colors.grey.withOpacity(0.9)
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.zero,
                      width: 40.w,
                      child: PopupMenuButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(Icons.dehaze_rounded,
                            size: 32.sp,
                            color: Colors.grey),
                        itemBuilder: (_)=> <PopupMenuItem<String>>[
                          PopupMenuItem(
                            child: Container(
                              child: Text(
                                "Adicionar",
                                style: GoogleFonts.roboto(
                                    fontSize: 18.sp,
                                    color: Colors.black
                                ),
                              ),
                            ),
                            value: "adicionar",
                          ),
                          PopupMenuItem(
                            child: Container(
                              child: Text(
                                "Pesquisar",
                                style: GoogleFonts.roboto(
                                    fontSize: 18.sp,
                                    color: Colors.black
                                ),
                              ),
                            ),
                            value: "pesquisar",
                          )
                        ],
                        onSelected: (index) async {
                          switch(index) {
                            case 'adicionar':
                              setState(() {
                                search = false;
                                _tAdminSearch.clear();
                                FocusScope.of(context).unfocus();
                                my2FocusNode.requestFocus();
                                adicionar = true;
                                ;
                              });
                              break;
                            case 'pesquisar':
                              setState(() {
                                adicionar = false;
                                _tAdminAdd.clear();
                                FocusScope.of(context).unfocus();
                                my3FocusNode.requestFocus();
                                search = true;
                              });
                              break;
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: adicionar == true? 60.h : 0,
                child: TextFormField(
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 23.sp,
                  ),
                  controller: _tAdminAdd,
                  focusNode: my2FocusNode,
                  onFieldSubmitted: (String admin){
                    setState(() {
                      FirebaseFirestore.instance.collection("admins").doc().set({
                        "ativo": true,
                        "email": _tAdminAdd.text
                      });
                      _tAdminAdd.clear();
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.sp),
                    suffixIcon: GestureDetector(
                        onTap: (){
                          setState(() {
                            _tAdminAdd.clear();
                            FocusScope.of(context).unfocus();
                            adicionar = false;
                          });
                        },
                        child: Icon(Icons.close,size: adicionar == true? 22.sp: 0,color: Colors.grey)
                    ),
                    prefixIcon: Icon(Icons.person,size: adicionar == true? 32.sp: 0,color: Color(0xFF03A9f4),
                    ),
                    hoverColor: Color(0xFF1B1B1B),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        width: 3.w,
                        color: Color(0xFF03A9f4),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        width: 3.w,
                        color: adicionar == true? Color(0xFF03A9f4) : Colors.transparent,
                      ),
                    ),
                    labelText: "Adicionar",
                    labelStyle: TextStyle(
                        fontSize: 23.sp,
                        color: Colors.grey.withOpacity(0.9)
                    ),
                  ),
                ),
              ),
              Container(
                height: search == true? 60.h : 0,
                child: TextFormField(
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 23.sp,
                  ),
                  controller: _tAdminSearch,
                  focusNode: my3FocusNode,
                  onChanged: (String adm){
                    setState(() {
                      filtro = _tAdminSearch.text;
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.sp),
                    suffixIcon: GestureDetector(
                        onTap: (){
                          setState(() {
                            _tAdminSearch.clear();
                            FocusScope.of(context).unfocus();
                            search = false;
                            filtro = "";
                          });
                        },
                        child: Icon(Icons.close,size: search == true? 22.sp: 0,color: Colors.grey)
                    ),
                    prefixIcon: Icon(Icons.person, size: search == true? 32.sp: 0,color: Color(0xFF03A9f4),
                    ),
                    hoverColor: Color(0xFF1B1B1B),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        width: 3.w,
                        color: Color(0xFF03A9f4),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        width: 3.w,
                        color: search == true? Color(0xFF03A9f4) : Colors.transparent,
                      ),
                    ),
                    labelText: "Pesquisar",
                    labelStyle: TextStyle(
                        fontSize: 23.sp,
                        color: Colors.grey.withOpacity(0.9)
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: search == true? 10.h : 0,
              ),
              SizedBox(
                height: adicionar == true? 10.h : 0,
              ),
              Expanded(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.docs.length,
                    itemExtent: 90.h,
                    itemBuilder: (BuildContext context, int index){
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: GestureDetector(
                          onLongPress: (){
                            setState(() {
                              FirebaseFirestore.instance.collection("admins").doc(snapshot.data!.docs.elementAt(index).id).delete();
                            });
                          },
                          onDoubleTap: (){
                            setState(() {
                              FirebaseFirestore.instance.collection("admins").doc(snapshot.data!.docs.elementAt(index).id).update({
                                "ativo": snapshot.data!.docs.elementAt(index)["ativo"] == true? false : true
                              });
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                border: Border.all(width: 4.sp, color: snapshot.data!.docs.elementAt(index)['ativo']== true?Color(0xFF03A9f4):Colors.grey),
                                color: Colors.white,
                                boxShadow: [BoxShadow(
                                    color: Colors.black87,
                                    blurRadius: 4,
                                    offset: Offset(4,4)
                                )
                                ]
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width:300.w,
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 5.w),
                                    child: Text(
                                      snapshot.data!.docs.elementAt(index)['email'],
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.roboto(
                                        color: snapshot.data!.docs.elementAt(index)['ativo'] == true?Colors.black: Colors.grey,
                                        fontSize: 20.sp
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 40.w,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(Icons.add_moderator,
                                      color:snapshot.data!.docs.elementAt(index)['ativo'] == true? Colors.grey: Colors.white,
                                      size: 32.sp,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                ),
              ),
            ],
          ),
        );
      },

    );
  }
}

