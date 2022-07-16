import 'package:allonsyapp/admin/data_admin/communication_admin.dart';
import 'package:allonsyapp/admin/data_admin/scheduling/scheduling_admin.dart';
import 'package:allonsyapp/admin/data_admin/financial_admin.dart';
import 'package:allonsyapp/admin/data_admin/security_admin.dart';
import 'package:allonsyapp/admin/data_admin/sobrenos_admin.dart';
import 'package:allonsyapp/firebase/firebase_service.dart';
import 'package:allonsyapp/inicio/loginpage.dart';
import 'package:allonsyapp/utils/nav.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DataPageAdmin extends StatefulWidget {

  @override
  State<DataPageAdmin> createState() => _DataPageAdminState();
}

class _DataPageAdminState extends State<DataPageAdmin> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xF7131313),
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
      ),
      body: _body(),
    );
  }

  _body() {
    return SafeArea(
      child: ListView(
          primary: false,
          padding: EdgeInsets.only(right: 15.w, left: 15.w, top: 12.h),
          children: [
            _AdminCard("https://media.istockphoto.com/photos/business-consept-image-financial-graphs-picture-id1197543861?k=20&m=1197543861&s=170667a&w=0&h=XTOsN9tu2zjsDE6LNo0qWreLsGW7io8WPYG45KiFmHc=", "Financeiro", FinancialAdminPage()),
            _AdminCard("https://d2fl3xywvvllvq.cloudfront.net/wp-content/uploads/2016/05/projectschedulemanagement.jpg", "Funcionamento", SchedulingAdminPage()),
            _AdminCard("https://t4.ftcdn.net/jpg/03/07/29/29/360_F_307292936_jzpIK9OgMh5UGb1pltYAhcqc35w3gzNG.jpg", "Comunicação", CommunicationAdminPage()),
            _AdminCard("https://media.istockphoto.com/photos/cybersecurity-digital-technology-security-picture-id1271866338?b=1&k=20&m=1271866338&s=170667a&w=0&h=qMP0iV5MRKoddE1l-n864RglYT8ywTc4K5QedrdWXxc=", "Segurança", SecurityAdminPage()),
            _AdminCard("https://www.salvadordabahia.com/wp-content/uploads/2019/08/restaurante-pedra-do-mar--rio-vermelho--salvador-bahia--foto-tarso-figueira-assessoria-4-587x434.jpg", "Sobre Nós", SobrenosAdminPage())
          ],
      ),
    );
  }

  _AdminCard(String image, String text, page) {
    return Padding(
      padding: EdgeInsets.only(bottom: 25.h),
      child: GestureDetector(
        onTap: (){
          push(context, page);
        },
        child: Container(
          height: 185.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.sp),
              image: DecorationImage(
                colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.4),BlendMode.darken),
                image: NetworkImage(image),fit: BoxFit.cover,
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.black,
                    blurRadius: 4,
                    offset: Offset(5,10)
                )
              ]
          ),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 32.sp
              ),
            ),
          ),
        ),
      ),
    );
  }
}

