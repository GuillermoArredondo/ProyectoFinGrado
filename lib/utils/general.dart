
import 'package:flutter/material.dart';
import 'package:forumdroid/models/user_model.dart';
import 'package:forumdroid/theme/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';


//Muestra una alerta con su mensaje
void alert(BuildContext context, String titulo, String msg,
    [onPressed]) {
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
              shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              minimumSize: new Size(70, 40)),
              onPressed: (){
                Navigator.pop(context);
                onPressed();
              },
              child: new Text('OK')
            )
          ],
          elevation: 20,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        );
      });
}

//Generación de ID
String genId() => Uuid().v1();


//Guarda en las shared prefs el user logged
saveUserSharedPrefs(UserModel user) async{
  print('saveUserSharedPrefs');
  deleteUserPrefs();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var id = user.id;
  var name = user.name;
  var email = user.email;
  var pass = user.password;
  await prefs.setString('id', id!);
  await prefs.setString('name', name!);
  await prefs.setString('email', email!);
  await prefs.setString('pass', pass!);
}

//Elimina las shared prefs seteadas
deleteUserPrefs()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
}

//Obtiene el user 
getUserFromPrefs() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserModel user = new UserModel();
    user.id = prefs.getString('id');
    user.email = prefs.getString('email');
    user.email = prefs.getString('name');
    user.email = prefs.getString('password');
    return user;
}

//Obtiene los valores del user de prefs
// Future<UserModel> getPrefs()async{
//   UserModel user = new UserModel();
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   user.id = prefs.getString('id');
//   user.email = prefs.getString('email');
//   user.name = prefs.getString('name');
//   user.password = prefs.getString('password');
//   return user;
// }

Future<String> getNamePrefs()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('name') as String;
}

Future<String> getIconPrefs()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('name')!.substring(0,1);
}

Future<String> getEmailPrefs()async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('email') as String;
}
