import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
      home: Scaffold(
        appBar: new AppBar(
         
        ),
      ),
    );
  }
}