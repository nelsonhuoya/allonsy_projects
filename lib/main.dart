import 'package:allonsyapp/inicio/inicio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:overlay_support/overlay_support.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print("background message ${message.notification!.body}");
}

Future<void> main() async {
 WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp();
 FirebaseMessaging.onBackgroundMessage(_messageHandler);
 SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
.then((_) {
  runApp(new MyApp());
 });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(393,808),
      builder: (context, child) {
        return OverlaySupport.global(
          child: MaterialApp(
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('en', ''), //
              Locale('pt', 'BR'), //
            ],
            debugShowCheckedModeBanner: false,
            home: child,
          ),
        );
      },
      child: SplashScreen(
      ),
    );
  }
}
