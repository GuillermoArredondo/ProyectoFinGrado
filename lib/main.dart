import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:forumdroid/models/user_model.dart';
import 'package:forumdroid/pages/edit_profile.dart';
import 'package:forumdroid/pages/home.dart';
import 'package:forumdroid/pages/login.dart';
import 'package:forumdroid/pages/my_profile.dart';
import 'package:forumdroid/pages/registro.dart';
import 'package:forumdroid/utils/general.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  //Inicializa todas las dependencias de Firebase antes de Correr Flutter
  WidgetsFlutterBinding.ensureInitialized();
  //Verifica el google-services
  Firebase.initializeApp().then((value) {
    runApp(MyApp());
  });
  
}

// ignore: must_be_immutable
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
        'edit' : (BuildContext context) => EditProfile(),
      } 
    );
  }
}