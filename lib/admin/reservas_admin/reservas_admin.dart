import 'package:allonsyapp/firebase/firebase_service.dart';
import 'package:allonsyapp/inicio/loginpage.dart';
import 'package:allonsyapp/utils/nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

class ReservasAdmin extends StatefulWidget {

  @override
  _ReservasAdminState createState() => _ReservasAdminState();
}

class _ReservasAdminState extends State<ReservasAdmin> {

  bool search = false;

  var _tUser = TextEditingController();

  late FocusNode myFocusNode;

  String filtro = "";

  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1B1B1B),
        toolbarHeight: 60.h,
        leading: Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(math.pi),
          child: IconButton(
            icon: Icon(Icons.exit_to_app),
            iconSize: 32.sp,
            color: Colors.white,
            onPressed: () {
              FirebaseService().logout();
              push(context, LoginPage(), replace: true);
            },
          ),
        ),
        centerTitle: true,
        title: Text("Allons-y",
          style: GoogleFonts.dancingScript(
              fontSize: 38.0.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            iconSize: 32.sp,
            color: Colors.white,
            onPressed: () {
              setState(() {
                search == true ? FocusScope.of(context).unfocus() : myFocusNode
                    .requestFocus();
                search == false ? search = true : search = false;
              });
            },
          ),
        ],
      ),
      backgroundColor: Color(0xF7131313),
      body: _body(),
    );
  }

  _body() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            SizedBox(
              height: search == false ? 0 : 10.h,
            ),
            Container(
              height: search == false ? 0 : 60.h,
              child: TextFormField(
                style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 23.sp,
                ),
                controller: _tUser,
                focusNode: myFocusNode,
                onChanged: (String user) async {
                  setState(() {
                    print(_tUser.text);
                    filtro = _tUser.text;
                  });
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.sp),
                  prefixIcon: Icon(
                    Icons.person, size: search == true?32.sp: 0,
                    color: Color(0xFF03A9f4),
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
                      color: search == false ? Colors.transparent : Color(
                          0xFF03A9f4),
                    ),
                  ),
                  labelText: "Usuario",
                  labelStyle: TextStyle(
                      fontSize: 23.sp,
                      color: Colors.grey.withOpacity(0.9)
                  ),
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: filtro == "" ?
                FirebaseFirestore.instance.collection("reservas").orderBy(
                    "data", descending: true).snapshots() :
                FirebaseFirestore.instance.collection("reservas").orderBy("user", descending: true).where(
                    "user", isGreaterThanOrEqualTo: filtro).where(
                    "user", isLessThanOrEqualTo: filtro + "\uf7ff").orderBy(
                    "data", descending: true).snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if(snapshot.hasError) {
                    return Center(
                      child: Text(
                        "Não foi possível carregar as reservas",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 22.sp
                        ),
                      ),
                    );
                  }
                  if(!snapshot.hasData){
                    return Container(
                      height: search == false? 631.h: 566.h,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return Container(
                      height: search == false? 631.h: 566.h,
                      child: Center(
                        child: Text(
                          "Não há reservas",
                          style: GoogleFonts.roboto(
                              color: Color(0xFF03A9f4),
                              fontSize: 22.sp
                          ),
                        ),
                      ),
                    );
                  }
                  Future<void> scanQR() async {
                    String barcodeScanRes;
                    // Platform messages may fail, so we use a try/catch PlatformException.
                    try {
                      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                          '#03A9F4', 'Cancelar', false, ScanMode.QR);
                      print(barcodeScanRes);
                      List <String> reservas = snapshot.data!.docs.map((e) => e.reference.id).toList();
                      print(reservas.contains(barcodeScanRes.trim()));
                      if(reservas.contains(barcodeScanRes.trim()) == true){
                        int index = reservas.indexWhere((item) => item.contains(barcodeScanRes.trim()));
                        snapshot.data!.docs.elementAt(index)["scan"] == "0"? null: FirebaseFirestore.instance.collection("reservas").doc(barcodeScanRes.trim()).update({
                          "scan":  "Scan: "+ DateTime.now().day.toString().padLeft(2, "0")+ "/" +DateTime.now().month.toString().padLeft(2, "0") + "/"+ DateTime.now().year.toString() + " às " + DateTime.now().hour.toString().padLeft(2, "0")+":"+DateTime.now().minute.toString().padLeft(2, "0")
                        });
                        print("Reserva Confirmada");
                        showDialog(
                            barrierDismissible: true,
                            barrierColor: Colors.black.withOpacity(0.9),
                            context: context,
                            builder: (context){
                              return Center(
                                child: Container(
                                    height: 180.h,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius
                                            .circular(20),
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 5.sp,
                                          color: DateTime.now().isAfter(snapshot.data!.docs.elementAt(index)["data"].toDate())?
                                          Colors.grey : Color(0xFF03A9f4),
                                        )
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10.w,
                                          right: 10.w,
                                          top: 5.h,
                                          bottom: 10.h),
                                      child: Container(
                                        child: Column(
                                          children: [
                                            Container(
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                      height: 5.h
                                                  ),
                                                  Container(
                                                    child: Row(
                                                      children: [
                                                        Icon(Icons.person,
                                                          size: 32.sp,
                                                          color: DateTime.now().isAfter(snapshot.data!.docs.elementAt(index)["data"].toDate())?
                                                          Colors.grey : Color(0xFF03A9f4),),
                                                        SizedBox(
                                                          width: 10.w,
                                                        ),
                                                        Text(
                                                          snapshot.data!.docs.elementAt(index)["user"],
                                                          style: GoogleFonts.roboto(
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w400,
                                                              fontSize: 24.sp
                                                          ),),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 5.w),
                                              child: Column(
                                                children: [
                                                  Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Container(
                                                      height: 40.h,
                                                      width: 250.h,
                                                      child: Align(
                                                        alignment: Alignment.centerLeft,
                                                        child: Text(
                                                          snapshot.data!.docs.elementAt(index)["dia"],
                                                          style: GoogleFonts.roboto(color: Colors.black,
                                                              fontWeight: FontWeight.bold,
                                                              fontSize: 22.sp
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Text("Horário: " + snapshot.data!.docs.elementAt(index)["hora"],
                                                        style: GoogleFonts.roboto(
                                                            fontSize: 20.sp,
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.bold
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height: 5.h
                                                  ),
                                                  Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Row(
                                                      children: [
                                                        Text("Nº de pessoas: " + snapshot.data!.docs.elementAt(index)["pessoas"].toString(),
                                                          style: GoogleFonts.roboto(
                                                              fontSize: 20.sp,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.bold
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Text(
                                                            snapshot.data!.docs.elementAt(index)["scan"],
                                                            style: GoogleFonts.roboto(
                                                                fontSize: 12.sp,
                                                                color: Colors.grey.shade900
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.end,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                ),
                              );
                            });
                        print(index);
                        print(snapshot.data!.docs.elementAt(index)["pessoas"]);
                        print(snapshot.data!.docs.elementAt(index)["user"]);
                        print(snapshot.data!.docs.elementAt(index)["hora"]);
                      } else {
                        print("Reserva Inexistente");
                      }
                    } on PlatformException catch (error){
                      barcodeScanRes = error.toString();
                    }
                    // If the widget was removed from the tree while the asynchronous platform
                    // message was in flight, we want to discard the reply rather than calling
                    // setState to update our non-existent appearance.
                    if (!mounted) return;
                  }
                  return Container(
                    height: search == false? 620.h: 555.h,
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              left: 8.0.w, right: 8.w, top: 10.h),
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Stack(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(bottom: 15.h),
                                      child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius
                                                  .circular(20),
                                              color: Colors.white,
                                              border: Border.all(
                                                  width: 5.sp,
                                                color: DateTime.now().isAfter(snapshot.data!.docs.elementAt(index)["data"].toDate())?
                                                Colors.grey : Color(0xFF03A9f4),
                                              )
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 10.w,
                                                right: 10.w,
                                                top: 10.h,
                                                bottom: 10.h),
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  Container(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        SizedBox(
                                                            height: 5.h
                                                        ),
                                                        Container(
                                                          child: Row(
                                                            children: [
                                                              Icon(Icons.person,
                                                                size: 32.sp,
                                                                color: DateTime.now().isAfter(snapshot.data!.docs.elementAt(index)["data"].toDate())?
                                                                Colors.grey : Color(0xFF03A9f4),),
                                                              SizedBox(
                                                                width: 10.w,
                                                              ),
                                                              Container(
                                                                child: Text(
                                                                  snapshot.data!.docs.elementAt(index)["user"],
                                                                  maxLines: 1,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  style: GoogleFonts.roboto(
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w400,
                                                                      fontSize: 24.sp
                                                                  ),),
                                                                width: 280.w,
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(left: 5.w),
                                                    child: Column(
                                                      children: [
                                                        Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: Container(
                                                            height: 40.h,
                                                            width: 250.h,
                                                            child: Align(
                                                              alignment: Alignment.centerLeft,
                                                              child: Text(
                                                                snapshot.data!.docs.elementAt(index)["dia"],
                                                                style: GoogleFonts.roboto(color: Colors.black,
                                                                    fontWeight: FontWeight.bold,
                                                                    fontSize: 22.sp
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          child: Align(
                                                            alignment: Alignment.centerLeft,
                                                            child: Text("Horário: " + snapshot.data!.docs.elementAt(index)["hora"],
                                                              style: GoogleFonts.roboto(
                                                                  fontSize: 20.sp,
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight.bold
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            height: 5.h
                                                        ),
                                                        Align(
                                                          alignment: Alignment.centerLeft,
                                                          child: Row(
                                                            children: [
                                                              Text("Nº de pessoas: " + snapshot.data!.docs.elementAt(index)["pessoas"].toString(),
                                                                style: GoogleFonts.roboto(
                                                                    fontSize: 20.sp,
                                                                    color: Colors.black,
                                                                    fontWeight: FontWeight.bold
                                                                ),
                                                              ),
                                                              Container(
                                                                child: Text(
                                                                  snapshot.data!.docs.elementAt(index)["scan"],
                                                                  style: GoogleFonts.roboto(
                                                                      fontSize: 12.sp,
                                                                      color: Colors.grey.shade900
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            crossAxisAlignment: CrossAxisAlignment.end,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 10.0.h, right: 10.w),
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          child: GestureDetector(
                                            onTap: () {
                                              FirebaseFirestore.instance.collection("reservas").doc(snapshot.data!.docs[index].id).delete();
                                            },
                                            child: Icon(
                                              Icons.clear,
                                              size: 32.sp,
                                              color: DateTime.now().isAfter(snapshot.data!.docs.elementAt(index)["data"].toDate())?
                                               Colors.grey : Color(0xFF03A9f4),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                  ],
                                );
                              }),
                        ),
                        Positioned.fill(
                          child: Padding(
                            padding: EdgeInsets.only(right: 4.w, bottom: 6.h),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: FloatingActionButton(
                                onPressed: scanQR,
                                child: Center(
                                  child: Icon(Icons.qr_code,
                                      size: 32.sp),
                                ),
                                backgroundColor: Color(0xFF03A9f4),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  );
                }
            ),
          ],
        ),
      ),
    );
  }
}

