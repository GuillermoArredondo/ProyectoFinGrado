import 'package:flutter/material.dart';
import 'package:forumdroid/models/user_model.dart';
import 'package:forumdroid/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

//Muestra una alerta con su mensaje
void alert(BuildContext context, String titulo, String msg, [onPressed]) {
  showDialog(
      context: context,
      builder: (buildcontext) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(msg),
          actions: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: app_theme.primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    minimumSize: new Size(70, 40)),
                onPressed: () {
                  Navigator.pop(context);
                  onPressed();
                },
                child: new Text('OK'))
          ],
          elevation: 20,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        );
      });
}

//Muestra un dialog de carga
alertLoading(context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          content: Container(
            padding: EdgeInsets.all(1),
            child: CircularProgressIndicator(
              strokeWidth: 6,
            ),
            width: 230,
            height: 230,
          ),
          backgroundColor: Colors.transparent,
        ),
      );
    },
  );
}

//Elimina el alert de carga
hidealertLoading(context) => Navigator.of(context).pop();

//Generación de ID
String genId() => Uuid().v1();

//Guarda en las shared prefs el user logged
saveUserSharedPrefs(UserModel user) async {
  deleteUserPrefs();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var idUser = user.idUser;
  var id = user.id;
  var name = user.name;
  var email = user.email;
  var pass = user.password;
  var imgUrl = user.imgUrl;
  var mediaU = user.media;
  await prefs.setString('id', id!);
  await prefs.setString('name', name!);
  await prefs.setString('email', email!);
  await prefs.setString('pass', pass!);
  await prefs.setString('imgUrl', imgUrl!);
  await prefs.setBool('media', mediaU!);
  await prefs.setString('idUser', idUser!);
}

Future<dynamic> getUserfromSharePrefs() async {
  final user = UserModel();
  user.idUser = await getIdUserPrefs();
  user.id = await getIdPrefs();
  user.name = await getNamePrefs();
  user.email = await getEmailPrefs();
  user.imgUrl = await getUrlPrefs();
  user.media = await getMediaPrefs();
  return user;
}

UserModel? getUser() {
  getUserfromSharePrefs().then((value) {
    return value;
  });
}

//Elimina las shared prefs seteadas
deleteUserPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
}

Future<String> getNamePrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('name') as String;
}

Future<String> getIconPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('name')!.substring(0, 1);
}

Future<String> getEmailPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('email') as String;
}

Future<String> getIdPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('id') as String;
}

Future<String> getIdUserPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('idUser') as String;
}

Future<String> getUrlPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('imgUrl') as String;
}

Future<bool?> getMediaPrefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('media');
}
