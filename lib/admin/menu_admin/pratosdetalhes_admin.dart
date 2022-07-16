import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PratosDetalhesAdmin extends StatefulWidget {

  final String nome;
  final String img;
  final double preco;
  final String text;
  final int tempo;
  final String categoria;
  final String id;
  final String subcategoria;
  final data;

  PratosDetalhesAdmin(this.nome, this.img, this.preco, this.text, this.tempo, this.categoria, this.id, this.subcategoria, this.data);


  @override
  _PratosDetalhesAdminState createState() => _PratosDetalhesAdminState();
}

class _PratosDetalhesAdminState extends State<PratosDetalhesAdmin> {



  late TextEditingController _tNome;
  late TextEditingController _tPreco;
  late TextEditingController _tTempo;
  late TextEditingController _tObs;
  late String imageUrl;

  bool _isLoading = false;


  @override
  void initState() {
    super.initState();
    _tPreco = TextEditingController(text: widget.preco.toStringAsFixed(2));
    _tNome = TextEditingController(text: widget.nome);
    _tTempo = TextEditingController(text: widget.tempo.toString());
    _tObs = TextEditingController(text: widget.text);

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xF7131313),
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 60.h,
        leadingWidth: 50.sp,
        leading: GestureDetector(
          onTap: (){
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF03A9f4),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 32.sp,
                ),
              ),
            ),
          ),
        ),
        title: widget.categoria == "bebidas"? Container(
          width: 220.w,
          height: 100.h,
          child: PopupMenuButton(
            icon: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("pratos").where("data", isEqualTo: widget.data).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if(snapshot.hasError){
                  return Container();
                }
                if(!snapshot.hasData){
                  return Container();
                }
                return Text(
                  snapshot.data!.docs[0]["subcategoria"],
                  style: GoogleFonts.dancingScript(
                      color: Colors.white,
                      fontSize: 40.sp,
                      fontWeight: FontWeight.bold
                  ),
                );
              },
            ),
            itemBuilder: (_)=> <PopupMenuItem<String>>[
              PopupMenuItem(
                padding: EdgeInsets.only(left: 10.w),
                child: Container(
                  child: Text(
                    "Cerveja",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                        fontSize: 18.sp,
                        color: Colors.black
                    ),
                  ),
                ),
                value: "cervejas",
              ),
              PopupMenuItem(
                padding: EdgeInsets.only(left: 10.w),
                child: Container(
                  child: Text(
                    "Refrigerante",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                        fontSize: 18.sp,
                        color: Colors.black
                    ),
                  ),
                ),
                value: "refrigerantes",
              ),
              PopupMenuItem(
                padding: EdgeInsets.only(left: 10.w),
                child: Container(
                  child: Text(
                    "Suco",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                        fontSize: 18.sp,
                        color: Colors.black
                    ),
                  ),
                ),
                value: "sucos",
              ),
              PopupMenuItem(
                padding: EdgeInsets.only(left: 10.w),
                child: Container(
                  child: Text(
                    "Vinho",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                        fontSize: 18.sp,
                        color: Colors.black
                    ),
                  ),
                ),
                value: "vinhos",
              ),
              PopupMenuItem(
                padding: EdgeInsets.only(left: 10.w),
                child: Container(
                  child: Text(
                    "Outro",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                        fontSize: 18.sp,
                        color: Colors.black
                    ),
                  ),
                ),
                value: "outros",
              )
            ],
            onSelected: (index) async {
              switch(index) {
                case 'cervejas':
                  setState(() {
                    FirebaseFirestore.instance.collection("pratos").doc(widget.id).update({
                      "subcategoria": "Cerveja",
                    });
                  });
                  break;
                case 'refrigerantes':
                  setState(() {
                    FirebaseFirestore.instance.collection("pratos").doc(widget.id).update({
                      "subcategoria": "Refrigerante",
                    });
                  });
                  break;
                case 'sucos':
                  setState(() {
                    FirebaseFirestore.instance.collection("pratos").doc(widget.id).update({
                      "subcategoria": "Suco",
                    });
                  });
                  break;
                case 'vinhos':
                  setState(() {
                    FirebaseFirestore.instance.collection("pratos").doc(widget.id).update({
                      "subcategoria": "Vinho",
                    });
                  });
                  break;
                case 'outros':
                  setState(() {
                    FirebaseFirestore.instance.collection("pratos").doc(widget.id).update({
                      "subcategoria": "Outro",
                    });
                  });
                  break;
              }
            },
          ),
        ): Container(),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isLoading = true;
                });
                  UploadImage();
              },
              child: Container(
                width: 43.w,
                decoration: BoxDecoration(
                  color: Color(0xFF03A9f4),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(2,2)
                    )
                  ]
                ),
                child: Center(
                  child: Icon(
                    Icons.image,
                    color: Colors.white,
                    size: 32.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: _body(),
    );
  }

  _body() {
    return SingleChildScrollView(
      child: Stack(
        children: [
          _isLoading == false?StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("pratos").where("data", isEqualTo: widget.data).snapshots(),
              builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
                if(snapshot.hasError) {
                  return Container(
                    height: 450.h,
                    child: Center(
                      child: Text(
                        "Não foi possível carregar a img ",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 22.sp
                        ),
                      ),
                    ),
                  );
                }
                if(!snapshot.hasData){
                  return Container(
                    height: 450.h,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return Container(
                  height: 450.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.2),BlendMode.darken),
                        image: NetworkImage(snapshot.data!.docs[0]["url"]),fit: BoxFit.cover
                    ),
                  ),
                );
              }) : Container(
                    height: 450.h,
                      child: Center(
                        child: CircularProgressIndicator(),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top:410.h),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 2.sp,
                      color: Colors.white.withOpacity(0.8)
                  ),
                  color: Color(0xF7131313),
                  borderRadius: BorderRadius.circular(40)
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 15.0.h, left: 15.w, right: 15.w
                ),
                child: Column(
                  children: [
                    SizedBox(
                        height: 5.h
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      height: 42.h,
                      child: TextFormField(
                        onEditingComplete: (){
                          setState(() {
                            FirebaseFirestore.instance.collection("pratos").doc(widget.id).update({
                              'nome': _tNome.text.trim()
                            });
                          });
                          FocusScope.of(context).unfocus();
                        },
                        controller: _tNome,
                        textAlign: TextAlign.start,
                        style: GoogleFonts.roboto(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        ),
                      ),
                    ),
                    Container(
                      child: Column(
                        children: [
                          widget.tempo>0?
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    width: 40.w,
                                    child: Icon(
                                      Icons.watch_later_outlined,
                                      color: Color(0xFF03A9f4),
                                      size: 32.sp,
                                    ),
                                  ),
                                  Container(
                                    width: 100.w,
                                    child: TextFormField(
                                      onEditingComplete: (){
                                        FirebaseFirestore.instance.collection("pratos").doc(widget.id).update({
                                          'tempo': int.parse(_tTempo.text)
                                        });
                                        FocusScope.of(context).unfocus();
                                      },
                                      controller: _tTempo,
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.roboto(
                                          color: Color(0xFF03A9f4),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 32.sp
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("R\$",
                                    style: GoogleFonts.roboto(
                                        color: Color(0xFF03A9f4),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 32.sp
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.bottomRight,
                                    width: 80.w,
                                    child: TextFormField(
                                      onEditingComplete: (){
                                        FirebaseFirestore.instance.collection("pratos").doc(widget.id).update({
                                          'preco': double.parse(_tPreco.text)
                                        });
                                        FocusScope.of(context).unfocus();
                                      },
                                      controller: _tPreco,
                                      textAlign: TextAlign.end,
                                      style: GoogleFonts.roboto(
                                          color: Color(0xFF03A9f4),
                                          fontWeight: FontWeight.w400,
                                          fontSize: 32.sp
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ):
                          Row(
                            children: [
                              Text("R\$",
                                style: GoogleFonts.roboto(
                                    color: Color(0xFF03A9f4),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 32.sp
                                ),
                              ),
                              Container(
                                width: 80.w,
                                alignment: Alignment.centerLeft,
                                child: TextFormField(
                                  onEditingComplete: (){
                                    FirebaseFirestore.instance.collection("pratos").doc(widget.id).update({
                                      'preco': double.parse(_tPreco.text)
                                    });
                                    FocusScope.of(context).unfocus();
                                  },
                                  controller: _tPreco,
                                  textAlign: TextAlign.start,
                                  style: GoogleFonts.roboto(
                                      color: Color(0xFF03A9f4),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 32.sp
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Container(
                      child: TextFormField(
                        onEditingComplete: (){
                          FirebaseFirestore.instance.collection("pratos").doc(widget.id).update({
                            'descricao': _tObs.text
                          });
                          FocusScope.of(context).unfocus();
                        },
                        controller: _tObs,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.done,
                        textAlign: TextAlign.justify,
                        maxLines: null,
                        style: GoogleFonts.roboto(
                          fontSize: 20.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void UploadImage() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _imagePicker = ImagePicker();
    PickedFile? image;

    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;

    if(permissionStatus.isGranted){
      image = (await _imagePicker.getImage(source: ImageSource.gallery));
      if(image != null){
        var file = File(image.path);
        var snapshot = await _firebaseStorage.ref()
            .child("images/"+ widget.id)
            .putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();
        setState(() {
          imageUrl = downloadUrl;
          FirebaseFirestore.instance.collection("pratos").doc(widget.id).update({
            "url": imageUrl
          });
          print(downloadUrl);
          _isLoading = false;
        });
      } else {
        print("No Image Path Received");
        setState(() {
          _isLoading = false;
        });
      }
    } else {
    print ('Permission not granted. Try Again whit permission access');
    setState(() {
      _isLoading = false;
    });
    }
  }
}

