
import 'package:allonsyapp/admin/data_admin/scheduling/specialdates.dart';
import 'package:allonsyapp/admin/data_admin/scheduling/time.dart';
import 'package:allonsyapp/admin/homepage_admin.dart';
import 'package:allonsyapp/utils/nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';


class SchedulingAdminPage extends StatefulWidget {

  @override
  State<SchedulingAdminPage> createState() => _SchedulingAdminPageState();
}

class _SchedulingAdminPageState extends State<SchedulingAdminPage> {

  bool retirada = false;

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      FirebaseFirestore.instance.collection("funcionamento").doc("data").set({
        "data": args.value,
      });
      FirebaseFirestore.instance.collection("funcionamento").doc("specialdates").update({
        "specialdates": FieldValue.arrayRemove(args.value)
      });
    });
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
            push(context, HomePageAdmin(4));
          },
        ),
        centerTitle: true,
        title: Text ("Funcionamento",
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
              child: PopupMenuButton(
                color: Colors.white,
                icon: Icon(Icons.dehaze_rounded,
                    size: 32.sp,
                    color: Colors.white),
                itemBuilder: (_)=> <PopupMenuItem<String>>[
                  PopupMenuItem(
                    child: Text(
                      "Horário",
                      style: GoogleFonts.roboto(
                          fontSize: 18.sp,
                          color: Colors.black
                      ),
                    ),
                    value: "horário",
                  ),
                  PopupMenuItem(
                    child: Text(
                      "Folgas",
                      style: GoogleFonts.roboto(
                          fontSize: 18.sp,
                          color: Colors.black),
                    ),
                    value: "folgas",
                  ),
                ],
                onSelected: (index) {
                  switch(index) {
                    case 'horário':
                      setState(() {
                        push(context, TimeAdminPage());
                      });
                      break;
                      case 'folgas':
                        setState(() {
                          push(context, SpecialDatesPage());
                        });
                        break;
                  }
                  },
              ),
          )],
      ),
      body: _body(),
    );
  }

  _body() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("funcionamento").snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
          if(snapshot.hasError) {
            return Center(
              child: Text(
                "Não foi possível carregar as datas",
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
          }
          var dates = snapshot.data!.docs.elementAt(0)["data"];
          var specialdates = snapshot.data!.docs.elementAt(3)["specialdates"];
          List<DateTime> listDates = List<DateTime>.from(dates.map((date) => date.toDate()));
          List<DateTime> listSpecialDates = List<DateTime>.from(specialdates.map((date) => date.toDate()));
          return Stack(
            children: [
              SfDateRangePicker(
                backgroundColor: Colors.white,
                onSelectionChanged: _onSelectionChanged,
                headerHeight: 60.h,
                headerStyle: DateRangePickerHeaderStyle(
                    textAlign: TextAlign.start,
                    backgroundColor: Color(0xFF03A9f4),
                    textStyle: GoogleFonts.roboto(
                        fontSize: 28.sp,
                        fontStyle: FontStyle.normal,
                        color: Colors.black,
                        fontWeight: FontWeight.w400)),
                monthFormat: "LLLL",
                enablePastDates: false,
                monthCellStyle: DateRangePickerMonthCellStyle(
                  specialDatesDecoration: BoxDecoration(
                      color: Colors.green,
                      border: Border.all(color: Color(0xFF2B732F), width: 1.w),
                      shape: BoxShape.circle),
                  specialDatesTextStyle: TextStyle(color: Colors.white),
                ),
                monthViewSettings: DateRangePickerMonthViewSettings(
                  viewHeaderHeight: 50.h,
                  specialDates: listSpecialDates
                ),
                selectionMode: DateRangePickerSelectionMode.multiple,
                initialSelectedDates: listDates,
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20.h, right: 10.w),
                    child: Container(
                      width: 100.w,
                      height: 50.h,
                      child: FlutterSwitch(
                        value: retirada,
                        activeColor: Colors.grey,
                        inactiveColor: Colors.white,
                        toggleColor: Colors.white,
                        valueFontSize: 16.sp,
                        toggleSize: 20.sp,
                        borderRadius: 30.sp,
                        activeText: "",
                        inactiveText: "Entrega",
                        inactiveToggleColor: Color(0xFF03A9f4),
                        activeTextColor: Colors.white,
                        inactiveSwitchBorder: Border.all(
                            color: Color(0xFF03A9f4),
                            width: 3.sp
                        ),
                        inactiveTextColor: Color(0xFF03A9f4),
                        width: 100.sp,
                        height: 50.sp,
                        showOnOff: true,
                        onToggle: (val) {
                          setState(() {
                            retirada = val;
                            FirebaseFirestore.instance.collection("funcionamento").doc("reservas").set({
                              "reservas": val == false? true : false
                            });
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        });
  }
}




