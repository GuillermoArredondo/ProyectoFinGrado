import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:forumdroid/models/user_model.dart';
import 'package:forumdroid/pages/home.dart';
import 'package:forumdroid/utils/firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'general.dart';

// ignore: non_constant_identifier_names
final _firebase = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;

//variables API de twitter
final TWITTER_API = 'dlMLoZugvLVrDAmX2ue5iKMFg';
final TWITTER_SECRET = 'fJ5jZWochpcymE81OujJrkIF68GiF7jHzv20XncKZNSKxfUxsm';


//Login con Usuario / Password
loginUserPass(context, UserModel user) async {
  alertLoading(context);
  try {
    await _firebase
        .signInWithEmailAndPassword(
            email: user.email!, password: user.password!)
        .then((value) {
          getUserByEmail(context, _firestore, user, false);
          hidealertLoading(context);
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

//Registro de Usuario en Firebase
registerUser(context, UserModel user) async {
  try {
    await _firebase
        .createUserWithEmailAndPassword(
            email: user.email!, password: user.password!)
        .then((value) {
      alert(context, 'Éxito', 'Usuario registrado correctamente',
       () => Navigator.pop(context));
      addNewUser(_firestore, user);
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

//Login con Google
loginGoogle(context) async {
  alertLoading(context);
  try {
    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await _firebase.signInWithCredential(credential).then((value) {

      UserModel user = new UserModel();
      user.email = googleUser.email;
      user.name = googleUser.displayName;
      getUserByEmail(context, _firestore, user, true);

      hidealertLoading(context);
      Navigator.of(context).pushReplacementNamed('home');
    });
  } catch (error) {
    alert(context, 'Error', error.toString());
  }
}


//Login con Twitter
loginTwitter(context) async{
  final TwitterLogin _loginTW =  TwitterLogin(
    consumerKey: TWITTER_API, 
    consumerSecret: TWITTER_SECRET
  );
  try {
    final TwitterLoginResult result = await _loginTW.authorize();
    switch(result.status){
      case TwitterLoginStatus.loggedIn:
        alertLoading(context);
        var session = result.session;
        final AuthCredential twitterAuth = TwitterAuthProvider.credential(
          accessToken: session.token,
          secret: session.secret
        );
        hidealertLoading(context);
        await _firebase.signInWithCredential(twitterAuth).then((value) {
          UserModel user = new UserModel();
          user.email = '..';
          user.name = result.session.username;
          getUserByEmail(context, _firestore, user, true);
          
          Navigator.of(context).pushReplacementNamed('home');
        });
        break;
      case TwitterLoginStatus.cancelledByUser:
        alert(context, 'Error', 'Cancelado');
        break;
      case TwitterLoginStatus.error:
        alert(context, 'Error', result.errorMessage);
        break;
    }
  } catch (error) {
    alert(context, 'Error', error.toString());
  }
}

logOut(context){
    _firebase.signOut();
    deleteUserPrefs();
    Navigator.of(context).pushReplacementNamed('login');
}

editUser(context, user)async{
  user.id = await getIdPrefs();
  editUserFirebase(context, user);
}

editUserFirebase(context, UserModel user) async {
  try {
    await _firebase
        .currentUser!.updateEmail(user.email!)
        .then((value) {
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

  if (user.password!.isNotEmpty) {
    try {
    await _firebase
        .currentUser!.updatePassword(user.password!)
        .then((value) {
          editUserFireStore(context, _firestore, user);
    });
  } on FirebaseAuthException catch (error) {
    alert(context, 'Error', error.message.toString());
  } catch (error) {
    alert(context, 'Error', error.toString());
  }
  }else{
    editUserFireStore(context, _firestore, user);
  }

  

}





