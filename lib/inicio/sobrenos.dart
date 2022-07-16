import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SobrenosPage extends StatefulWidget {
  @override
  _SobrenosPageState createState() => _SobrenosPageState();
}

class _SobrenosPageState extends State <SobrenosPage> {

  var selectedItem = 0;

  List weekday = [
    "Segunda-feira",
    "Terça-feira",
    "Quarta-feira",
    "Quinta-feira",
    "Sexta-feira",
    "Sábado",
    "Domingo"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xF7131313),
      body: _body(),
    );
  }

  _body() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("funcionamento").snapshots(),
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
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
          var dom = snapshot.data!.docs.elementAt(1)["Dom"];
          List<String> domordering = List<String>.from(dom.map((date) => date));
          domordering.sort((a, b) => a.toString().compareTo(b.toString()));
          List<TimeOfDay> domordering2 = List<TimeOfDay>.from(domordering.map((hour) => TimeOfDay(hour: int.parse(hour.split(":")[0]), minute: int.parse(hour.split(":")[1])))).toList();
          List<TimeOfDay> domnight  = domordering2.where((item) {
            return item.hour >= 18;
          }).toList();
          List<TimeOfDay> domday  = domordering2.where((item) {
            return item.hour < 18;
          }).toList();
          var seg = snapshot.data!.docs.elementAt(1)["Seg"];
          List<String> segordering = List<String>.from(seg.map((date) => date));
          segordering.sort((a, b) => a.toString().compareTo(b.toString()));
          List<TimeOfDay> segordering2 = List<TimeOfDay>.from(segordering.map((hour) => TimeOfDay(hour: int.parse(hour.split(":")[0]), minute: int.parse(hour.split(":")[1])))).toList();
          List<TimeOfDay> segnight  = segordering2.where((item) {
            return item.hour >= 18;
          }).toList();
          List<TimeOfDay> segday  = segordering2.where((item) {
            return item.hour < 18;
          }).toList();
          var ter = snapshot.data!.docs.elementAt(1)["Ter"];
          List<String> terordering = List<String>.from(ter.map((date) => date));
          terordering.sort((a, b) => a.toString().compareTo(b.toString()));
          List<TimeOfDay> terordering2 = List<TimeOfDay>.from(terordering.map((hour) => TimeOfDay(hour: int.parse(hour.split(":")[0]), minute: int.parse(hour.split(":")[1])))).toList();
          List<TimeOfDay> ternight  = terordering2.where((item) {
            return item.hour >= 18;
          }).toList();
          List<TimeOfDay> terday  = terordering2.where((item) {
            return item.hour < 18;
          }).toList();
          var qua = snapshot.data!.docs.elementAt(1)["Qua"];
          List<String> quaordering = List<String>.from(qua.map((date) => date));
          quaordering.sort((a, b) => a.toString().compareTo(b.toString()));
          List<TimeOfDay> quaordering2 = List<TimeOfDay>.from(quaordering.map((hour) => TimeOfDay(hour: int.parse(hour.split(":")[0]), minute: int.parse(hour.split(":")[1])))).toList();
          List<TimeOfDay> quanight  = quaordering2.where((item) {
            return item.hour >= 18;
          }).toList();
          List<TimeOfDay> quaday  = quaordering2.where((item) {
            return item.hour < 18;
          }).toList();
          var qui = snapshot.data!.docs.elementAt(1)["Qui"];
          List<String> quiordering = List<String>.from(qui.map((date) => date));
          quiordering.sort((a, b) => a.toString().compareTo(b.toString()));
          List<TimeOfDay> quiordering2 = List<TimeOfDay>.from(quiordering.map((hour) => TimeOfDay(hour: int.parse(hour.split(":")[0]), minute: int.parse(hour.split(":")[1])))).toList();
          List<TimeOfDay> quinight  = quiordering2.where((item) {
            return item.hour >= 18;
          }).toList();
          List<TimeOfDay> quiday  = quiordering2.where((item) {
            return item.hour < 18;
          }).toList();
          var sexta = snapshot.data!.docs.elementAt(1)["Sex"];
          List<String> sextaordering = List<String>.from(sexta.map((date) => date));
          sextaordering.sort((a, b) => a.toString().compareTo(b.toString()));
          List<TimeOfDay> sextaordering2 = List<TimeOfDay>.from(sextaordering.map((hour) => TimeOfDay(hour: int.parse(hour.split(":")[0]), minute: int.parse(hour.split(":")[1])))).toList();
          List<TimeOfDay> sextanight  = sextaordering2.where((item) {
            return item.hour >= 18;
          }).toList();
          List<TimeOfDay> sextaday  = sextaordering2.where((item) {
            return item.hour < 18;
          }).toList();
          var sab = snapshot.data!.docs.elementAt(1)["Sab"];
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
                    height: 620.h,
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
                                        child: Container(
                                          height: 200.h,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 3.sp,
                                                  color: Color(0xFF03A9f4)
                                              ),
                                              borderRadius: BorderRadius.circular(15.sp),
                                              image: DecorationImage(
                                                  image: NetworkImage("https://www.salvadordabahia.com/wp-content/uploads/2019/08/restaurante-pedra-do-mar--rio-vermelho--salvador-bahia--foto-tarso-figueira-assessoria-4-587x434.jpg"),
                                                  fit: BoxFit.fill
                                              )
                                          ),
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
                        _CarrouselImage("https://www.salvadordabahia.com/wp-content/uploads/2019/08/restaurante-pedra-do-mar--rio-vermelho--salvador-bahia--foto-tarso-figueira-assessoria-4-587x434.jpg",
                            "Nossa História", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse dapibus orci lectus, quis ullamcorper ipsum feugiat ac. Maecenas rutrum efficitur congue. Suspendisse placerat fermentum justo a suscipit. Pellentesque mauris justo, ultrices ac velit a, ultrices sollicitudin sem. Praesent sodales semper ornare. Sed id ornare odio."),
                        _CarrouselImage("https://idsb.tmgrup.com.tr/ly/uploads/images/2021/02/22/95160.jpg",
                            "Quem Somos", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse dapibus orci lectus, quis ullamcorper ipsum feugiat ac. Maecenas rutrum efficitur congue. Suspendisse placerat fermentum justo a suscipit. Pellentesque mauris justo, ultrices ac velit a, ultrices sollicitudin sem. Praesent sodales semper ornare. Sed id ornare odio."),
                        _CarrouselImage("https://b.zmtcdn.com/data/pictures/5/8000305/a0c27c684230ee2add0d68f3bf7ca85f.jpg?fit=around|300:273&crop=300:273;*,*", "Nossa Missão", "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse dapibus orci lectus, quis ullamcorper ipsum feugiat ac. Maecenas rutrum efficitur congue. Suspendisse placerat fermentum justo a suscipit. Pellentesque mauris justo, ultrices ac velit a, ultrices sollicitudin sem. Praesent sodales semper ornare. Sed id ornare odio."),
                        _CarrouselImage("https://st4.depositphotos.com/13349494/20744/i/600/depositphotos_207443534-stock-photo-healthy-salad-and-pizza-on.jpg", "Nossos Produtos","Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse dapibus orci lectus, quis ullamcorper ipsum feugiat ac. Maecenas rutrum efficitur congue. Suspendisse placerat fermentum justo a suscipit. Pellentesque mauris justo, ultrices ac velit a, ultrices sollicitudin sem. Praesent sodales semper ornare. Sed id ornare odio."),


                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
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

  _CarrouselImage(String image, String titulo, String texto) {
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
                    child: Container(
                      height: 200.h,
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
                              child: Text(
                                texto,
                                textAlign: TextAlign.justify,
                                style: GoogleFonts.roboto(
                                    fontSize: 18.sp,
                                    color: Colors.white
                                ),
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
}
