import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forumdroid/models/user_model.dart';
import 'package:forumdroid/theme/app_theme.dart';
import 'package:forumdroid/utils/auth.dart';
import 'package:forumdroid/utils/firestore.dart';
import 'package:forumdroid/utils/general.dart';
import 'package:forumdroid/utils/validations.dart';
import 'package:image_picker/image_picker.dart';

class Registro extends StatefulWidget {
  @override
  _RegistroState createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final _formKey = GlobalKey<FormState>();
  final user = UserModel();
  File? imagen;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.white, app_theme.primaryColor],
                  begin: Alignment.bottomCenter)),
          padding: EdgeInsets.only(top: 80),
          child: Center(
            child: Form(
                key: _formKey,
                child: Column(children: <Widget>[
                  Text(
                    "Registro nuevo usuario",
                    style: TextStyle(fontSize: 22),
                  ),
                  Padding(padding: EdgeInsets.all(20)),
                  _imageUser(),
                  Padding(padding: EdgeInsets.all(30)),
                  _userNameInputBox(),
                  Padding(padding: EdgeInsets.all(10)),
                  _emailInputBox(),
                  Padding(padding: EdgeInsets.all(10)),
                  _passInputBox(),
                  Padding(padding: EdgeInsets.all(30)),
                  _registerButton(),
                  Padding(padding: EdgeInsets.all(15)),
                  _backButton(),
                ])),
          ),
        ),
      ),
    );
  }

  _imageUser() {
    if (imagen == null) {
      return Padding(
        padding: const EdgeInsets.only(left: 110),
        child: Row(
          children: <Widget>[
            Container(
              width: 140,
              height: 140,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      fit: BoxFit.fill, image: AssetImage('assets/user.png'))),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 80, left: 0),
              child: ElevatedButton(
                onPressed: () {
                  seleccionarImagen(context);
                },
                child: FaIcon(
                  FontAwesomeIcons.plusCircle,
                  size: 20,
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(0),
                  primary: Colors.black,
                  shape: CircleBorder(),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(left: 110),
        child: Row(
          children: <Widget>[
            Container(
              width: 140,
              height: 140,
              decoration: new BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1),
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                      fit: BoxFit.cover, image: FileImage(imagen!))),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 80, left: 0),
              child: ElevatedButton(
                onPressed: () {
                  seleccionarImagen(context);
                },
                child: FaIcon(
                  FontAwesomeIcons.plusCircle,
                  size: 20,
                ),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(0),
                  primary: Colors.black,
                  shape: CircleBorder(),
                ),
              ),
            ),
          ],
        ),
      );
    }
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
            onSaved: (value) {
              user.name = value!;
            },
            validator: (value) => valName(value!)));
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
            onSaved: (value) {
              user.email = value!;
            },
            validator: (value) => valEmail(value!)));
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
            validator: (value) => valPass(value!)));
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
        onPressed: () async {
          //validacion del key del formulario
          if (!_formKey.currentState!.validate()) {
            return;
          }
          _formKey.currentState!.save();
          user.id = genId();
          if (imagen != null) {
            user.imgUrl = await uploadImgToFireStore(user.id!, imagen!);
          } else {
            user.imgUrl = 'null';
          }
          registerUser(context, user);
        },
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

  seleccionarImagen(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      _getImage(1);
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 1))),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            'Cámara',
                            style: TextStyle(fontSize: 15),
                          )),
                          Icon(FontAwesomeIcons.camera)
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _getImage(2);
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 1))),
                      child: Row(
                        children: [
                          Expanded(
                              child: Text(
                            'Galería',
                            style: TextStyle(fontSize: 15),
                          )),
                          Icon(FontAwesomeIcons.solidFileImage)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _getImage(op) async {
    var pickedFile;
    if (op == 1) {
      pickedFile = await picker.getImage(source: ImageSource.camera);
    } else {
      pickedFile = await picker.getImage(source: ImageSource.gallery);
    }
    setState(() {
      if (pickedFile != null) {
        imagen = File(pickedFile.path);
      }
      Navigator.pop(context);
    });
  }
}
