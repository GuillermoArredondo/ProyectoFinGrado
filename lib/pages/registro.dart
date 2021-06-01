import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forumdroid/theme/app_theme.dart';

class Registro extends StatefulWidget {
  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.white, app_theme.primaryColor],
                begin: Alignment.bottomCenter)),
        padding: EdgeInsets.only(top: 150),
        child: Center(
          child: Form(
              child: Column(
                  //mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                Text(
                  "Registro nuevo usuario",
                  style: TextStyle(fontSize: 22),
                ),
                Padding(padding: EdgeInsets.all(40)),
                _userNameInputBox(),
                Padding(padding: EdgeInsets.all(10)),
                _emailInputBox(),
                Padding(padding: EdgeInsets.all(10)),
                _passInputBox(),
                Padding(padding: EdgeInsets.all(60)),
                _registerButton(),
                Padding(padding: EdgeInsets.all(15)),
                _backButton(),
              ])),
        ),
      ),
    );
  }

  _userNameInputBox() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        child: TextFormField(
          decoration: InputDecoration(
            hintText: "Nombre de usuario",
            icon: Icon(FontAwesomeIcons.user, color: Colors.black),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(
                color: Colors.black,
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(
                color: Colors.black,
                width: 2.0,
              ),
            ),
          ),
        ));
  }

  _emailInputBox() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: "Correo electrónico",
            icon: Icon(FontAwesomeIcons.envelope, color: Colors.black),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(
                color: Colors.black,
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(
                color: Colors.black,
                width: 2.0,
              ),
            ),
          ),
        ));
  }

  _passInputBox() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        child: TextFormField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: "Contraseña",
            icon: Icon(
              Icons.lock_open,
              color: Colors.black,
              size: 30,
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(
                color: Colors.black,
                width: 2.0,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(
                color: Colors.black,
                width: 2.0,
              ),
            ),
          ),
        ));
  }

  _registerButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: app_theme.primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            minimumSize: new Size(190, 50)),
        child: Text(
          'Registrarse',
          style: new TextStyle(fontSize: 19),
        ),
        onPressed: () {},
      ),
    );
  }

  _backButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: app_theme.primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            minimumSize: new Size(190, 50)),
        child: Text(
          'Volver al Login',
          style: new TextStyle(fontSize: 19),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
