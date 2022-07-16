import 'package:allonsyapp/admin/data_admin/scheduling/scheduling_admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/nav.dart';


class TimeAdminPage extends StatefulWidget {
  const TimeAdminPage({Key? key}) : super(key: key);

  @override
  State<TimeAdminPage> createState() => _TimeAdminPageState();
}

class _TimeAdminPageState extends State<TimeAdminPage> {

  var selectedItem = 0;

  TimeOfDay selectedTime = TimeOfDay.now();

  List children = [
    "Dom",
    "Seg",
    "Ter",
    "Qua",
    "Qui",
    "Sex",
    "Sab",

  ];


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
            push(context, SchedulingAdminPage());
          },
        ),
        centerTitle: true,
        title: Text ("Horário",
          style: GoogleFonts.dancingScript(
              fontSize: 35.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 15.w),
            alignment: Alignment.centerRight,
            width: 40.w,
            child: GestureDetector(
              onTap: (){
                _selectTime(context);
              },
              child: Icon(Icons.add,
                  size: 32.sp,
                  color: Colors.white),
            )
          )],
      ),
      body: _body(),
    );
  }

  _body() {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Container(
              height: 58.h,
              color: Color(0xFF1B1B1B),
              child: _weekday(),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("funcionamento").snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snaphot){
                  if(snaphot.hasError){
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
                  if(!snaphot.hasData){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  var time = snaphot.data!.docs.elementAt(1)[children[selectedItem]];
                  List<String> timeordering = List<String>.from(time.map((date) => date));
                  timeordering.sort((a, b) => a.toString().compareTo(b.toString()));
                  return Container(
                    height: 657.h,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
                      child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5.sp,
                            mainAxisSpacing: 5.sp,
                          ),
                          itemCount: List<String>.from(timeordering.map((date) => date)).length,
                          itemBuilder: (BuildContext context, int index){
                            return GestureDetector(
                              onLongPress: (){
                                FirebaseFirestore.instance.collection("funcionamento").doc("horario").update({
                                  children[selectedItem]: FieldValue.arrayRemove([List<String>.from(timeordering.map((date) => date))[index].toString()])
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0.sp),
                                  border: Border.all(
                                      width: 5.w,
                                      color: Color(0xFF03A9f4)
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                      List<String>.from(timeordering.map((date) => date))[index].toString(),
                                    style: GoogleFonts.roboto(
                                      color: Colors.black,
                                      fontSize: 50.sp,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }

  _weekday() {
    List <Weekday> weekday = [
      Weekday('Dom'),
      Weekday('Seg'),
      Weekday('Ter'),
      Weekday('Qua'),
      Weekday('Qui'),
      Weekday('Sex'),
      Weekday('Sab'),
    ];

    return Container(
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: weekday.length,
          itemExtent: 56.w,
          itemBuilder: (context, int index){
            return _time(weekday,index);
          }),
    );
  }

  _time(List weekday, int index) {
    Weekday status = weekday[index];
    return GestureDetector(
      onTap: (){
        setState(() {
          selectedItem = index;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF1B1B1B),
          borderRadius: BorderRadius.circular(20.sp),
          border: Border.all(
              width:3,color: selectedItem == index? Color(0xFF03A9f4): Colors.transparent
          ),
        ),
        child: Center(
            child: Text(status.text,
              style: GoogleFonts.roboto(
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
              ),)
        ),
      ),
    );
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime:  TimeOfDay(hour: 00, minute: 00),
        confirmText: "Confirmar",
        cancelText: "Cancelar",
        initialEntryMode: TimePickerEntryMode.dial
    );

    if(timeOfDay != null) {
      setState(() {
        FirebaseFirestore.instance.collection("funcionamento")
            .doc("horario")
            .update({
          children[selectedItem]: FieldValue.arrayUnion([
            (timeOfDay.hour).toString().padLeft(2, "0") + ":" + (timeOfDay.minute).toString().padLeft(2, "0")
          ])
        });
      });
    }
  }
}

class Weekday {
  String text;
  Weekday(this.text);
}


