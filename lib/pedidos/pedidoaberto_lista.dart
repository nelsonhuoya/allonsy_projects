import 'package:allonsyapp/inicio/background.dart';
import 'package:allonsyapp/endereco/endereco.dart';
import 'package:allonsyapp/pedidos/confirmacao.dart';
import 'package:allonsyapp/pedidos/pedidoaberto_card.dart';
import 'package:allonsyapp/utils/nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:rxdart/rxdart.dart';

class PedidoabertoPage extends StatefulWidget {

  @override
  State<PedidoabertoPage> createState() => _PedidoabertoPageState();
}

class _PedidoabertoPageState extends State<PedidoabertoPage> {

  bool retirada = false;

  final email = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
      backgroundColor: Color(0xF7131313),
      appBar: AppBar(
        toolbarHeight: 60.h,
        backgroundColor: Color(0xFF1B1B1B),
        leading: Padding(
          padding: EdgeInsets.all(8.0.sp),
          child: GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 32.sp,
            ),
          ),
        ),
        centerTitle: true,
        title: Text ("Seu Pedido",
          style: GoogleFonts.dancingScript(
            fontSize: 40.0.sp,
            color: Colors.white,
            fontWeight: FontWeight.bold
          ),),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: Center(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("pedidosemaberto").snapshots(),
                  builder: (BuildContext context,snapshot){
                  return GestureDetector(
                    onTap: (){
                      FirebaseFirestore.instance.collection("pedidosemaberto").
                      doc(email).collection("pedidosemaberto").get().then((value) {
                        for (var data in value.docs){
                          FirebaseFirestore.instance.collection("pedidosemaberto").doc(email).
                        collection("pedidosemaberto").doc(data.id).delete();
                        }
                      });
                      push(context, BackGroundPage(), replace: true);
                    },
                    child: Text(
                      "Limpar",
                      style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 20.sp
                      ),
                    ),
                  );
                  }
              ),
            ),
          )
        ],
      ),
    );
  }

  _body(){
    return Padding(
      padding: EdgeInsets.only(left: 10.w,right: 10.w),
      child: StreamBuilder<List<QuerySnapshot>>(
        stream: CombineLatestStream.list([FirebaseFirestore.instance.collection("pedidosemaberto").doc(email)
            .collection("pedidosemaberto").snapshots(),
        FirebaseFirestore.instance.collection("funcionamento").snapshots()]),
        builder: (BuildContext context, AsyncSnapshot<List<QuerySnapshot>> snapshot) {
         if(snapshot.hasError){
           return Center(
             child: Text(
               "Não foi possível carregar os pratos selecionados",
               style: TextStyle(
                   color: Colors.red,
                   fontSize: 22.sp
               ),
             ),
           );
         }
         if(!snapshot.hasData){
           return Text(
               ""
           );
         }
         var ds = snapshot.data![0].docs;
         double sum = 0.00;
         for(int i = 0; i<ds.length;i++)
           sum+= (ds[i]["total"]);
         return SingleChildScrollView(
           child: Column(
             children: [
               ConstrainedBox(
                   constraints: BoxConstraints(
                       minHeight: 100.h,
                       maxHeight: 565.h
                   ),
                 child: Padding(
                   padding: EdgeInsets.only(top: 5.h),
                   child: ListView.builder(
                       shrinkWrap: true,
                       scrollDirection: Axis.vertical,
                       itemCount: snapshot.data![0].docs.length,
                       itemBuilder: (BuildContext context, int index){
                         return Container(
                           child: PedidoabertoCard(
                             snapshot.data![0].docs.elementAt(index)["url"],
                             snapshot.data![0].docs.elementAt(index)["nome"],
                             snapshot.data![0].docs.elementAt(index)["preco"],
                             snapshot.data![0].docs.elementAt(index)["qtd"],
                             snapshot.data![0].docs[index].id
                           ),
                         );
                       }
                   ),
                 ),
               ),
               Container(
                 padding: EdgeInsets.only(top:10.h),
                 child: Column(
                   children: [
                     Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Padding(
                           padding: EdgeInsets.only(top: 5.h),
                           child: Container(
                             alignment: Alignment.centerLeft,
                             child: snapshot.data![1].docs.elementAt(2)["reservas"] == true? FlutterSwitch(
                               value: retirada,
                               activeColor: Color(0xFF03A9f4),
                               inactiveColor: Colors.white,
                               toggleColor: Colors.white,
                               valueFontSize: 16.sp,
                               toggleSize: 20.sp,
                               borderRadius: 30.sp,
                               activeText: "Retirada",
                               inactiveText: "Entrega",
                               inactiveToggleColor: Color(0xFF03A9f4),
                               activeTextColor: Colors.white,
                               inactiveSwitchBorder: Border.all(
                                   color: Color(0xFF03A9f4),
                                   width: 3.sp
                               ),
                               inactiveTextColor: Color(0xFF03A9f4),
                               width: 100.sp,
                               height: 40.sp,
                               showOnOff: true,
                               onToggle: (val) {
                                 setState(() {
                                   retirada = val;
                                 });
                               },
                             ) : Container(width: 100.w,height: 40.h),
                           ),
                         ),
                         Container(
                           alignment: Alignment.centerRight,
                           child: GestureDetector(
                             onTap: (){
                               push(context, BackGroundPage());
                             },
                             child: Text(
                               "Incluir mais itens",
                               style: GoogleFonts.roboto(
                                   fontSize: 22.sp,
                                   color: Color(0xFF03A9f4)
                               ),
                             ),
                           ),
                           height: 30.h,
                         ),
                       ],
                     ),
                     SizedBox(
                       height: 10.h,
                     ),
                     Container(
                       padding: EdgeInsets.only(top:5.h),
                       child: Row(
                         children: [
                           Flexible(
                             flex: 4,
                             child: Container(
                               child: Column(
                                 mainAxisAlignment: MainAxisAlignment.end,
                                 children: [
                                   Container(
                                     child: Align(
                                       alignment: Alignment.centerLeft,
                                       child: Text(
                                         "Total:",
                                         style: GoogleFonts.roboto(
                                             fontSize: 24.sp,
                                             fontWeight: FontWeight.bold,
                                             color: Colors.white
                                         ),
                                       ),
                                     ),
                                   ),
                                   Container(
                                     child: Align(
                                       alignment: Alignment.centerLeft,
                                       child: Text(
                                         "R\$"+sum.toStringAsFixed(2),
                                         style: GoogleFonts.roboto(
                                             fontSize: 24.sp,
                                             color: Colors.white
                                         ),
                                       ),
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                           ),
                           Flexible(
                             flex: 9,
                             child: Container(
                               child: Align(
                                 alignment: Alignment.topCenter,
                                 child: StreamBuilder<QuerySnapshot>(
                                   stream: FirebaseFirestore.instance.collection("users").doc(email)
                                   .collection("endereços").snapshots(),
                                   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                                     if(!snapshot.hasData){
                                       Text("");
                                     }
                                     return GestureDetector(
                                       onTap: () async {
                                         if (await InternetConnectionChecker().hasConnection == false){
                                           showSimpleNotification(
                                               Text(
                                                 "Sem Internet",
                                                 style: TextStyle(color: Colors.white, fontSize: 20.sp),
                                               ),
                                               background: Colors.red
                                           );
                                         } else {
                                           FirebaseFirestore.instance.collection("pedidosemaberto").doc(email).set({
                                             "retirada": retirada,
                                           });
                                           if(snapshot.data!.docs.length>0){
                                             push(context, ConfirmacaoPage(retirada: retirada));
                                           } else {
                                             push(context, EnderecoPage(lastroute: "pedidos",bairro: '', numero: '', CEP: '', cidade: '', rua: '', complemento: '',atualizacao: false, id: '',));
                                           }
                                         }
                                       },
                                       child: Container(
                                         width: 270.w,
                                         height: 65.h,
                                         decoration: BoxDecoration(
                                           borderRadius: BorderRadius.circular(10.sp),
                                           color: Color(0xFF03A9f4),
                                         ),
                                         child: Align(
                                           alignment: Alignment.center,
                                           child: Text(
                                             "Prosseguir",
                                             style: GoogleFonts.roboto(
                                                 fontSize: 28.sp,
                                                 color: Colors.white,
                                                 fontWeight: FontWeight.w400
                                             ),
                                           ),
                                         ),
                                       ),
                                     );
                                   },
                                 )
                               ),
                             ),
                           ),
                         ],
                       ),
                     ),
                   ],
                 ),
               ),
             ],
           ),
         );
        }
      ),
    );
  }
}
