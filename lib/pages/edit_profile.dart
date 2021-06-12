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

class EditProfile extends StatefulWidget {
  var user = UserModel();

  EditProfile(this.user);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  final _formKey = GlobalKey<FormState>();
  final user = UserModel();
  File? imagen;
  String? urlImagen;
  final picker = ImagePicker();
  String? idUser;
  var userTest = UserModel();

  @override
  initState() {
    userTest = this.widget.user;
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
                    children: <Widget>[
                      _imageUser(),
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
    if (imagen == null) {
      return Padding(
        padding: const EdgeInsets.only(left: 110),
        child: Row(
          children: <Widget>[
            FutureBuilder<String>(
              future: getUrlPrefs(),
              builder: (context, snapshot) {
                if ((snapshot.hasData) && (snapshot.data != 'null')) {
                  return Container(
                      width: 140,
                      height: 140,
                      decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                              fit: BoxFit.fill,
                              image: new NetworkImage(snapshot.data!))));
                }
                return CircleAvatar(
                  child: FutureBuilder<String>(
                    future: getIconPrefs(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          snapshot.data!,
                          style: TextStyle(fontSize: 50),
                        );
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                  radius: 65,
                );
              },
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
                      fit: BoxFit.fill, image: FileImage(imagen!))),
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
      child: FutureBuilder<String>(
        future: getNamePrefs(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return TextFormField(
                decoration: InputDecoration(
                  hintText: "Nombre de usuario",
                  icon: Icon(FontAwesomeIcons.user, color: Colors.black),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0)),
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
                validator: (value) => valName(value!));
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
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0)),
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
                  validator: (value) => valEmail(value!));
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              minimumSize: new Size(190, 50)),
          child: Text(
            'Guardar',
            style: new TextStyle(fontSize: 19),
          ),
          onPressed: () async {
            //validacion del key del formulario
            if (!_formKey.currentState!.validate()) {
              return;
            }
            _formKey.currentState!.save();

            if (!userTest.media!) {
              if (imagen != null) {
                uploadImgToFireStore(userTest.idUser!, imagen!)
                    .then((value) {
                      user.imgUrl = value;
                      user.id = userTest.id;
                      user.idUser = userTest.idUser;
                      user.media = false;
                      editUser(context, user);
                      });
                
              } else {
                if(userTest.imgUrl != 'null'){
                  user.imgUrl = userTest.imgUrl;
                }else{
                  user.imgUrl = 'null';
                }
                user.id = userTest.id;
                user.idUser = userTest.idUser;
                user.media = false;
                editUser(context, user);
              }
            } else {
              alert(context, 'Error',
                  'No puedes editar tu perfil si has accedido con una red social');
            }
          }),
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
