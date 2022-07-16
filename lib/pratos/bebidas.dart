import 'package:allonsyapp/pratos/bebidas_lista.dart';
import 'package:allonsyapp/utils/nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:rxdart/rxdart.dart';

class BebidasPage extends StatefulWidget {
  const BebidasPage({Key? key}) : super(key: key);

  @override
  State<BebidasPage> createState() => _BebidasPageState();
}

class _BebidasPageState extends State<BebidasPage> {
  bool hasInternet = true;

  @override
  void initState(){
    if (mounted) {
      super.initState();
      InternetConnectionChecker().onStatusChange.listen((status) {
        final hasInternet = status == InternetConnectionStatus.connected;
        setState(() => this.hasInternet = hasInternet);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<QuerySnapshot>>(
      stream: CombineLatestStream.list([
        FirebaseFirestore.instance.collection("pratos").where("categoria", isEqualTo: "bebidas").where("subcategoria", isEqualTo: "Cerveja")
            .where("ativo", isEqualTo: true).snapshots(),
        FirebaseFirestore.instance.collection("pratos").where("categoria", isEqualTo: "bebidas").where("subcategoria", isEqualTo: "Refrigerante")
            .where("ativo", isEqualTo: true).snapshots(),
        FirebaseFirestore.instance.collection("pratos").where("categoria", isEqualTo: "bebidas").where("subcategoria", isEqualTo: "Suco")
            .where("ativo", isEqualTo: true).snapshots(),
        FirebaseFirestore.instance.collection("pratos").where("categoria", isEqualTo: "bebidas").where("subcategoria", isEqualTo: "Vinho")
            .where("ativo", isEqualTo: true).snapshots(),
        FirebaseFirestore.instance.collection("pratos").where("categoria", isEqualTo: "bebidas").where("subcategoria", isEqualTo: "Outro")
            .where("ativo", isEqualTo: true).snapshots(),
      ]),
      builder: (BuildContext context, AsyncSnapshot<List<QuerySnapshot>> snapshot) {
        if(snapshot.hasError) {
          return Center(
            child: Text(
              "Não foi possível carregar o menu",
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
        _Card(img, subcategoria) {
          return Padding(
            padding: EdgeInsets.only(bottom: 15.h, left: 8.w, right: 8.w),
            child: GestureDetector(
              onTap: (){
                push(context, BebidasListaPage(subcategoria));
              },
              child: Container(
                height: 200.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.sp),
                    image: DecorationImage(
                        colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3),BlendMode.darken),
                        image: NetworkImage(img),fit: BoxFit.cover
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black87,
                          blurRadius: 4,
                          offset: Offset(5,10)
                      )
                    ]
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0.w),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      subcategoria == "Cerveja"? "Cervejas": subcategoria == "Refrigerante"? "Refrigerantes" : subcategoria == "Suco"? "Sucos": subcategoria == "Vinho"? "Vinhos" :"Outros",
                      style:  GoogleFonts.dancingScript(
                          fontSize: 38.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
        return hasInternet == true? ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: 5,
            itemBuilder: (context, int index){
             return snapshot.data![index].docs.length>0? _Card(snapshot.data![index].docs.elementAt(0)['url'], snapshot.data![index].docs.elementAt(0)['subcategoria']): Container();
            }
        ):Center(
          child: Text(
            "Não foi possível carregar o menu. Verifique sua conexão",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.red,
                fontSize: 22.sp
            ),
          ),
        );
      },
    );
  }
}
