import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';

class SobrenosAdminPage extends StatefulWidget {
  @override
  _SobrenosPageState createState() => _SobrenosPageState();
}

class _SobrenosPageState extends State <SobrenosAdminPage> {

  var selectedItem = 0;

  late String imageUrl;

  List weekday = [
    "Segunda-feira",
    "Terça-feira",
    "Quarta-feira",
    "Quinta-feira",
    "Sexta-feira",
    "Sábado",
    "Domingo"
  ];

  late TextEditingController _tText1;

  late TextEditingController _tText2;

  late TextEditingController _tText3;

  late TextEditingController _tText4;

  var  teste = FirebaseFirestore.instance.collection("sobrenos").doc(1.toString()).get().then((value) => texto1 = value.data()!["text"]);

  static var texto1;

  var  teste1 = FirebaseFirestore.instance.collection("sobrenos").doc(2.toString()).get().then((value) => texto2 = value.data()!["text"]);

  static var texto2;

  var  teste2 = FirebaseFirestore.instance.collection("sobrenos").doc(3.toString()).get().then((value) => texto3 = value.data()!["text"]);

  static var texto3;

  var  teste3 = FirebaseFirestore.instance.collection("sobrenos").doc(4.toString()).get().then((value) => texto4 = value.data()!["text"]);

  static var texto4;

