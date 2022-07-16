import 'dart:async';

import 'package:allonsyapp/admin/chat_admin/chat_admin.dart';
import 'package:allonsyapp/admin/data_admin/data_admin.dart';
import 'package:allonsyapp/admin/menu_admin/menu_admin.dart';
import 'package:allonsyapp/admin/pedidos_admin/pedidos_admin.dart';
import 'package:allonsyapp/admin/reservas_admin/reservas_admin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:passcode_screen/circle.dart';
import 'package:passcode_screen/keyboard.dart';
import 'package:passcode_screen/passcode_screen.dart';

class HomePageAdmin extends StatefulWidget {

  var selectedItem;

  HomePageAdmin(this.selectedItem);

  @override
  _HomePageAdminState createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();
  bool isAuthenticated = false;

  List children = [
    PedidosAdmin(),
    ReservasAdmin(),
    ChatAdmin(),
    MenuAdmin(),
    DataPageAdmin()
  ];

  String storedPasscode = '';

  var page = 0;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.subscribeToTopic('users');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("senha").snapshots(),
        builder: (BuildContext context, AsyncSnapshot <QuerySnapshot> snapshot){
          if(snapshot.hasError){

          } if (snapshot.hasData){

          } return Scaffold(
            backgroundColor: Color(0xF7131313),
            body: _body(),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Color(0xFF1B1B1B),
              selectedItemColor: Color(0xFF03A9f4),
              iconSize: 27.0.sp,
              currentIndex: widget.selectedItem,
              unselectedLabelStyle: GoogleFonts.dancingScript(fontSize: 20.0.sp,color: Color(0xFF1B1B1B)),
              selectedLabelStyle: GoogleFonts.dancingScript(fontSize: 20.0.sp,
                  fontWeight: FontWeight.w600),
              unselectedItemColor: Color(0xFF888888),
              onTap: (currentIndex) {
                if(currentIndex == 4){
                  setState(() {
                    storedPasscode = snapshot.data!.docs.elementAt(0)["senha"];
                    page = currentIndex;
                    _showLockScreen(context,
                      opaque: false,
                      circleUIConfig: CircleUIConfig(
                          borderColor: Colors.blue,
                          fillColor: Colors.blue,
                          circleSize: 30.r),
                      keyboardUIConfig: KeyboardUIConfig(
                          digitBorderWidth: 2.sp, primaryColor: Colors.blue),
                      cancelButton: Text(
                        'Voltar',
                        style: TextStyle(fontSize: 20.sp,color: Colors.white),
                        semanticsLabel: 'Voltar',
                      ),
                    );
                  });
                } else {
                  setState(() {
                    widget.selectedItem = currentIndex;
                  });
                }
              },
              items: [
                _bottomNavigationBarItem('Pedidos',Icon(Icons.shopping_bag, size:30.sp)),
                _bottomNavigationBarItem('Reservas',Icon(Icons.event_available, size:30.sp)),
                _bottomNavigationBarItem('Chat',Icon(Icons.chat,size: 30.sp)),
                _bottomNavigationBarItem('Cardápio',Icon(Icons.home,size: 30.sp)),
                _bottomNavigationBarItem('Admin',Icon(Icons.security,size: 30.sp)),
              ],
            ),
          );
        });
  }

  _bottomNavigationBarItem(String text, Icon icon) {
    return BottomNavigationBarItem(
        icon: icon,
        backgroundColor: Color(0xFF1B1B1B),
        label:text,
    );
  }

  _body() {
    return Container(
     child: children[widget.selectedItem],
    );
  }
  _showLockScreen(BuildContext context, {
    required bool opaque,
    CircleUIConfig? circleUIConfig,
    KeyboardUIConfig? keyboardUIConfig,
    required Widget cancelButton, int? page,
    }) {
      Navigator.push(
        context,
        PageRouteBuilder(
          opaque: opaque,
          pageBuilder: (context, animation, secondaryAnimation) =>
            PasscodeScreen(
                title: Text(
                  'Informe a Senha',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 28.sp),
                ),
                circleUIConfig: circleUIConfig,
                keyboardUIConfig: keyboardUIConfig,
                passwordEnteredCallback: _onPasscodeEntered,
                cancelButton: cancelButton,
                deleteButton: Text(
                  'Apagar',
                  style: TextStyle(fontSize: 20.sp,color: Colors.white),
                  semanticsLabel: 'Apagar',
                ),
                shouldTriggerVerification: _verificationNotifier.stream,
                backgroundColor: Colors.black.withOpacity(0.8),
                cancelCallback: _onPasscodeCancelled,


            ),


        )
      );
  }

   _onPasscodeEntered(String enteredPasscode) {
    bool isValid = storedPasscode == enteredPasscode;
    _verificationNotifier.add(isValid);
    if(isValid){
      setState(() {
        this.isAuthenticated = isValid;
        widget.selectedItem = page;
      });
    }
  }

   _onPasscodeCancelled() {
    setState(() {
      Navigator.maybePop(context);
    });
  }

  @override
  void dispose() {
    _verificationNotifier.close();
    super.dispose();
  }
}
