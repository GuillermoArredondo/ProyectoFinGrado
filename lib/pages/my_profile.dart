import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:forumdroid/pages/edit_profile.dart';
import 'package:forumdroid/utils/auth.dart';
import 'package:forumdroid/utils/general.dart';

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
              _buildButton('Editar Perfil', () => _buildRoute()),
              Padding(padding: EdgeInsets.only(top: 20)),
              _buildButton('Generar QR',
                  () => Navigator.of(context).pushReplacementNamed('generate_qr')),
              Padding(padding: EdgeInsets.only(top: 20)),
              _buildButton('Seguidores',
                  () {}),
              Padding(padding: EdgeInsets.only(top: 20)),
              _buildButton('Seguidos',
                  () {}),
              Padding(padding: EdgeInsets.only(top: 20)),
              _buildButton('Cerrar sesión', () => logOut(context)),
            ],
          ),
        ),
      ),
    );
  }

  _buildRoute() {
    getUserfromSharePrefs().then((value) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => EditProfile(value)));
    });
  }

  _imageUser() {
    return Container(
      child: FutureBuilder<String>(
        future: getUrlPrefs(),
        builder: (context, snapshot) {
          if ((snapshot.hasData) && (snapshot.data != 'null')) {
            return Container(
                width: 140,
                height: 140,
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        fit: BoxFit.cover,
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
    );
  }

  _buildName() {
    return FutureBuilder<String>(
      future: getNamePrefs(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(
            snapshot.data!,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
        if (snapshot.hasData && snapshot.data!.contains('@')) {
          return Text(
            snapshot.data!,
            style: TextStyle(
              fontSize: 18,
            ),
          );
        }
        return Text(
          'Email de twitter no disponible',
          style: TextStyle(fontSize: 16),
        );
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
            )
        )
    );
  }

}
