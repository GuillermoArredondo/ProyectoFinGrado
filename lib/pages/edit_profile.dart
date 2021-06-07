import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forumdroid/models/user_model.dart';
import 'package:forumdroid/theme/app_theme.dart';
import 'package:forumdroid/utils/auth.dart';
import 'package:forumdroid/utils/general.dart';
import 'package:forumdroid/utils/validations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfile extends StatefulWidget {

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  final _formKey = GlobalKey<FormState>();
  final user = UserModel();
  TextEditingController? _controller;

  @override
  void initState() {
    _controller = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar mi Perfil'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 50),
          child: Center(
            child: Form(
                key: _formKey,
                child: Column(
                    //mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                  _imageUser2(),
                  //_idUser(),
                  Padding(padding: EdgeInsets.all(40)),
                  _userNameInputBox(),
                  Padding(padding: EdgeInsets.all(10)),
                  _emailInputBox(),
                  Padding(padding: EdgeInsets.all(10)),
                  _passInputBox(),
                  Padding(padding: EdgeInsets.all(60)),
                  _saveButton(),
                ])),
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


  _imageUser2(){
    return Container(
      width: 190.0,
      height: 190.0,
      decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
          fit: BoxFit.fill,
          image: new NetworkImage(
                 "https://i.imgur.com/BoN9kdC.png")
                 )
    ));
  }


  _idUser(){
    return Visibility (
      visible: true,
      child: Container(
        child: FutureBuilder<String>(
              future: getIdPrefs(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return TextFormField(
                    initialValue : snapshot.data,
                    controller: _controller,
                  );
                }
                return CircularProgressIndicator();
              },
        ),
        
      ),
    );
  }

  _userNameInputBox() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        child: FutureBuilder<String>(
            future: getNamePrefs(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return TextFormField(
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
          initialValue: snapshot.data,
          onSaved: (value) {
            user.name = value!;
          },
          validator: (value) => valName(value!)
        );
              }
              return CircularProgressIndicator();
            },
      ),
    );
  }

  _emailInputBox() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        child: FutureBuilder<String>(
            future: getEmailPrefs(),
            builder: (context, snapshot) {
              if ((snapshot.hasData) && (snapshot.data!.contains('@'))) {
                return TextFormField(
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
          initialValue: snapshot.data,
          onSaved: (value) {
            user.email = value!;
          },
          validator: (value) => valEmail(value!)
        );
        }
        return Text('Email de twitter no disponible');
        },
      ));
  }

  _passInputBox() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        child: TextFormField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: "Nueva Contraseña",
            icon: Icon(
              Icons.lock_open,
              color: Colors.black,
              size: 25,
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
            user.password = value!;
          },
          //validator: (value) => {}
        ));
  }

  _saveButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: app_theme.primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            minimumSize: new Size(190, 50)),
        child: Text(
          'Guardar',
          style: new TextStyle(fontSize: 19),
        ),
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          //validacion del key del formulario
          if (!_formKey.currentState!.validate()) {
            return;
          }
          _formKey.currentState!.save();
          bool? media = await prefs.getBool('media');
          if (!media!){
            editUser(context, user);
          }else{
            alert(context, 'Error', 'No puedes editar tu perfil si has accedido con una red social');
          }
          
        },
      ),
    );
  }
}