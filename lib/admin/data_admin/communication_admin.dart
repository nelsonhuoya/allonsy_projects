import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CommunicationAdminPage extends StatefulWidget {
  const CommunicationAdminPage({Key? key}) : super(key: key);

  @override
  _CommunicationAdminPageState createState() => _CommunicationAdminPageState();
}

class _CommunicationAdminPageState extends State<CommunicationAdminPage> {

  var _tTitle = TextEditingController();

  bool _isSigningIn = false;

  var _tMsg = TextEditingController();

  late FocusNode myFocusNode;

  late FocusNode my2FocusNode;

  String imageUrl = '';

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    my2FocusNode = FocusNode();
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
        title: Text ("Comunicação",
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
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(left: 8.w, right: 8.w,top: 10.h, bottom: 10.h ),
        child: Column(
          children: [
            Container(
              child: TextFormField(
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.multiline,
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 23.sp,
                ),
                controller: _tTitle,
                focusNode: myFocusNode,
                onFieldSubmitted: (String title) async {
                  setState(() {
                    title = _tTitle.text;
                  });
                },
                decoration: InputDecoration(
                  counterStyle: TextStyle(
                      fontSize: 15.sp,
                      color:Color(0xFF03A9f4)),
                  contentPadding: EdgeInsets.all(10.sp),
                  prefixIcon: Icon(Icons.title,
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
                  labelText: "Título",
                  labelStyle: TextStyle(
                      fontSize: 23.sp,
                      color: Colors.grey.withOpacity(0.9)
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Container(
              child: TextField(
                textCapitalization: TextCapitalization.sentences,
                keyboardType: TextInputType.multiline,
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 23.sp,
                ),
                controller: _tMsg,
                maxLines:5,
                focusNode: my2FocusNode,
                onSubmitted: (String msg) async {
                  setState(() {
                    msg = _tMsg.text;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  counterStyle: TextStyle(
                      fontSize: 15.sp,
                      color:Color(0xFF03A9f4)),
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
                  labelText: "Mensagem",
                  alignLabelWithHint: true,
                  labelStyle: TextStyle(
                      fontSize: 23.sp,
                      color: Colors.grey.withOpacity(0.9)
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Stack(
                      children: [
                        Container(
                          width: 135.w,
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: UploadImage,
                                child: Icon(Icons.image,
                                color: Color(0xFF03A9f4),
                                size: 65.sp),
                              ),
                              Container(
                                width: 60.w,
                                height: 60.h,
                                decoration: BoxDecoration(
                                  image: imageUrl == ""? null: DecorationImage(
                                      image: NetworkImage(imageUrl),
                                      fit: BoxFit.cover
                                  )
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned.fill(
                          bottom: 40.h,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  imageUrl = "";
                                });
                              },
                              child: Icon(Icons.clear,
                                  size: imageUrl == ""? 0.sp : 20.sp,
                                  color:Color(0xFF03A9f4)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    child: ElevatedButton(
                      child: Container(
                        width: 120.w,
                        height: 60.h,
                        child: Center(
                          child: _isSigningIn == false? Text(
                            "Enviar",
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 25.sp
                            ),
                          ) : Container(
                            width: 25.sp,
                            child: CircularProgressIndicator(
                              color: Colors.white),
                          ),
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Color(0xFF03A9f4))
                      ),
                      onPressed: (){
                        setState(() {
                          FirebaseFirestore.instance.collection("notificacao").doc().set({
                            "title": _tTitle.text,
                            "description": _tMsg.text,
                            'image':imageUrl,
                          });
                          showDialog(context: context, builder: (context){
                            return AlertDialog(
                              content: Text("Mensagem Enviada",
                                textAlign: TextAlign.center,),
                            );
                          });
                        });
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
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
            .child("notification/")
            .putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          imageUrl = downloadUrl;
          print(downloadUrl);
        });
      } else {
        print("No Image Path Received");
      }
    } else {
      print ('Permission not granted. Try Again whit permission access');
    }
  }
}