import 'package:allonsyapp/utils/animacao.dart';
import 'package:allonsyapp/utils/nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';


class ReservasPage extends StatefulWidget {

  @override
  _ReservasPageState createState() => _ReservasPageState();
}

class _ReservasPageState extends State<ReservasPage> {
  final user = FirebaseAuth.instance.currentUser;

  bool jantar = false;


  var selectedDate = DateTime.now();

   int currentDateSelectedindex =0;
   ScrollController scrollController = ScrollController();

   var currentTimeSelectedindex = null;
   int currentPeopleSelectedindex = 0;

   List<String> listofMonths =[
     "Janeiro",
     "Fevereiro",
     "Março",
     "Abril",
     "Maio",
     "Junho",
     "Julho",
     "Agosto",
     "Setembro",
     "Outubro",
     "Novembro",
     "Dezembro"
   ];

   List<String> listofDays =[
     "Segunda",
     "Terça",
     "Quarta",
     "Quinta",
     "Sexta",
     "Sábado",
     "Domingo"
   ];

  List<String> weekDays =[
    "Seg",
    "Ter",
    "Qua",
    "Qui",
    "Sex",
    "Sab",
    "Dom"
  ];



  List<TimeOfDay> listofTimesDay = [];

  List<TimeOfDay> listofTimesNight = [];


