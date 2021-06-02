import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forumdroid/models/user_model.dart';
import 'package:forumdroid/pages/registro.dart';
import 'package:forumdroid/theme/app_theme.dart';
import 'package:forumdroid/utils/auth.dart';
import 'package:forumdroid/utils/validations.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>();
  UserModel user = new UserModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: app_theme.primaryColor,
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.white, app_theme.primaryColor],
                begin: Alignment.bottomCenter)),
        padding: EdgeInsets.only(top: 100),
        child: Center(
          child: Form(
              key: _formKey,
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
                Padding(padding: EdgeInsets.all(20)),
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
              color: Colors.black,
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
          onSaved: (value) {
            user.email = value!;
          },
          validator: (value) => valEmail(value!)
      ),
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
              color: Colors.black,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
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
          onSaved: (value) {
            user.password = value!;
          },
          validator: (value) => valPass(value!)
          ),
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
        onPressed: () {

          //validacion del key del formulario
          if (!_formKey.currentState!.validate()) {
            return;
          }
          _formKey.currentState!.save();
          loginUserPass(context, user);
        },
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

  _newAccText() {
    return Container(
      child: new Row(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(left: 30)),
          Text(
            "¿No tienes cuenta?",
            style: TextStyle(fontSize: 20),
          ),
          Padding(padding: EdgeInsets.all(20)),
          InkWell(
            child: Text("Registrarse",
                style: TextStyle(fontSize: 20, color: app_theme.primaryColor)),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => Registro())),
          ),
          //Text("Registrarse", style: TextStyle(fontSize: 20, color: app_theme.primaryColor))
        ],
      ),
    );
  }
}
