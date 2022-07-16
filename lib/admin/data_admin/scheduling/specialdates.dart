
import 'package:allonsyapp/admin/data_admin/scheduling/scheduling_admin.dart';
import 'package:allonsyapp/utils/nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class SpecialDatesPage extends StatefulWidget {
  const SpecialDatesPage({Key? key}) : super(key: key);

  @override
  State<SpecialDatesPage> createState() => _SpecialDatesPageState();
}

class _SpecialDatesPageState extends State<SpecialDatesPage> {
  var lista = [];


  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      lista = args.value;
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
            push(context, SchedulingAdminPage());
          },
        ),
        centerTitle: true,
        title: Text ("Folgas",
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
          var specialdates = snapshot.data!.docs.elementAt(3)["specialdates"];
          List<DateTime> listSpecialDates = List<DateTime>.from(specialdates.map((date) => date.toDate()));
          return SfDateRangePicker(
            showActionButtons: true,
            onSubmit: (Object){
              setState(() {
                FirebaseFirestore.instance.collection("funcionamento").doc("specialdates").set({
                  "specialdates": lista,
                });
                FirebaseFirestore.instance.collection("funcionamento").doc("data").update({
                  "data": FieldValue.arrayRemove(lista)
                });
                showDialog(context: context, builder: (context){
                  return AlertDialog(
                    content: Text("Folgas Atualizadas",
                    textAlign: TextAlign.center,),
                  );
                });
              });
            },
            onCancel: (){
              Navigator.pop(context);
            },
            backgroundColor: Colors.white,
            onSelectionChanged: _onSelectionChanged,
            headerHeight: 60.h,
            headerStyle: DateRangePickerHeaderStyle(
                textAlign: TextAlign.start,
                backgroundColor: Colors.green,
                textStyle: GoogleFonts.roboto(
                    fontSize: 28.sp,
                    fontStyle: FontStyle.normal,
                    color: Colors.black,
                    fontWeight: FontWeight.w400)),
            monthFormat: "LLLL",
            selectionColor: Colors.green,
            enablePastDates: false,
            monthCellStyle: DateRangePickerMonthCellStyle(
              leadingDatesDecoration: BoxDecoration(
                  color: Colors.green,
                  border: Border.all(color: const Color(0xFF2B732F), width: 1),
                  shape: BoxShape.circle),
              leadingDatesTextStyle: const TextStyle(color: Colors.white),
            ),
            monthViewSettings: DateRangePickerMonthViewSettings(
                viewHeaderHeight: 50.h,
            ),
            selectionMode: DateRangePickerSelectionMode.multiple,
            initialSelectedDates: listSpecialDates,
          );
        });
  }
}