  List<int> listofPeople = [
    1,
    2,
    3,
    4,
    5,
    6,
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xF7131313),
      body: _body(),
      appBar: AppBar(
          toolbarHeight: 60.h,
          backgroundColor: Color(0xFF1B1B1B),
          centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          iconSize: 32.sp,
          color: Colors.white,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
          title: Text("Faça sua reserva",
            style: GoogleFonts.dancingScript(
                fontSize: 40.0.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold
            ),),
        ),
      );
  }

  _body() {
    return Padding(
      padding: EdgeInsets.only(left: 5.w, right: 5.w),
      child: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.0.w, top: 15.h),
              child: Container(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Dia",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                      fontSize: 25.sp,
                        color: Colors.grey.withOpacity(0.9)
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.h),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("funcionamento").snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if(snapshot.hasError){
                  return Center(
                    child: Text(
                      "Não foi possível carregar as datas",
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
                List<DateTime> listDates = List<DateTime>.from(snapshot.data!.docs.elementAt(0)["data"].map((date) => date.toDate()));
                List<DateTime> currentlistDates = listDates.where((element) => element.millisecondsSinceEpoch>DateTime.now().subtract(Duration(days: 1)).millisecondsSinceEpoch).toList();
                currentlistDates.sort((a, b){
                  return a.compareTo(b);
                });
                return Container(
                  height: 100.h,
                  child: Container(
                    child: ListView.separated(
                      controller: scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: currentlistDates.length,
                      separatorBuilder: (BuildContext context, int index){
                        return SizedBox(width: 10.w);
                      },
                      itemBuilder: (BuildContext context, int index){
                        return GestureDetector(
                          onTap: (){
                            setState(() {
                              currentDateSelectedindex = index;
                              selectedDate = currentlistDates.elementAt(index);
                            });
                          },
                          child: Container(
                            height: 80.h,
                            width: 100.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 4.sp,
                                  color: Color(0xFF03A9f4)
                              ),
                              borderRadius: BorderRadius.circular(10),
                              color: currentDateSelectedindex == index
                                  ? Color(0xFF03A9f4).withOpacity(0.9) : Colors.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  listofMonths[currentlistDates.elementAt(index).month-1].toString(),
                                  style: GoogleFonts.roboto(
                                    fontSize: 16.sp,
                                    color: currentDateSelectedindex == index
                                        ? Colors.white
                                        : Colors.grey.shade800,
                                  ),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  currentlistDates.elementAt(index).day.toString(),
                                  style: GoogleFonts.roboto(
                                    fontSize: 22.sp,
                                    color: currentDateSelectedindex == index
                                        ? Colors.white
                                        : Colors.grey.shade800,
                                  ),
                                ),
                                SizedBox(
                                    height: 5.h
                                ),
                                Text(
                                  listofDays[currentlistDates.elementAt(index).weekday-1].toString(),
                                  style: GoogleFonts.roboto(
                                    fontSize: 16.sp,
                                    color: currentDateSelectedindex == index
                                        ? Colors.white
                                        : Colors.grey.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 15.h),
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Horário",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                        fontSize: 26.sp,
                        color: Colors.grey.withOpacity(0.9)
                    ),
                  ),
                  FlutterSwitch(
                    value: jantar,
                    activeColor: Color(0xF7131313),
                    inactiveColor: Colors.white,
                    toggleColor: Colors.transparent,
                    valueFontSize: 16.sp,
                    toggleSize: 35.sp,
                    borderRadius: 30.sp,
                    activeText: "Jantar",
                    inactiveText: "Almoço",
                    activeTextColor: Colors.white,
                    inactiveIcon: Icon(
                      Icons.wb_sunny,
                      size: 30.sp,
                      color: Colors.yellow.shade700,
                    ),
                    activeIcon: Icon(
                      Icons.nightlight_round,
                      size: 30.sp,
                      color: Colors.yellow.shade700,
                    ),
                    inactiveSwitchBorder: Border.all(
                        color: Color(0xFF03A9f4),
                        width: 3.sp
                    ),
                    activeSwitchBorder: Border.all(
                        color: Colors.white,
                        width: 3.sp
                    ),
                    inactiveTextColor: Color(0xFF03A9f4),
                    showOnOff: true,
                    width: jantar == false? 105.sp: 96.sp,
                    height: 40.sp,
                    onToggle: (val) {
                      setState(() {
                        jantar = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.h),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("funcionamento").snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> horario){
                  if(horario.hasError){
                    return Center(
                      child: Text(
                        "Não foi possível carregar os horários",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 22.sp
                        ),
                      ),
                    );
                  }
                  if(!horario.hasData){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  List<DateTime> listDates = List<DateTime>.from(horario.data!.docs.elementAt(0)["data"].map((date) => date.toDate()));
                  List<DateTime> currentlistDates = listDates.where((element) => element.millisecondsSinceEpoch>=DateTime.now().subtract(Duration(days:1)).millisecondsSinceEpoch).toList();
                  currentlistDates.sort((a, b){
                    return a.compareTo(b);
                  });
                  var time = horario.data!.docs.elementAt(1)[weekDays[currentlistDates.elementAt(currentDateSelectedindex).weekday-1]];
                  List<String> timeordering = List<String>.from(time.map((date) => date));
                  timeordering.sort((a, b) => a.toString().compareTo(b.toString()));
                  List<TimeOfDay> teste = List<TimeOfDay>.from(timeordering.map((hour) => TimeOfDay(hour: int.parse(hour.split(":")[0]), minute: int.parse(hour.split(":")[1])))).toList();
                  List<TimeOfDay> night  = teste.where((item) {
                    return item.hour >= 18;
                  }).toList();
                  List<TimeOfDay> day  = teste.where((item) {
                    return item.hour < 18;
                  }).toList();
                  return Container(
                    height: 250.h,
                    child: Padding(
                      padding: EdgeInsets.only(left: 7.w),
                      child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisExtent: 126.w
                          ),
                          scrollDirection: Axis.horizontal,
                          itemCount: jantar == false? day.length: night.length,
                          itemBuilder: (BuildContext context, int index){
                            return Container(
                              child: Column(
                                children: [
                                  Container(
                                    child: Text(
                                      jantar == false? day[index].hour.toString().padLeft(2, "0") + ":" + day[index].minute.toString().padLeft(2, "0") : night[index].hour.toString().padLeft(2, "0") + ":" + night[index].minute.toString().padLeft(2, "0"),
                                      style: GoogleFonts.roboto(
                                          color: Colors.white,
                                          fontSize: 22.sp
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance.collection("reservas").where("hora", isEqualTo: jantar== false? day[index].hour.toString().padLeft(2, "0")+":"+ day[index].minute.toString().padLeft(2, "0"): night[index].hour.toString().padLeft(2, "0")+":"+night[index].minute.toString().padLeft(2, "0")).where("dia",isEqualTo:selectedDate.day.toString()+" "+listofMonths[selectedDate.month-1]
                                        +", "+selectedDate.year.toString()).snapshots(),
                                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                                      if(!snapshot.hasData){
                                        return Text("");
                                      }
                                      if(jantar == false? day[index].hour<=DateTime.now().hour && selectedDate.day == DateTime.now().day: night[index].hour<=DateTime.now().hour && selectedDate.day == DateTime.now().day){
                                        return Padding(
                                          padding: EdgeInsets.only(right: 10.w),
                                          child: Stack(
                                            children: [
                                              Container(
                                                height: 85.h,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(10),
                                                    border: Border.all(
                                                        width: 3.sp,
                                                        color: Color(0xFF03A9f4)
                                                    )
                                                ),
                                                child: Center(
                                                  child: RotationTransition(
                                                    turns: AlwaysStoppedAnimation(
                                                        -20/360
                                                    ),
                                                    child: Text(
                                                      "Indisponível",
                                                      style: GoogleFonts.roboto(
                                                          color: Color(0xFF03A9f4),
                                                          fontSize: 16.sp,
                                                          fontWeight: FontWeight.bold
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                height: 85.h,
                                                decoration: BoxDecoration(
                                                  color: Colors.black.withOpacity(0.5),
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      }
                                      if(snapshot.data!.docs.isEmpty){
                                        return GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              currentTimeSelectedindex = index;
                                              listofTimesDay = day;
                                              listofTimesNight = night;
                                            });
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(right: 10.0.w),
                                            child: Container(
                                              height: 85.h,
                                              decoration: BoxDecoration(
                                                  color: currentTimeSelectedindex==index?Color(0xFF03A9f4):Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(
                                                      width: 3.sp,
                                                      color: Color(0xFF03A9f4)
                                                  )
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "Disponível",
                                                  style: GoogleFonts.roboto(
                                                      fontSize: 16.sp,
                                                      color: currentTimeSelectedindex == index?Colors.white:Colors.grey.shade800
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      return Padding(
                                        padding: EdgeInsets.only(right: 10.w),
                                        child: Stack(
                                          children: [
                                            Container(
                                              height: 85.h,
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(
                                                      width: 3.sp,
                                                      color: Color(0xFF03A9f4)
                                                  )
                                              ),
                                              child: Center(
                                                child: RotationTransition(
                                                  turns: AlwaysStoppedAnimation(
                                                      -20/360
                                                  ),
                                                  child: Text(
                                                    "Reservado",
                                                    style: GoogleFonts.roboto(
                                                        color: Color(0xFF03A9f4),
                                                        fontSize: 18.sp,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: 85.h,
                                              decoration: BoxDecoration(
                                                color: Colors.black.withOpacity(0.5),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                  );
                }),
            SizedBox(
              height: 20.h
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0.w,right: 8.0.w),
              child: Container(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Quantidade de pessoas",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.roboto(
                        fontSize: 26.sp,
                        color: Colors.grey.withOpacity(0.9)
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              height: 40.h,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (BuildContext context, int index){
                    return SizedBox(
                      width: 10.w,
                    );
                  },
                  itemCount: listofPeople.length,
                  itemBuilder: (BuildContext context, int index){
                    return GestureDetector(
                      onTap: (){
                        setState(() {
                          currentPeopleSelectedindex = index;
                        });
                      },
                      child: Container(
                        width: 70.w,
                        decoration: BoxDecoration(
                          color: currentPeopleSelectedindex== index?Color(0xFF03A9f4):Colors.white,
                          border: Border.all(
                            width: 3.sp,
                            color: Color(0xFF03A9f4)
                          ),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Center(
                          child: Text(
                            listofPeople[index].toString(),
                            style: GoogleFonts.roboto(
                              color: currentPeopleSelectedindex ==index?Colors.white:Colors.grey.shade800,
                              fontSize: 25.sp
                            ),
                          ),
                        ),
                      ),
                    );
                  },
              ),
            ),
            SizedBox(
              height: 25.h
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("reservas").where("dia",isEqualTo:selectedDate.day.toString()+" "+listofMonths[selectedDate.month-1]
                  +", "+selectedDate.year.toString()).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                if(!snapshot.hasData){
                  return Text("");
                }
                return GestureDetector(
                  onTap: () async {
                    if(await InternetConnectionChecker().hasConnection == false){
                      showSimpleNotification(
                        Text(
                          "Sem Internet",
                          style: TextStyle(color: Colors.white, fontSize: 20.sp),
                        ),
                        background: Colors.red
                      );
                    }
                    if(currentTimeSelectedindex == null && await InternetConnectionChecker().hasConnection == true) {
                      showSimpleNotification(
                        Text("Escolha um horário",
                        style: TextStyle(color: Colors.white, fontSize: 20.sp),
                        ),
                        background: Colors.red,
                      );
                    } if(currentTimeSelectedindex != null && await InternetConnectionChecker().hasConnection == true) {
                      FirebaseFirestore.instance.collection("reservas").doc().set({
                        "data": selectedDate.subtract(Duration(hours:selectedDate.hour,minutes: selectedDate.minute, seconds: selectedDate.second)).add(Duration(hours: jantar == false? listofTimesDay[currentTimeSelectedindex].hour: listofTimesNight[currentTimeSelectedindex].hour)),
                        "dia": selectedDate.day.toString()+" "+listofMonths[selectedDate.month-1]
                            +", "+selectedDate.year.toString(),
                        "user": user!.email,
                        "hora":jantar == false? listofTimesDay[currentTimeSelectedindex].hour.toString().padLeft(2, "0")+":"+listofTimesDay[currentTimeSelectedindex].minute.toString().padLeft(2, "0"): listofTimesNight[currentTimeSelectedindex].hour.toString().padLeft(2, "0")+":"+listofTimesNight[currentTimeSelectedindex].minute.toString().padLeft(2, "0"),
                        "pessoas":listofPeople[currentPeopleSelectedindex],
                        "solicitacao":DateTime.now(),
                        "scan": "",
                      });
                      push(context, AnimacaoPage(objetivo: "reservas"),replace: true);
                    }
                  },
                  child: Container(
                    height: 60.h,
                    decoration: BoxDecoration(
                        color: Color(0xFF03A9f4),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Text("Reservar",
                          style: GoogleFonts.roboto(
                            fontSize: 26.sp,
                            color: Colors.white,
                          )),
                    ),
                  ),
                );
              }
            )
          ],
        ),
      ),
    );
  }
}
