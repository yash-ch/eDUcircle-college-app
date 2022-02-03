import 'package:duline/MainLayout.dart';
import 'package:duline/utils/appState.dart';
import 'package:duline/utils/style.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  AppState().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: Style.myDarkTheme,
      theme: Style.myLightTheme,
      title: "eDUcircle",
      home: MainLayout(),
    );
  }
}
