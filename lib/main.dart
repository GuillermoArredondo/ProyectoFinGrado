import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:forumdroid/pages/generate_qr.dart';
import 'package:forumdroid/pages/home.dart';
import 'package:forumdroid/pages/login.dart';
import 'package:forumdroid/pages/my_profile.dart';
import 'package:forumdroid/pages/profile_nav.dart';
import 'package:forumdroid/pages/registro.dart';

void main() {
  //Inicializa todas las dependencias de Firebase antes de Correr Flutter
  WidgetsFlutterBinding.ensureInitialized();
  //Verifica el google-services
  Firebase.initializeApp().then((value) {
    runApp(MyApp());
  });
  
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'ForumDroid',
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      routes:{
        'login': (BuildContext context) => Login(),
        'registro' : (BuildContext context) => Registro(),
        'home': (BuildContext context) => Home(),
        'myprofile' : (BuildContext context) => MyProfile(),
        'profile_nav' : (BuildContext context) => Profile(false),
        'generate_qr'  : (BuildContext context) => GenerateQR()
      } 
    );
  }
}