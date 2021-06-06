import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forumdroid/models/post_model.dart';
import 'package:forumdroid/models/user_model.dart';
import 'package:forumdroid/utils/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'general.dart';

//añadir nuevo usuario a Firestore
void addNewUser(FirebaseFirestore firestore, UserModel user) {
  var id = genId();
  var name = user.name;
  var email = user.email;
  var password = user.password;
  firestore.collection("users").add({
    "id": '$id',
    "name": '$name',
    "email": '$email',
    "password": '$password'
  });
}

//Get Usuario por email de Firestore
//Este método tambien es llamado cuando se intenta logear con una red social,
//Y el usuario no esta regiustrado en firestore, de esta manera se registrará
getUserByEmail(context, FirebaseFirestore firestore, UserModel user, bool media) async {
  CollectionReference collectionReference = firestore.collection('users');
  QuerySnapshot<Object?> users =
      await collectionReference.where('email', isEqualTo: user.email).get();

  if (users.docs.isEmpty) {
    print('getUserByEmail dentro del if');
    user.id = genId();
    user.password = '';
    addNewUser(firestore, user);
    saveUserSharedPrefs(user, media);
  } else {
    List<UserModel> list = [];
    for (var doc in users.docs) {
      UserModel user = new UserModel();
      print('-------------------------------------------------------');
      print(doc.id);
      user.id = doc.id;
      user.email = doc['email'];
      user.name = doc['name'];
      user.password = doc['password'];
      list.add(user);
    }
    print('getUserByEmail');
    saveUserSharedPrefs(list[0], media);
  }
}

//Edita un usuario de firestore
editUserFireStore(context, FirebaseFirestore firestore, UserModel user) async {

  CollectionReference collectionReference = firestore.collection('users');

  if (user.password!.isNotEmpty) {
    print(user.id);
    collectionReference
      .doc(user.id)
      .update({
        'name' : user.name,
        'email' : user.email,
        'password' : user.password
      }).then((value) => {
        saveUserSharedPrefs(user, true),
        alert(context, 'Éxito', 'Los cambios se han guardado correctamente',
        () => Navigator.pop(context))
      }).catchError((error) => {
        alert(context, 'Error', error.toString())
      });
  } else {
    print(user.id);
    collectionReference
      .doc(user.id)
      .update({
        'name' : user.name,
        'email' : user.email,
      }).then((value) => {
        saveUserSharedPrefs(user, true),
        alert(context, 'Éxito', 'Los cambios se han guardado correctamente',
        () => Navigator.of(context).pushReplacementNamed('myprofile'))
      }).catchError((error) => {
        alert(context, 'Error', error.toString())
      });
  }
}

//añadir nuevo post a Firestore
addNewPost(PostModel post) async{
  final firestore = FirebaseFirestore.instance;
  var id = genId();
  var title = post.titulo;
  var content = post.contenido;
  var listEnlaces = post.enlaces;
  var listHastags = post.hashtags;
  var votos = 0;
  var idUser = await getIdPrefs();
  firestore.collection("posts").add({
    "id": '$id',
    "title": '$title',
    "content": '$content',
    "listEnlaces": '$listEnlaces',
    "listHastags": '$listHastags',
    "votos": '$votos',
    "idUser": '$idUser'
  });
}