  @override
  void initState() {
    super.initState();
    _tText1 = TextEditingController(text: texto1);
    _tText2 = TextEditingController(text: texto2);
    _tText3 = TextEditingController(text: texto3);
    _tText4 = TextEditingController(text: texto4);

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
        title: Text ("Sobre Nós",
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
      child: StreamBuilder<List<QuerySnapshot>>(
          stream: CombineLatestStream.list([FirebaseFirestore.instance.collection("funcionamento").snapshots(),
            FirebaseFirestore.instance.collection("sobrenos").snapshots()
          ]),
          builder: (BuildContext context,AsyncSnapshot<List<QuerySnapshot>> snapshot){
            if(snapshot.hasError) {
              return Center(
                child: Text(
                  "Não foi possível carregar",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 22.sp
                  ),
                ),
              );
            }
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            var dom = snapshot.data![0].docs.elementAt(1)["Dom"];
            List<String> domordering = List<String>.from(dom.map((date) => date));
            domordering.sort((a, b) => a.toString().compareTo(b.toString()));
            List<TimeOfDay> domordering2 = List<TimeOfDay>.from(domordering.map((hour) => TimeOfDay(hour: int.parse(hour.split(":")[0]), minute: int.parse(hour.split(":")[1])))).toList();
            List<TimeOfDay> domnight  = domordering2.where((item) {
              return item.hour >= 18;
            }).toList();
            List<TimeOfDay> domday  = domordering2.where((item) {
              return item.hour < 18;
            }).toList();
            var seg = snapshot.data![0].docs.elementAt(1)["Seg"];
            List<String> segordering = List<String>.from(seg.map((date) => date));
            segordering.sort((a, b) => a.toString().compareTo(b.toString()));
            List<TimeOfDay> segordering2 = List<TimeOfDay>.from(segordering.map((hour) => TimeOfDay(hour: int.parse(hour.split(":")[0]), minute: int.parse(hour.split(":")[1])))).toList();
            List<TimeOfDay> segnight  = segordering2.where((item) {
              return item.hour >= 18;
            }).toList();
            List<TimeOfDay> segday  = segordering2.where((item) {
              return item.hour < 18;
            }).toList();
            var ter = snapshot.data![0].docs.elementAt(1)["Ter"];
            List<String> terordering = List<String>.from(ter.map((date) => date));
            terordering.sort((a, b) => a.toString().compareTo(b.toString()));
            List<TimeOfDay> terordering2 = List<TimeOfDay>.from(terordering.map((hour) => TimeOfDay(hour: int.parse(hour.split(":")[0]), minute: int.parse(hour.split(":")[1])))).toList();
            List<TimeOfDay> ternight  = terordering2.where((item) {
              return item.hour >= 18;
            }).toList();
            List<TimeOfDay> terday  = terordering2.where((item) {
              return item.hour < 18;
            }).toList();
            var qua = snapshot.data![0].docs.elementAt(1)["Qua"];
            List<String> quaordering = List<String>.from(qua.map((date) => date));
            quaordering.sort((a, b) => a.toString().compareTo(b.toString()));
            List<TimeOfDay> quaordering2 = List<TimeOfDay>.from(quaordering.map((hour) => TimeOfDay(hour: int.parse(hour.split(":")[0]), minute: int.parse(hour.split(":")[1])))).toList();
            List<TimeOfDay> quanight  = quaordering2.where((item) {
              return item.hour >= 18;
            }).toList();
            List<TimeOfDay> quaday  = quaordering2.where((item) {
              return item.hour < 18;
            }).toList();
            var qui = snapshot.data![0].docs.elementAt(1)["Qui"];
            List<String> quiordering = List<String>.from(qui.map((date) => date));
            quiordering.sort((a, b) => a.toString().compareTo(b.toString()));
            List<TimeOfDay> quiordering2 = List<TimeOfDay>.from(quiordering.map((hour) => TimeOfDay(hour: int.parse(hour.split(":")[0]), minute: int.parse(hour.split(":")[1])))).toList();
            List<TimeOfDay> quinight  = quiordering2.where((item) {
              return item.hour >= 18;
            }).toList();
            List<TimeOfDay> quiday  = quiordering2.where((item) {
              return item.hour < 18;
            }).toList();
            var sexta = snapshot.data![0].docs.elementAt(1)["Sex"];
            List<String> sextaordering = List<String>.from(sexta.map((date) => date));
            sextaordering.sort((a, b) => a.toString().compareTo(b.toString()));
            List<TimeOfDay> sextaordering2 = List<TimeOfDay>.from(sextaordering.map((hour) => TimeOfDay(hour: int.parse(hour.split(":")[0]), minute: int.parse(hour.split(":")[1])))).toList();
            List<TimeOfDay> sextanight  = sextaordering2.where((item) {
              return item.hour >= 18;
            }).toList();
            List<TimeOfDay> sextaday  = sextaordering2.where((item) {
              return item.hour < 18;
            }).toList();
            var sab = snapshot.data![0].docs.elementAt(1)["Sab"];
            List<String> sabordering = List<String>.from(sab.map((date) => date));
            sabordering.sort((a, b) => a.toString().compareTo(b.toString()));
            List<TimeOfDay> sabordering2 = List<TimeOfDay>.from(sabordering.map((hour) => TimeOfDay(hour: int.parse(hour.split(":")[0]), minute: int.parse(hour.split(":")[1])))).toList();
            List<TimeOfDay> sabnight  = sabordering2.where((item) {
              return item.hour >= 18;
            }).toList();
            List<TimeOfDay> sabday  = sabordering2.where((item) {
              return item.hour < 18;
            }).toList();
            List primeirohorariodia =[
              segday.isEmpty? "" : segday[0],
              terday.isEmpty? "" :terday[0],
              quaday.isEmpty? "" :quaday[0],
              quiday.isEmpty? "" :quiday[0],
              sextaday.isEmpty? "" : sextaday[0],
              sabday.isEmpty? "" :sabday[0],
              domday.isEmpty? "" : domday[0]
            ];
            List ultimohorariodia =[
              segday.isEmpty? "" : segday[segday.length-1],
              terday.isEmpty? "" :terday[terday.length-1],
              quaday.isEmpty? "" :quaday[quaday.length-1],
              quiday.isEmpty? "" :quiday[quiday.length-1],
              sextaday.isEmpty? "" :sextaday[sextaday.length-1],
              sabday.isEmpty? "" : sabday[sabday.length-1],
              domday.isEmpty? "" :domday[domday.length-1]
            ];
            List primeirohorarionoite =[
              segnight.isEmpty? "" : segnight[0],
              ternight.isEmpty? "" :ternight[0],
              quanight.isEmpty? "" :quanight[0],
              quinight.isEmpty? "" :quinight[0],
              sextanight.isEmpty? "" : sextanight[0],
              sabnight.isEmpty? "" :sabnight[0],
              domnight.isEmpty? "" : domnight[0]
            ];
            List ultimohorarionoite =[
              segnight.isEmpty? "" : segnight[segnight.length-1],
              ternight.isEmpty? "" :ternight[ternight.length-1],
              quanight.isEmpty? "" :quanight[quanight.length-1],
              quinight.isEmpty? "" :quinight[quinight.length-1],
              sextanight.isEmpty? "" :sextanight[sextanight.length-1],
              sabnight.isEmpty? "" : sabnight[sabnight.length-1],
              domnight.isEmpty? "" :domnight[domnight.length-1]
            ];
            return Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: Center(
                child: Container(
                  child: Center(
                    child: Container(
                      height: 680.h,
                      child: CarouselSlider(
                        options: CarouselOptions(
                          enableInfiniteScroll: true,
                          height: 628.h,
                          autoPlay: false,
                          enlargeStrategy: CenterPageEnlargeStrategy.scale,
                          enlargeCenterPage: true,
                          onPageChanged: (index, reason){
                            setState(() {
                              selectedItem = index;
                            });
                          },
                        ),
                        items: [
                          Container(
                            child: Padding(
                              padding: EdgeInsets.all(6.0.sp),
                              child: Center(
                                child: Container(
                                  height: 600.h,
                                  width: 300.w,
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Flexible(
                                          flex: 12,
                                          child: Stack(
                                            children: [
                                              Container(
                                                height: 200.h,
                                                width: 300.w,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        width: 3.sp,
                                                        color: Color(0xFF03A9f4)
                                                    ),
                                                    borderRadius: BorderRadius.circular(15.sp),
                                                    image: DecorationImage(
                                                        image: NetworkImage(snapshot.data![1].docs.elementAt(0)["url"]),
                                                        fit: BoxFit.fill
                                                    )
                                                ),
                                              ),
                                              Positioned.fill(
                                                child: Align(
                                                  alignment: Alignment.bottomRight,
                                                  child: Container(
                                                    height: 60.h,
                                                    width: 60.w,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        UploadImage();
                                                      },
                                                      child: Container(
                                                        width: 60.w,
                                                        child: Center(
                                                          child: Icon(
                                                            Icons.image,
                                                            color: Colors.white,
                                                            size: 40.sp,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Flexible(
                                          flex: 2,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              _Dot(0),
                                              _Dot(1),
                                              _Dot(2),
                                              _Dot(3),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        Flexible(
                                          flex: 23,
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                  flex: 2,
                                                  child: Container(
                                                    child: Text(
                                                      "Funcionamento",
                                                      style: GoogleFonts.roboto(
                                                          fontSize: 30.sp,
                                                          color: Colors.white
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height:5.h,
                                                ),
                                                Divider(
                                                  height: 5.h,
                                                  thickness: 3,
                                                  color: Color(0xFF03A9f4),
                                                ),
                                                SizedBox(
                                                  height: 5.h,
                                                ),
                                                Flexible(
                                                  flex: 13,
                                                  child: Container(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Container(
                                                              width: 110.w,
                                                            ),
                                                            Column(
                                                              children: [
                                                                Container(
                                                                  child: Center(
                                                                    child: Text("Almoço",
                                                                      style: GoogleFonts.roboto(
                                                                          fontSize: 20.sp,
                                                                          color: Colors.white,
                                                                          fontWeight: FontWeight.bold
                                                                      ),),
                                                                  ),
                                                                  width: 100.w,
                                                                ),
                                                              ],
                                                            ),
                                                            Container(
                                                              width: 90.w,
                                                              child: Center(
                                                                child: Text("Jantar",
                                                                  style: GoogleFonts.roboto(
                                                                    fontSize: 20.sp,
                                                                    color: Colors.white,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        _Horario(weekday[DateTime.now().weekday-1].toString(),
                                                            primeirohorariodia[DateTime.now().weekday-1] == ""? "-": primeirohorariodia[DateTime.now().weekday-1].hour.toString().padLeft(2, "0") + ":"
                                                                + primeirohorariodia[DateTime.now().weekday-1].minute.toString().padLeft(2, "0") + " - " +
                                                                ultimohorariodia[DateTime.now().weekday-1].hour.toString().padLeft(2, "0") + ":"+
                                                                ultimohorariodia[DateTime.now().weekday-1].minute.toString().padLeft(2, "0"),
                                                            primeirohorarionoite[DateTime.now().weekday-1] == ""? "-": primeirohorarionoite[DateTime.now().weekday-1].hour.toString().padLeft(2, "0") + ":"
                                                                + primeirohorarionoite[DateTime.now().weekday-1].minute.toString().padLeft(2, "0") + " - " +
                                                                ultimohorarionoite[DateTime.now().weekday-1].hour.toString().padLeft(2, "0") + ":"+
                                                                ultimohorarionoite[DateTime.now().weekday-1].minute.toString().padLeft(2, "0")),
                                                        _Horario(weekday[DateTime.now().add(Duration(days: 1)).weekday-1].toString(),
                                                            primeirohorariodia[DateTime.now().add(Duration(days: 1)).weekday-1] == ""? "-": primeirohorariodia[DateTime.now().add(Duration(days: 1)).weekday-1].hour.toString().padLeft(2, "0") + ":"
                                                                + primeirohorariodia[DateTime.now().add(Duration(days: 1)).weekday-1].minute.toString().padLeft(2, "0") + " - " +
                                                                ultimohorariodia[DateTime.now().add(Duration(days: 1)).weekday-1].hour.toString().padLeft(2, "0") + ":"+
                                                                ultimohorariodia[DateTime.now().add(Duration(days: 1)).weekday-1].minute.toString().padLeft(2, "0"),
                                                            primeirohorarionoite[DateTime.now().add(Duration(days: 1)).weekday-1] == ""? "-": primeirohorarionoite[DateTime.now().add(Duration(days: 1)).weekday-1].hour.toString().padLeft(2, "0") + ":"
                                                                + primeirohorarionoite[DateTime.now().add(Duration(days: 1)).weekday-1].minute.toString().padLeft(2, "0") + " - " +
                                                                ultimohorarionoite[DateTime.now().add(Duration(days: 1)).weekday-1].hour.toString().padLeft(2, "0") + ":"+
                                                                ultimohorarionoite[DateTime.now().add(Duration(days: 1)).weekday-1].minute.toString().padLeft(2, "0")),
                                                        _Horario(weekday[DateTime.now().add(Duration(days: 2)).weekday-1].toString(),
                                                            primeirohorariodia[DateTime.now().add(Duration(days: 2)).weekday-1] == ""?"-": primeirohorariodia[DateTime.now().add(Duration(days: 2)).weekday-1].hour.toString().padLeft(2, "0") + ":"
                                                                + primeirohorariodia[DateTime.now().add(Duration(days: 2)).weekday-1].minute.toString().padLeft(2, "0") + " - " +
                                                                ultimohorariodia[DateTime.now().add(Duration(days: 2)).weekday-1].hour.toString().padLeft(2, "0") + ":"+
                                                                ultimohorariodia[DateTime.now().add(Duration(days: 2)).weekday-1].minute.toString().padLeft(2, "0"),
                                                            primeirohorarionoite[DateTime.now().add(Duration(days: 2)).weekday-1] == ""?"-": primeirohorarionoite[DateTime.now().add(Duration(days: 2)).weekday-1].hour.toString().padLeft(2, "0") + ":"
                                                                + primeirohorarionoite[DateTime.now().add(Duration(days: 2)).weekday-1].minute.toString().padLeft(2, "0") + " - " +
                                                                ultimohorarionoite[DateTime.now().add(Duration(days: 2)).weekday-1].hour.toString().padLeft(2, "0") + ":"+
                                                                ultimohorarionoite[DateTime.now().add(Duration(days: 2)).weekday-1].minute.toString().padLeft(2, "0")),
                                                        _Horario(weekday[DateTime.now().add(Duration(days: 3)).weekday-1].toString(),
                                                            primeirohorariodia[DateTime.now().add(Duration(days: 3)).weekday-1] == ""?"-": primeirohorariodia[DateTime.now().add(Duration(days: 3)).weekday-1].hour.toString().padLeft(2, "0") + ":"
                                                                + primeirohorariodia[DateTime.now().add(Duration(days: 3)).weekday-1].minute.toString().padLeft(2, "0") + " - " +
                                                                ultimohorariodia[DateTime.now().add(Duration(days: 3)).weekday-1].hour.toString().padLeft(2, "0") + ":"+
                                                                ultimohorariodia[DateTime.now().add(Duration(days: 3)).weekday-1].minute.toString().padLeft(2, "0"),
                                                            primeirohorarionoite[DateTime.now().add(Duration(days: 3)).weekday-1] == ""?"-": primeirohorarionoite[DateTime.now().add(Duration(days: 3)).weekday-1].hour.toString().padLeft(2, "0") + ":"
                                                                + primeirohorarionoite[DateTime.now().add(Duration(days: 3)).weekday-1].minute.toString().padLeft(2, "0") + " - " +
                                                                ultimohorarionoite[DateTime.now().add(Duration(days: 3)).weekday-1].hour.toString().padLeft(2, "0") + ":"+
                                                                ultimohorarionoite[DateTime.now().add(Duration(days: 3)).weekday-1].minute.toString().padLeft(2, "0")),
                                                        _Horario(weekday[DateTime.now().add(Duration(days: 4)).weekday-1].toString(),
                                                          primeirohorariodia[DateTime.now().add(Duration(days: 4)).weekday-1] == ""?"-": primeirohorariodia[DateTime.now().add(Duration(days: 4)).weekday-1].hour.toString().padLeft(2, "0") + ":"
                                                              + primeirohorariodia[DateTime.now().add(Duration(days: 4)).weekday-1].minute.toString().padLeft(2, "0") + " - " +
                                                              ultimohorariodia[DateTime.now().add(Duration(days: 4)).weekday-1].hour.toString().padLeft(2, "0") + ":"+
                                                              ultimohorariodia[DateTime.now().add(Duration(days: 4)).weekday-1].minute.toString().padLeft(2, "0"),
                                                          primeirohorarionoite[DateTime.now().add(Duration(days: 4)).weekday-1] == ""?"-": primeirohorarionoite[DateTime.now().add(Duration(days: 4)).weekday-1].hour.toString().padLeft(2, "0") + ":"
                                                              + primeirohorarionoite[DateTime.now().add(Duration(days: 4)).weekday-1].minute.toString().padLeft(2, "0") + " - " +
                                                              ultimohorarionoite[DateTime.now().add(Duration(days: 4)).weekday-1].hour.toString().padLeft(2, "0") + ":"+
                                                              ultimohorarionoite[DateTime.now().add(Duration(days: 4)).weekday-1].minute.toString().padLeft(2, "0"),),
                                                        _Horario(weekday[DateTime.now().add(Duration(days: 5)).weekday-1].toString(),
                                                          primeirohorariodia[DateTime.now().add(Duration(days: 5)).weekday-1] == ""?"-": primeirohorariodia[DateTime.now().add(Duration(days: 5)).weekday-1].hour.toString().padLeft(2, "0") + ":"
                                                              + primeirohorariodia[DateTime.now().add(Duration(days: 5)).weekday-1].minute.toString().padLeft(2, "0") + " - " +
                                                              ultimohorariodia[DateTime.now().add(Duration(days: 5)).weekday-1].hour.toString().padLeft(2, "0") + ":"+
                                                              ultimohorariodia[DateTime.now().add(Duration(days: 5)).weekday-1].minute.toString().padLeft(2, "0"),
                                                          primeirohorarionoite[DateTime.now().add(Duration(days: 5)).weekday-1] == ""?"-": primeirohorarionoite[DateTime.now().add(Duration(days: 5)).weekday-1].hour.toString().padLeft(2, "0") + ":"
                                                              + primeirohorarionoite[DateTime.now().add(Duration(days: 5)).weekday-1].minute.toString().padLeft(2, "0") + " - " +
                                                              ultimohorarionoite[DateTime.now().add(Duration(days: 5)).weekday-1].hour.toString().padLeft(2, "0") + ":"+
                                                              ultimohorarionoite[DateTime.now().add(Duration(days: 5)).weekday-1].minute.toString().padLeft(2, "0"),),
                                                        _Horario(weekday[DateTime.now().add(Duration(days: 6)).weekday-1].toString(),
                                                          primeirohorariodia[DateTime.now().add(Duration(days: 6)).weekday-1] == ""?"-": primeirohorariodia[DateTime.now().add(Duration(days: 6)).weekday-1].hour.toString().padLeft(2, "0") + ":"
                                                              + primeirohorariodia[DateTime.now().add(Duration(days: 6)).weekday-1].minute.toString().padLeft(2, "0") + " - " +
                                                              ultimohorariodia[DateTime.now().add(Duration(days: 6)).weekday-1].hour.toString().padLeft(2, "0") + ":"+
                                                              ultimohorariodia[DateTime.now().add(Duration(days: 6)).weekday-1].minute.toString().padLeft(2, "0"),
                                                          primeirohorarionoite[DateTime.now().add(Duration(days: 6)).weekday-1] == ""?"-": primeirohorarionoite[DateTime.now().add(Duration(days: 6)).weekday-1].hour.toString().padLeft(2, "0") + ":"
                                                              + primeirohorarionoite[DateTime.now().add(Duration(days: 6)).weekday-1].minute.toString().padLeft(2, "0") + " - " +
                                                              ultimohorarionoite[DateTime.now().add(Duration(days: 6)).weekday-1].hour.toString().padLeft(2, "0") + ":"+
                                                              ultimohorarionoite[DateTime.now().add(Duration(days: 6)).weekday-1].minute.toString().padLeft(2, "0"),),
                                                      ],
                                                    ),
                                                  ),
                                                ),

                                                SizedBox(
                                                  height: 5.h,
                                                ),
                                                Divider(
                                                    thickness: 3,
                                                    color: Color(0xFF03A9f4)
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          _CarrouselImage(snapshot.data![1].docs.elementAt(1)["url"],
                              "Nossa História", _tText1),
                          _CarrouselImage(snapshot.data![1].docs.elementAt(2)["url"],
                              "Quem Somos",_tText2),
                          _CarrouselImage(snapshot.data![1].docs.elementAt(3)["url"], "Nossa Missão",_tText3),
                          _CarrouselImage(snapshot.data![1].docs.elementAt(4)["url"], "Nossos Produtos", _tText4),


                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  _Horario(String dia, String manha, String noite){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Text(dia,
            style: GoogleFonts.roboto(
                fontSize: 18.sp,
                color: Colors.white,
                fontStyle: FontStyle.italic
            ),),
          width: 110.w,
        ),
        Container(
          width: 90.w,
          child: Center(
            child: Text(manha,
              style: GoogleFonts.roboto(
                fontSize: 15.sp,
                color: Colors.white,
              ),),
          ),
        ),
        Container(
          width: 90.w,
          child: Center(
            child: Text(noite,
              style: GoogleFonts.roboto(
                fontSize: 15.sp,
                color: Colors.white,
              ),),
          ),
        ),
      ],
    );
  }

  _CarrouselImage(String image, String titulo, TextEditingController controller) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(6.0.sp),
        child: Center(
          child: Container(
            height: 600.h,
            width: 300.w,
            child: Container(
              child: Column(
                children: [
                  Flexible(
                    flex: 12,
                    child: Stack(
                      children: [
                        Container(
                          height: 200.h,
                          width: 300.w,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 3.sp,
                                  color: Color(0xFF03A9f4)
                              ),
                              borderRadius: BorderRadius.circular(15.sp),
                              image: DecorationImage(
                                  image: NetworkImage(image),
                                  fit: BoxFit.fill
                              )
                          ),
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              height: 60.h,
                              width: 60.w,
                              child: GestureDetector(
                                onTap: () {
                                  UploadImage();
                                },
                                child: Container(
                                  width: 60.w,
                                  child: Center(
                                    child: Icon(
                                      Icons.image,
                                      color: Colors.white,
                                      size: 40.sp,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Flexible(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _Dot(0),
                        _Dot(1),
                        _Dot(2),
                        _Dot(3),
                        _Dot(4),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Flexible(
                    flex: 24,
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            flex: 2,
                            child: Container(
                              child: Text(
                                titulo,
                                style: GoogleFonts.roboto(
                                    fontSize: 30.sp,
                                    color: Colors.white
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height:5.h,
                          ),
                          Divider(
                            height: 5.h,
                            thickness: 3,
                            color: Color(0xFF03A9f4),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Flexible(
                            flex: 13,
                            child: Container(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.transparent),
                                  ),
                                ),
                                onEditingComplete: (){
                                  FirebaseFirestore.instance.collection("sobrenos").doc(selectedItem.toString()).update({
                                    "text": controller.text
                                  });
                                  FocusScope.of(context).unfocus();
                                },
                                keyboardType: TextInputType.multiline,
                                textInputAction: TextInputAction.done,
                                maxLines: null,
                                controller: controller,
                                textAlign: TextAlign.justify,
                                style: GoogleFonts.roboto(
                                    fontSize: 18.sp,
                                    color: Colors.white
                                ),
                                ),
                              ),
                            ),
                          Divider(
                              thickness: 3,
                              color: Color(0xFF03A9f4)
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _Dot(index) {
    return Container(
      width: 10.w,
      height: 10.h,
      margin: EdgeInsets.symmetric(vertical: 10.0.h, horizontal: 3.0.w),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selectedItem == index? Color(0xFF03A9f4): Colors.grey
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
            .child("images/"+ selectedItem.toString())
            .putFile(file);
        var downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          imageUrl = downloadUrl;
          print(downloadUrl);
          FirebaseFirestore.instance.collection("sobrenos").doc(selectedItem.toString()).update({
            "url": imageUrl
          });
        });
      } else {
        print("No Image Path Received");
      }
    } else {
      print ('Permission not granted. Try Again whit permission access');
    }
  }


}
