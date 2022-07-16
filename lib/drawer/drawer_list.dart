import 'package:allonsyapp/endereco/endereco_lista.dart';
import 'package:allonsyapp/faleconosco/faleconosco.dart';
import 'package:allonsyapp/faq/faq.dart';
import 'package:allonsyapp/firebase/firebase_service.dart';
import 'package:allonsyapp/inicio/loginpage.dart';
import 'package:allonsyapp/inicio/sobrenos.dart';
import 'package:allonsyapp/privacidade/privacidade.dart';
import 'package:allonsyapp/utils/nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawerList extends StatefulWidget {

  @override
  _DrawerListState createState() => _DrawerListState();
}

class _DrawerListState extends State<DrawerList> {
  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF03A9f4),
                  Colors.blue.shade900,
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight
              )
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.1),
          ),
          SafeArea(
            child: Container(
              padding: EdgeInsets.only(top:10.h),
              width: 230.w,
              child: Column(
                children: [
                  SizedBox(height: 30.h),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 2.w, color: Colors.white)
                    ),
                    child:  CircleAvatar(
                     backgroundImage: user!.photoURL == null? NetworkImage("https://i1.wp.com/terracoeconomico.com.br/wp-content/uploads/2019/01/default-user-image.png?ssl=1"):NetworkImage(user.photoURL!),
                      radius: 70.r,
                    ),
                  ),
                  SizedBox(height: 10.h),
                 Container(
                   width: 180.w,
                   child: Text(user.displayName == null? user.email! : user.displayName!,
                   textAlign: TextAlign.center,
                   maxLines: 1,
                   style: TextStyle(
                     fontSize: 30.sp,
                     color: Colors.white
                   ),),
                 ),
                  SizedBox(height: 30.h),
                  Container(
                      height: 400.h,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 4,
                              child: _opcoes(Icons.help_outline, "Principais Dúvidas", FaqPage())),
                          Flexible(
                            flex: 1,
                              child: Container()),
                          Flexible(
                            flex: 4,
                              child: _opcoes(Icons.where_to_vote_outlined, "Endereços", EnderecoListaPage(lastroute: "enderecos"))),
                          Flexible(
                            flex: 1,
                              child: Container()),
                          Flexible(
                            flex: 4,
                              child: _opcoes(Icons.chat, "Fale Conosco", FaleConoscoPage())),
                          Flexible(
                            flex: 1,
                              child: Container()),
                          Flexible(
                              flex: 4,
                              child: _opcoes(Icons.security, "Politica de Privacidade", PrivacidadePage())),
                          Flexible(
                              flex: 1,
                              child: Container()),
                          Flexible(
                            flex: 3,
                            child: ListTile(
                              onTap: (){
                                FirebaseService().logout();
                                push(context, LoginPage(), replace: true);},
                              leading: Icon(Icons.exit_to_app,size: 35.sp,
                                color: Colors.white),
                              title: Text("Desconectar",
                                style: TextStyle(
                                    fontSize: 22.sp,
                                    color: Colors.white
                                ),
                              ),
                            ),
                          ),
                        ],
                      ))
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  ListTile _opcoes(IconData icon, String text, page) {
    return ListTile(
      onTap: (){
        push(context,page);
      },
      leading: Icon(icon,
      size: 35.sp,
      color: Colors.white),
      title: Text(text,
      style: TextStyle(
        fontSize: 22.sp,
        color: Colors.white
      ),),
    );
  }
}
