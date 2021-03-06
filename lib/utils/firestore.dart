import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:forumdroid/models/post_model.dart';
import 'package:forumdroid/models/user_model.dart';
import 'general.dart';


final _firestore = FirebaseFirestore.instance;

//añadir nuevo usuario a Firestore
void addNewUser(UserModel user) {
  var password;
  if (user.password != '') {
    password = cifrarPass(user.password!);
  } else {
    password = user.password;
  }
  var id = user.id;
  var name = user.name;
  var email = user.email;
  var imgUrl = user.imgUrl;
  _firestore.collection("users").add({
    "id": '$id',
    "name": '$name',
    "email": '$email',
    "password": '$password',
    "imgUrl": '$imgUrl'
  });
}

//Sube la imagen del usuario y devuelve la url del Callback de Storage
Future<String> uploadImgToFireStore(String idUser, File image) async {
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

//Obtiene la url de la img de un usuario por id
Future<String> getUserImage(String idUser) async {
  final storage = FirebaseStorage.instance;
  String downloadURL = await storage.ref('avatar/$idUser').getDownloadURL();
  return downloadURL;
}

//Obtiene el UserName de un usuario por id
Future<String> getUserNameById(String idUser) async {
  CollectionReference collectionReference = _firestore.collection('users');
  QuerySnapshot<Object?> users =
      await collectionReference.where('id', isEqualTo: idUser).get();

  String name = '';
  for (var doc in users.docs) {
    name = doc['name'];
  }
  return name;
}

//Obtiene el numero de post que ha hecho un usuario logged
Future<int> getNumPosts() async {
  String idUser = await getIdUserPrefs();
  CollectionReference collectionReference = _firestore.collection('posts');
  QuerySnapshot<Object?> users =
      await collectionReference.where('idUser', isEqualTo: idUser).get();

  int numPosts = users.docs.length;
  return numPosts;
}


//Obtiene el numero de post que ha hecho un usuario
Future<int> getNumPostsUser(String idUser) async {
  CollectionReference collectionReference = _firestore.collection('posts');
  QuerySnapshot<Object?> users =
      await collectionReference.where('idUser', isEqualTo: idUser).get();

  int numPosts = users.docs.length;
  return numPosts;
}


//Elimina una publicacion
deletePost(context, String idPost) async {
  await _firestore.collection('posts').doc(idPost).delete().then((value) {
    alert(context, 'Éxito', 'Publicación eliminada correctamente');
  });
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
//Y el usuario no esta registrado en firestore, de esta manera se registrará
getUserByEmail(
    context, UserModel user, bool media) async {
  CollectionReference collectionReference = _firestore.collection('users');
  QuerySnapshot<Object?> users =
      await collectionReference.where('email', isEqualTo: user.email).get();

  if (users.docs.isEmpty) {
    print('estoy dentro');
    user.id = genId();
    user.password = '';
    user.media = true;
    addNewUser(user);
    saveUserSharedPrefs(user);
  } else {
    print('estoy fuera');
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
    saveUserSharedPrefs(list[0]);
  }
}

//Obtiene el usuario entero por email
Future<dynamic> getUserProfile(String idUser)async{
  CollectionReference collectionReference = _firestore.collection('users');
  QuerySnapshot<Object?> users =
      await collectionReference.where('id', isEqualTo: idUser).get();

    UserModel user = new UserModel();
    for (var doc in users.docs) {
      user.idUser = doc['id'];
      user.id = doc.id;
      user.email = doc['email'];
      user.name = doc['name'];
      user.password = doc['password'];
      user.imgUrl = doc['imgUrl'];
    }
    return user;
}

//Edita un usuario de firestore
editUserFireStore(context, UserModel user) async {
  CollectionReference collectionReference = _firestore.collection('users');

  if (user.password!.isNotEmpty) {
    collectionReference
        .doc(user.id)
        .update({
          'name': user.name,
          'email': user.email,
          'password': user.password,
          'imgUrl': user.imgUrl
        })
        .then((value) => {
              saveUserSharedPrefs(user),
              alert(
                  context,
                  'Éxito',
                  'Los cambios se han guardado correctamente',
                  () => Navigator.of(context).popUntil((route) => route.isFirst))
            })
        .catchError((error) => {alert(context, 'Error', error.toString())});
  } else {
    collectionReference
        .doc(user.id)
        .update({'name': user.name, 'email': user.email, 'imgUrl': user.imgUrl})
        .then((value) => {
              saveUserSharedPrefs(user),
              alert(
                  context,
                  'Éxito',
                  'Los cambios se han guardado correctamente',
                  () => Navigator.of(context).popUntil((route) => route.isFirst))
            })
        .catchError((error) => {alert(context, 'Error', error.toString())});
  }
}

//Añadir nuevo post a Firestore
addNewPost(PostModel post) async {
  var id = genId();
  var title = post.titulo;
  var content = post.contenido;
  var listEnlaces = post.enlaces;
  var listHastags = post.hashtags;
  var votos = 0;
  var idUser = await getIdUserPrefs();
  var fecha = post.fecha;
  List<String> listVotos = [];
  _firestore.collection("posts").add({
    "id": '$id',
    "title": '$title',
    "content": '$content',
    "listEnlaces": FieldValue.arrayUnion(listEnlaces!),
    "listHastags": FieldValue.arrayUnion(listHastags!),
    "listVotos": FieldValue.arrayUnion(listVotos),
    "votos": '$votos',
    "idUser": '$idUser',
    "fecha": '$fecha'
  });
}

//Edita una publicacion
editPost(context, QueryDocumentSnapshot<Object?> document, PostModel post){
  CollectionReference collectionReference = _firestore.collection('posts');
  
    collectionReference
    .doc(document.id)
        .update({
          'listEnlaces': FieldValue.arrayRemove(List<String>.from(document['listEnlaces'])),
          'listHastags': FieldValue.arrayRemove(List<String>.from(document['listHastags']))
        })
        .then((value) => {})
        .catchError((error) => {alert(context, 'Error', error.toString())});
    
    collectionReference
        .doc(document.id)
        .update({
          'title': post.titulo,
          'content': post.contenido,
          'fecha': post.fecha,
          'listEnlaces': FieldValue.arrayUnion(post.enlaces!),
          'listHastags': FieldValue.arrayUnion(post.hashtags!)
        })
        .then((value) => {
              alert(
                  context,
                  'Éxito',
                  'Los cambios se han guardado correctamente',
                 () => {})
            })
        .catchError((error) => {alert(context, 'Error', error.toString())});
}

//Buscar el id de un usuario en la lista de los votos de un post
searchVote(String idUser, QueryDocumentSnapshot<Object?> document) async {
  CollectionReference collectionReference = _firestore.collection('posts');
  QuerySnapshot<Object?> post =
      await collectionReference.where('id', isEqualTo: document['id']).get();
  List<String> votos = [];
  for (var doc in post.docs) {
    votos = List.from(doc['listVotos']);
  }
  if (votos.contains(idUser)) {
    return true;
  } else {
    return false;
  }
}

//Pone un voto en una publicacion
ponerVoto(String idUser, QueryDocumentSnapshot<Object?> document) {
  CollectionReference collectionReference = _firestore.collection('posts');
  List<String> lista = List.from(document['listVotos']);
  var votos = lista.length;
  votos = votos + 1;
  List<String> newList = [];
  newList.add(idUser);

  collectionReference
      .doc(document.id)
      .update({'votos': votos, 'listVotos': FieldValue.arrayUnion(newList)})
      .then((value) => {print('exito poniendo voto')})
      .catchError((error) {
        print('error poniendo voto');
      });
}

//Quita un voto de una publicación
quitarVoto(String idUser, QueryDocumentSnapshot<Object?> document) {
  CollectionReference collectionReference = _firestore.collection('posts');
  List<String> lista = List.from(document['listVotos']);
  var votos = lista.length;
  votos = votos - 1;
  List<String> newList = [];
  newList.add(idUser);

  collectionReference
      .doc(document.id)
      .update({'votos': votos, 'listVotos': FieldValue.arrayRemove(newList)})
      .then((value) => {print('exito quitando voto')})
      .catchError((error) {
        print('error quitando voto');
      });
}
