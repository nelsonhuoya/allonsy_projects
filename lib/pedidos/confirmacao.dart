import 'package:allonsyapp/inicio/background.dart';
import 'package:allonsyapp/endereco/endereco_lista.dart';
import 'package:allonsyapp/utils/animacao.dart';
import 'package:allonsyapp/pedidos/pedidoaberto_lista.dart';
import 'package:allonsyapp/pedidos/resumopedido.dart';
import 'package:allonsyapp/utils/nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';

class ConfirmacaoPage extends StatefulWidget {
  bool? retirada;

  ConfirmacaoPage({required this.retirada});

  @override
  State<ConfirmacaoPage> createState() => _ConfirmacaoPageState();
}

class _ConfirmacaoPageState extends State<ConfirmacaoPage> {
  final user = FirebaseAuth.instance.currentUser;

  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 60.h,
        backgroundColor: Color(0xFF1B1B1B),
        centerTitle: true,
        title: Text("Seu pedido",
          style: GoogleFonts.dancingScript(
              fontSize: 40.0.sp,
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          iconSize: 32.sp,
          color: Colors.white,
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          Center(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection("pedidosemaberto")
                    .snapshots(),
                builder: (BuildContext context, snapshot) {
                  return GestureDetector(
                    onTap: () {
                      FirebaseFirestore.instance.collection("pedidosemaberto").
                      doc(user!.email).collection("pedidosemaberto")
                          .get()
                          .then((value) {
                        for (var data in value.docs) {
                          FirebaseFirestore.instance.collection(
                              "pedidosemaberto").doc(user!.email).
                          collection("pedidosemaberto").doc(data.id).delete();
                        }
                      });
                      push(context, BackGroundPage(), replace: true);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 10.0.w),
                      child: Text(
                        "Cancelar",
                        style: GoogleFonts.roboto(
                            color: Colors.white,
                            fontSize: 20.sp
                        ),
                      ),
                    ),
                  );
                }
            ),
          )
        ],
      ),
      body: _body(),
    );
  }

  _body() {
    return StreamBuilder<List<QuerySnapshot>> (
        stream: CombineLatestStream.list([FirebaseFirestore.instance.collection("pedidosemaberto").doc(user!.email).collection("pedidosemaberto").snapshots(),
          FirebaseFirestore.instance.collection("funcionamento").snapshots(),
          FirebaseFirestore.instance.collection("qtdpedidos").snapshots(),
        ]),
        builder: (BuildContext context, AsyncSnapshot <List<QuerySnapshot>> snapshot){
          if(!snapshot.hasData){
            return Text("");
          }
          var ds = snapshot.data![0].docs;
          double total = 0.00;
          for(int i = 0; i<ds.length;i++)
            total+= (ds[i]["total"]);
          double taxaentrega =  0.00;
          Future<void> initPaymentSheet(context, {required String email, required int amount}) async {
            try {
              Stripe.publishableKey =
              "pk_test_51L9b1HHXlqIbO8KBl7yQVOvRAUEI3TQsh5LCRZvrWG69CnyEgW5c0GezkpmDsJ9RLquEDYQXg8apPLLXssuwyOd100MG7P4aPE";
              await Stripe.instance.applySettings();
              // 1. create payment intent on the server
              final response = await http.post(
                  Uri.parse(
                      'https://us-central1-allons-y-76224.cloudfunctions.net/stripePaymentIntentRequest'),
                  body: {
                    'email': email,
                    'amount': amount.toString(),
                  });

              final jsonResponse = jsonDecode(response.body);
              log(jsonResponse.toString());

              //2. initialize the payment sheet
              await Stripe.instance.initPaymentSheet(
                paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: jsonResponse['paymentIntent'],
                  merchantDisplayName: 'Restaurante Allons-y',
                  customerId: jsonResponse['customer'],
                  customerEphemeralKeySecret: jsonResponse['ephemeralKey'],
                  style: ThemeMode.light,
                  testEnv: true,
                  merchantCountryCode: 'BR',
                ),
              );

              await Stripe.instance.presentPaymentSheet();
              var CEP = await FirebaseFirestore.instance.collection("users").doc(user!.email).collection("endereços").where("ativo", isEqualTo: true).get().then((value) {
                return value.docs[0].data()["CEP"];
              });
              var bairro = await FirebaseFirestore.instance.collection("users").doc(user!.email).collection("endereços").where("ativo", isEqualTo: true).get().then((value) {
                return value.docs[0].data()["bairro"];
              });
              var cidade = await FirebaseFirestore.instance.collection("users").doc(user!.email).collection("endereços").where("ativo", isEqualTo: true).get().then((value) {
                return value.docs[0].data()["cidade"];
              });
              var complemento = await FirebaseFirestore.instance.collection("users").doc(user!.email).collection("endereços").where("ativo", isEqualTo: true).get().then((value) {
                return value.docs[0].data()["complemento"];
              });
              var n = await FirebaseFirestore.instance.collection("users").doc(user!.email).collection("endereços").where("ativo", isEqualTo: true).get().then((value) {
                return value.docs[0].data()["numero"];
              });
              var rua = await FirebaseFirestore.instance.collection("users").doc(user!.email).collection("endereços").where("ativo", isEqualTo: true).get().then((value) {
                return value.docs[0].data()["rua"];
              });
              FirebaseFirestore.instance.collection("pedidos").doc((snapshot.data![2].docs.elementAt(0)["numero"]+1).toString()).set({
                'data': Timestamp.now(),
                'retirada': widget.retirada,
                'numero': (snapshot.data![2].docs.elementAt(0)["numero"]+1).toString(),
                'primeiroprato': snapshot.data![0].docs.elementAt(0)["nome"],
                'qtditens': snapshot.data![0].docs.length,
                'qtdprimeiroprato': snapshot.data![0].docs.elementAt(0)["qtd"],
                'situacao': 'Recebido',
                'horario do envio': '',
                'timer': 30,
                'endereco': widget.retirada == false? rua +" nº "+n+ ", "+bairro
                    + ", "+cidade+ ", "+CEP : "Rua Rui Figueiredo Borges n55, Ap501, Macáe, 27920-470 ",
                'complemento': widget.retirada == false? complemento : "Restaurante Allons-y, em frente ao McDonalds ",
                'email': user!.email,
                'total': total
              });
              FirebaseFirestore.instance.collection("pedidosemaberto").
              doc(user?.email).collection("pedidosemaberto").get().then((value) {
                for (var data in value.docs){
                  FirebaseFirestore.instance.collection("pedidos").doc((snapshot.data![2].docs.elementAt(0)["numero"]+1).toString()).collection("itens").doc().set({
                    'nome':data.data()["nome"],
                    'qtd':data.data()["qtd"],
                    'preco':data.data()["preco"],
                    'total':data.data()["total"],
                    'observacao': data.data()["observacao"],
                    'url': data.data()["url"],
                    'categoria': data.data()['categoria'],
                  });
                }
              });
              FirebaseFirestore.instance.collection("pedidosemaberto").
              doc(user?.email).collection("pedidosemaberto").get().then((value) {
                for (var data in value.docs){
                  FirebaseFirestore.instance.collection("pedidosemaberto").doc(user?.email).
                  collection("pedidosemaberto").doc(data.id).delete();
                }
              });
              FirebaseFirestore.instance.collection("qtdpedidos").doc("qtdpedidos").set({
                "numero": snapshot.data![2].docs.elementAt(0)["numero"]+1
              });
              push(context, AnimacaoPage(objetivo:"pedidos"), replace: true);
            } catch (e) {
              if (e is StripeException) {
                if(e.error.localizedMessage == "The payment flow has been canceled"){
                  setState(() {
                    _isSigningIn = false;
                  });
                  return null;
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error from Stripe: ${e.error.localizedMessage}'),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
                );
              }
            }
          }
          return Padding(
            padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 5.h, bottom: 8.h),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 464.h
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        Container(
                          child: Container(
                            child: Padding(
                              padding: EdgeInsets.only(left: 8.w, top: 15.h, bottom: 10.h),
                              child: Column(
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Icon(
                                          Icons.description_outlined,
                                          color: Color(0xFF03A9f4),
                                          size: 28.sp,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                              "Resumo do Pedido:",
                                          style: GoogleFonts.roboto(
                                              color: Colors.black,
                                              fontSize: 22.sp,
                                              fontWeight: FontWeight.w600
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 65.w,
                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          push(context, PedidoabertoPage(),replace: true);
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(right: 8.w),
                                          alignment: Alignment.bottomRight,
                                          child: Text(
                                            "Alterar",
                                            style: GoogleFonts.roboto(
                                              fontSize: 22.sp,
                                              color: Color(0xFF03A9f4),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 15.h, left:6.w),
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemCount: snapshot.data![0].docs.length,
                                        itemBuilder: (BuildContext context, int index){
                                          return ResumoCard(
                                              snapshot.data![0].docs.elementAt(index)['qtd'],
                                              snapshot.data![0].docs.elementAt(index)['nome'],
                                              snapshot.data![0].docs.elementAt(index)['total'],
                                              snapshot.data![0].docs.elementAt(index)['observacao']);
                                        }
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 2.sp,
                          height: 1.h,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        Container(
                          child: Container(
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 8.w, top: 10.h),
                                      child: Container(
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Icon(
                                                    Icons.where_to_vote_outlined,
                                                    color: Color(0xFF03A9f4),
                                                    size: 28.sp,
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(left: 10.w),
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    widget.retirada == false
                                                        ? "Endereço de Entrega:"
                                                        : "Retirar Pedido Em:",
                                                    style: GoogleFonts.roboto(
                                                        color: Colors.black,
                                                        fontSize: 22.sp,
                                                        fontWeight: FontWeight.w600
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            StreamBuilder<QuerySnapshot>(
                                                stream: FirebaseFirestore.instance.collection("users").doc(user!.email).collection("endereços")
                                                    .where("ativo", isEqualTo:true).snapshots(),
                                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                                                  if(!snapshot.hasData){
                                                    return Text("");
                                                  }
                                                  if(snapshot.data!.docs.isEmpty && widget.retirada == false){
                                                    return Container(
                                                      child: Center(
                                                        child: Text(""),
                                                      ),
                                                    );

                                                  }
                                                  return Padding(
                                                    padding: EdgeInsets.only(left: 40.w, right: 90.h),
                                                    child: Container(
                                                      alignment: Alignment.topLeft,
                                                      child: Padding(
                                                        padding: EdgeInsets.only(top: 10.h),
                                                        child: Text(widget.retirada == false
                                                            ?
                                                        snapshot.data!.docs[0]["rua"]+" nº "+snapshot.data!.docs[0]["numero"] + ", "+snapshot.data!.docs[0]["bairro"]
                                                            + ", "+snapshot.data!.docs[0]["cidade"]+ ", "+snapshot.data!.docs[0]["CEP"]
                                                            :
                                                        "Rua Rui Figueiredo Borges n55, Ap501, Macáe, 27920-470 ",
                                                          style: GoogleFonts.roboto(
                                                            color: Colors.black,
                                                            fontSize: 18.sp,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                            StreamBuilder<QuerySnapshot>(
                                                stream: FirebaseFirestore.instance.collection("users").doc(user!.email).collection("endereços")
                                                    .where("ativo", isEqualTo:true).snapshots(),
                                                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                                                  if(!snapshot.hasData){
                                                    return Text("");
                                                  }
                                                  if(snapshot.data!.docs.isEmpty && widget.retirada == false){
                                                    return Container(
                                                      child: Center(
                                                        child: Text(""),
                                                      ),
                                                    );
                                                  }
                                                  return Padding(
                                                    padding: EdgeInsets.only(left: 40.w, right: 100.w,bottom: 10.h),
                                                    child: Padding(
                                                      padding: EdgeInsets.only(top: 10.h),
                                                      child: Align(
                                                        alignment: Alignment.bottomLeft,
                                                        child: Text(widget.retirada == false ?
                                                        snapshot.data!.docs[0]["complemento"]:
                                                        "Restaurante Allons-y, em frente ao McDonalds ",
                                                          textAlign: TextAlign.start,
                                                          style: GoogleFonts.roboto(
                                                            color: Colors.grey.shade900.withOpacity(0.7),
                                                            fontSize: 16.sp,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          ],
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 8.w),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: snapshot.data![1].docs.elementAt(2)["reservas"] == true ? Container(
                                      width: 100.w,
                                      height: 40.h,
                                      child: FlutterSwitch(
                                        value: widget.retirada == null? false: widget.retirada!,
                                        activeColor: Color(0xFF03A9f4),
                                        inactiveColor: Colors.white.withOpacity(
                                            0.9),
                                        toggleColor: Colors.white.withOpacity(0.9),
                                        valueFontSize: 16.sp,
                                        toggleSize: 20.sp,
                                        activeText: "Retirada",
                                        inactiveText: "Entrega",
                                        borderRadius: 30.sp,
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
                                            widget.retirada = val;
                                          });
                                        },
                                      ),
                                    ) : Container(width: 100.w,height: 40.h),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 8.h, right: 8.w),
                                      child: GestureDetector(
                                        onTap: (){
                                          push(context, EnderecoListaPage(lastroute: "pedidos"));
                                        },
                                        child: Text(
                                          "Alterar",
                                          style: GoogleFonts.roboto(
                                            fontSize: 22.sp,
                                            color: Color(0xFF03A9f4),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Divider(
                          thickness: 2.sp,
                          height: 1.h,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: 8.0.w, right: 8.w, top: 13.h, bottom: 10.h),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          child: Icon(
                                            Icons.timer_outlined,
                                            color: Color(0xFF03A9f4),
                                            size: 28.sp,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.only(left: 10.w),
                                          child: Container(
                                            child: Text(
                                              "Tempo Estimado:",
                                              style: GoogleFonts.roboto(
                                                  color: Colors.black,
                                                  fontSize: 22.sp,
                                                  fontWeight: FontWeight.w600
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 42.w, right: 100.w),
                                      child: Container(
                                        height: 35.h,
                                        alignment: Alignment.topLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 10.h),
                                          child: Text(
                                            "40-60 minutos",
                                            style: GoogleFonts.roboto(
                                              color: Colors.black,
                                              fontSize: 18.sp,
                                            ),
                                          ),
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
                  ),
                  Divider(
                    thickness: 2.sp,
                    height: 1.h,
                    color: Color(0xFF03A9f4).withOpacity(0.5),
                  ),
                  Container(
                    height: 90.h,
                    child: Padding(
                      padding: EdgeInsets.only(top: 5.h, right: 8.w, left: 8.w),
                      child: Container(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Subtotal",
                                  style: GoogleFonts.roboto(
                                      fontSize: 25.sp,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text(
                                  "R\$"+total.toStringAsFixed(2),
                                  style: GoogleFonts.roboto(
                                      fontSize: 25.sp,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Taxa de Entrega",
                                  style: GoogleFonts.roboto(
                                      fontSize: 25.sp,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text(
                                  "R\$"+taxaentrega.toStringAsFixed(2),
                                  style: GoogleFonts.roboto(
                                      fontSize: 25.sp,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 2.sp,
                    height: 1.h,
                    color: Color(0xFF03A9f4).withOpacity(0.5),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 8.0.w, left: 8.0.w, top: 5.h),
                    child: Container(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total",
                                style: GoogleFonts.roboto(
                                    fontSize: 40.sp,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(
                                "R\$"+(total+taxaentrega).toStringAsFixed(2),
                                style: GoogleFonts.roboto(
                                    fontSize: 40.sp,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          GestureDetector(
                            onTap: () async {
                              if(await InternetConnectionChecker().hasConnection == false){
                                showSimpleNotification(
                                    Text(
                                      "Sem Internet",
                                      style: TextStyle(color: Colors.white, fontSize: 20.sp),
                                    ),
                                    background: Colors.red
                                );
                              } else {
                                try {
                                  var cidade = await FirebaseFirestore.instance
                                      .collection("users").doc(user!.email)
                                      .collection("endereços").where(
                                      "ativo", isEqualTo: true).get()
                                      .then((value) {
                                    return value.docs[0].data()["cidade"];
                                  });
                                  setState(() {
                                    _isSigningIn = true;
                                  });
                                  await initPaymentSheet(
                                      context, email: user!.email.toString(),
                                      amount: ((total + taxaentrega) * 100)
                                          .toInt());
                                } catch (error) {
                                  final snackBar = SnackBar(
                                    padding: EdgeInsets.only(
                                        left: 40.w, right: 40.w),
                                    content: Text(
                                      "Informe os Dados de Endereço do Pedido",
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.roboto(
                                          color: Colors.black,
                                          fontSize: 25.sp,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    backgroundColor: Colors.red.shade700,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      snackBar);
                                }
                              }},
                            child: Container(
                              height: 70.h,
                              decoration: BoxDecoration(
                                  color: Color(0xFF03A9f4),
                                  borderRadius: BorderRadius.circular(10.sp)
                              ),
                              child: Center(
                                child: _isSigningIn == false? Text(
                                  "Fazer Pagamento",
                                  style: GoogleFonts.roboto(
                                      fontSize: 32.sp,
                                      color: Colors.white
                                  ),
                                ) : CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

