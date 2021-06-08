import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:forumdroid/models/post_model.dart';
import 'package:forumdroid/models/user_model.dart';
import 'package:forumdroid/utils/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'general.dart';

//añadir nuevo usuario a Firestore
void addNewUser(FirebaseFirestore firestore, UserModel user) {
  print('addNewUser');
  var id = user.id;
  var name = user.name;
  var email = user.email;
  var password = user.password;
  var imgUrl = user.imgUrl;
  firestore.collection("users").add({
    "id": '$id',
    "name": '$name',
    "email": '$email',
    "password": '$password',
    "imgUrl": '$imgUrl'
  });
}

//Sube la imagen del usuario y devuelve la url del Callback de Storage
Future<String> uploadImgToFireStore(String idUser, File image) async {
  print(idUser);
  if (image != null) {
    final storage = FirebaseStorage.instance;
    var snapshot = await storage
        .ref()
        .child('avatar/' + idUser)
        .putFile(image)
        .whenComplete(() => null);

    return snapshot.ref.getDownloadURL();
  } else {
    return 'null';
  }
}

//Cambia la imagen del usuario
changeImageUser(String idUser, File image) async {
  if (image != null) {
    final storage = FirebaseStorage.instance;
    var snapshot = await storage
        .ref()
        .child('avatar/' + idUser)
        .putFile(image)
        .whenComplete(() => null);

    return snapshot.ref.getDownloadURL();
  } else {
    return 'null';
  }
}

//Get Usuario por email de Firestore
//Este método tambien es llamado cuando se intenta logear con una red social,
//Y el usuario no esta regiustrado en firestore, de esta manera se registrará
getUserByEmail(
    context, FirebaseFirestore firestore, UserModel user, bool media) async {
  CollectionReference collectionReference = firestore.collection('users');
  QuerySnapshot<Object?> users =
      await collectionReference.where('email', isEqualTo: user.email).get();

  if (users.docs.isEmpty) {
    user.id = genId();
    user.password = '';
    user.media = true;
    addNewUser(firestore, user);
    saveUserSharedPrefs(user);
  } else {
    List<UserModel> list = [];
    for (var doc in users.docs) {
      UserModel user = new UserModel();
      user.idUser = doc['id'];
      user.id = doc.id;
      user.email = doc['email'];
      user.name = doc['name'];
      user.password = doc['password'];
      user.imgUrl = doc['imgUrl'];
      user.media = media;
      list.add(user);
    }
    print('getUserByEmail');
    saveUserSharedPrefs(list[0]);
  }
}

//Edita un usuario de firestore
editUserFireStore(context, FirebaseFirestore firestore, UserModel user) async {
  print('editUserFireStore: ' + user.imgUrl!);
  CollectionReference collectionReference = firestore.collection('users');

  if (user.password!.isNotEmpty) {
    collectionReference
        .doc(user.id)
        .update(
            {'name': user.name, 'email': user.email, 'password': user.password, 'imgUrl':user.imgUrl})
        .then((value) => {
              saveUserSharedPrefs(user),
              alert(
                  context,
                  'Éxito',
                  'Los cambios se han guardado correctamente',
                  () => Navigator.of(context).pushReplacementNamed('myprofile'))
            })
        .catchError((error) => {alert(context, 'Error', error.toString())});
  } else {
    collectionReference
        .doc(user.id)
        .update({
          'name': user.name,
          'email': user.email,
          'imgUrl':user.imgUrl
        })
        .then((value) => {
              saveUserSharedPrefs(user),
              alert(
                  context,
                  'Éxito',
                  'Los cambios se han guardado correctamente',
                  () => Navigator.of(context).pushReplacementNamed('myprofile'))
            })
        .catchError((error) => {alert(context, 'Error', error.toString())});
  }
}

//añadir nuevo post a Firestore
addNewPost(PostModel post) async {
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
