import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:forumdroid/models/user_model.dart';

import 'general.dart';

// ignore: non_constant_identifier_names
final _firebase = FirebaseAuth.instance;

loginUserPass(context, UserModel user) async {
  try {
    await _firebase
        .signInWithEmailAndPassword(
            email: user.email!, password: user.password!)
        .then((value) {
      Navigator.of(context).pushReplacementNamed('home');
    });
  } on FirebaseAuthException catch (error) {

    switch(error.code){
      case 'user-not-found':{
        alert(context, 'Error', 'Usuario no encontrado');
      }break;
      case 'wrong-password':{
        alert(context, 'Error', 'Contraseña incorrecta');
      }break;
      default: { 
        alert(context, 'Error', error.code);
      }
      break;
    }
  } catch (e) {
    alert(context, 'Error', e.toString());
  }
}

registerUser(context, UserModel user) async {
  try {
    await _firebase
        .createUserWithEmailAndPassword(
            email: user.email!, password: user.password!)
        .then((value) {
      alert(context, 'Éxito', 'Usuario registrado correctamente', () => Navigator.pop(context));
      Navigator.of(context).pushReplacementNamed('login');
    });
  } on FirebaseAuthException catch (error) {
    if (error.code == 'email-already-in-use') {
      alert(context, 'Error', 'Ese email ya está registrado');
    } else {
      alert(context, 'Error', error.message.toString());
    }
  } catch (error) {
    alert(context, 'Error', error.toString());
  }
}
