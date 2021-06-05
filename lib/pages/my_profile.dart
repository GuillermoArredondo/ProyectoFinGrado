import 'package:flutter/material.dart';
import 'package:forumdroid/models/user_model.dart';
import 'package:forumdroid/theme/app_theme.dart';
import 'package:forumdroid/utils/general.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProfile extends StatefulWidget {

  @override
  _MyProfileState createState() => _MyProfileState();

}

class _MyProfileState extends State<MyProfile> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajustes de Perfil'),
        centerTitle: true,
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.only(top: 60)),
              _imageUser(),
              Padding(padding: EdgeInsets.only(top: 20)),
              _buildName(),
              Padding(padding: EdgeInsets.only(top: 10)),
              _buildEmail(),
              Padding(padding: EdgeInsets.only(top: 70)),
              _buildButton('Editar Perfil',
                  () => Navigator.of(context).pushReplacementNamed('home')),
              Padding(padding: EdgeInsets.only(top: 20)),
              _buildButton('Generar QR',
                  () => Navigator.of(context).pushReplacementNamed('home')),
              Padding(padding: EdgeInsets.only(top: 20)),
              _buildButton('Seguidores',
                  () => Navigator.of(context).pushReplacementNamed('home')),
              Padding(padding: EdgeInsets.only(top: 20)),
              _buildButton('Seguidos',
                  () => Navigator.of(context).pushReplacementNamed('home')),
              Padding(padding: EdgeInsets.only(top: 20)),
              _buildButton('Cerrar sesión',
                  () => _logOut()),
            ],
          ),
        ),
      ),
    );
  }

  _imageUser() {
    return CircleAvatar(
      child: FutureBuilder<String>(
            future: getIconPrefs(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!, style: TextStyle(fontSize: 60),);
              }
              return CircularProgressIndicator();
            },
      ),
      radius: 65,
    );
  }

  _buildName() {
    return FutureBuilder<String>(
            future: getNamePrefs(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!, style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold
                ),
                );
              }
              return CircularProgressIndicator();
            },
    );
  }

  _buildEmail() {
    return FutureBuilder<String>(
            future: getEmailPrefs(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!, style: TextStyle(
                  fontSize: 18,
                ),
                );
              }
              return CircularProgressIndicator();
            },
    );
  }

  _buildButton(String tittle, [onPressed]) {
    return ElevatedButton(
        onPressed: onPressed,
        child: new Text(
          '$tittle',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        style: ElevatedButton.styleFrom(
            primary: Color.fromRGBO(226, 247, 255, 1),
            minimumSize: Size(270, 50),
            padding: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Colors.black),
            )));
  }

  _logOut(){
    deleteUserPrefs();
    Navigator.of(context).pushReplacementNamed('login');
  }

  // _loadUserData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   txtUserName = prefs.getString('name') ?? 'User Name';
  //   txtIcon = txtUserName.substring(0, 1);
  //   txtEmail = prefs.getString('email') ?? 'email';
  //   //print(txtIcon);
  // }
}
