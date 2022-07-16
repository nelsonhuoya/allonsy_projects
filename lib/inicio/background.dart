import 'dart:typed_data';
import 'package:allonsyapp/admin/homepage_admin.dart';
import 'package:allonsyapp/inicio/homepage.dart';
import 'package:allonsyapp/drawer/drawer_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class BackGroundPage extends StatefulWidget {

  final String? index;

  BackGroundPage({this.index});

  @override
  _BackGroundPageState createState() => _BackGroundPageState();
}

class _BackGroundPageState extends State<BackGroundPage> {

  final email = FirebaseAuth.instance.currentUser!.email;

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  @override
  void initState() {
    super.initState();
    registerNotification();
    configureLocalNotification();
    FirebaseMessaging.instance.subscribeToTopic('users');
  }

  void registerNotification(){
    firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if(message.notification != null){
        //show notification
        showNotification(message.notification!);
      }
      return;
    });

    firebaseMessaging.getToken().then((token) {
      if(token != null){
        FirebaseFirestore.instance.collection("users").doc(email).set({
          "token":token,
        });
        print("Token:" + token);
      }
    }).catchError((error){
      Fluttertoast.showToast(msg: error.message.toString());
    });
  }

  void configureLocalNotification(){
    AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings("mipmap/ic_launcher");
    IOSInitializationSettings iosInitializationSettings = IOSInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(
        android: androidInitializationSettings,
        iOS: iosInitializationSettings,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<Uint8List> _getByteArrayFromUrl(String url) async {
    final http.Response response = await http.get(Uri.parse(url));
    return response.bodyBytes;
  }

  void showNotification(RemoteNotification remoteNotification) async {
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        "com.example.allonsyapp",
        "Allons-y",
      playSound: true,
      priority: Priority.high,
      visibility: NotificationVisibility.public,
      enableVibration: true,
      styleInformation: remoteNotification.android?.imageUrl == null? BigTextStyleInformation(""): remoteNotification.android?.imageUrl == ""?
      BigTextStyleInformation(""): BigPictureStyleInformation(ByteArrayAndroidBitmap(
          await _getByteArrayFromUrl(remoteNotification.android!.imageUrl.toString()))),
      importance: Importance.max,
    );

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS:iosNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
        0,
        remoteNotification.title,
        remoteNotification.body,
        notificationDetails,
        payload: null
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xF7131313),
      body: _body(),
    );
  }

  _body() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("admins").where("email", isEqualTo: email).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
        if(!snapshot.hasData){
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if(snapshot.data!.docs.length == 1) {
          return HomePageAdmin(0);
        }
        return Stack(
          children: [
            DrawerList(),
            HomePage(index: widget.index)
          ],
        );
      },
    );
  }
}
