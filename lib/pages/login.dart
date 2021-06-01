import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forumdroid/theme/app_theme.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: app_theme.primaryColor,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 100),
        child: Center(
          child: Form(
              child: Column(
                  //mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                Image.asset(
                  'assets/iconoApp.png',
                  height: 150,
                ),
                Padding(padding: EdgeInsets.all(20)),
                Text(
                  "INICIO DE SESION",
                  style: TextStyle(fontSize: 22),
                ),
                Padding(padding: EdgeInsets.all(35)),
                _emailInputBox(),
                Padding(padding: EdgeInsets.all(10)),
                _passInputBox(),
                Padding(padding: EdgeInsets.all(35)),
                _loginButton(),
                Padding(padding: EdgeInsets.all(20)),
                _mediaButtons(),
                Padding(padding: EdgeInsets.all(20)),
                _newAccText(),
              ])),
        ),
      ),
    );
  }

  _emailInputBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      child: TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            icon: Icon(Icons.mail_outline, color: Colors.black),
            labelText: 'Email',
            labelStyle: TextStyle(
              color: app_theme.primaryColor,
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(
                color: app_theme.primaryColor,
                width: 2.0,
              ),
            ),
          ),
          onSaved: (value) {},
          validator: (value) {}),
    );
  }

  _passInputBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      child: TextFormField(
          obscureText: true,
          decoration: InputDecoration(
            icon: Icon(Icons.lock_open, color: Colors.black),
            labelText: 'Contraseña',
            labelStyle: TextStyle(
              color: app_theme.primaryColor,
            ),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(15.0)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide(
                color: app_theme.primaryColor,
                width: 2.0,
              ),
            ),
          ),
          onSaved: (value) {},
          validator: (value) {}),
    );
  }

  _loginButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: app_theme.primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            minimumSize: new Size(190, 50)),
        child: Text(
          'Iniciar Sesión',
          style: new TextStyle(fontSize: 19),
        ),
        onPressed: () {},
      ),
    );
  }

  _mediaButtons() {
    return Container(
      child: new Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 120),
            child: ElevatedButton(
              onPressed: () {},
              child: FaIcon(
                FontAwesomeIcons.google,
                size: 35,
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(10),
                primary: Colors.black,
                shape: CircleBorder(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: ElevatedButton(
              onPressed: () {},
              child: FaIcon(
                FontAwesomeIcons.twitter,
                size: 35,
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(10),
                primary: Colors.black,
                shape: CircleBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _newAccText(){
    return Container(
      child: new Row(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left: 20)),
          Text("Aún no tienes cuenta?", style: TextStyle(fontSize: 20),),
          Padding(padding: EdgeInsets.all(20)),
          Text("Registrarse", style: TextStyle(fontSize: 20, color: app_theme.primaryColor))
        ],
      ),
    );
  }
}
