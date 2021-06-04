import 'package:cloud_firestore/cloud_firestore.dart';
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

//get Usuario por email de Firestore
getUserByEmail(FirebaseFirestore firestore, String email) async {
  CollectionReference collectionReference = firestore.collection('users');
  QuerySnapshot<Object?> users =
      await collectionReference.where('email', isEqualTo: email).get();
  List<UserModel> list = [];
  for (var doc in users.docs) {
    UserModel user = new UserModel();
    user.id = doc['id'];
    user.email = doc['email'];
    user.name = doc['name'];
    user.password = doc['password'];
    list.add(user);
  }
  //return list[0];
  saveUserSharedPrefs(list[0]);
}

