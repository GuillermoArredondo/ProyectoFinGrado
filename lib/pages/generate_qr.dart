import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forumdroid/utils/general.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerateQR extends StatefulWidget {
  @override
  _GenerateQRState createState() => _GenerateQRState();
}

class _GenerateQRState extends State<GenerateQR> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generar QR'),
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
              Padding(padding: EdgeInsets.only(top: 30)),
              _buildQR(),
              Padding(padding: EdgeInsets.only(top: 30)),
              //_buildShare()
            ],
          ),
        ),
      ),
    );
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

  _buildQR() {
    return FutureBuilder<String>(
      future: getIdUserPrefs(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(226, 236, 255, 1),
              borderRadius: BorderRadius.circular(20),
              //border: Border.all(color: Colors.black, width: 1)
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            height: 300,
            width: 300,
            child: QrImage(
              data: snapshot.data!,
            ),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }

  // _buildShare() {
  //   return ElevatedButton.icon(
  //       label: Text('Compartir',
  //           style: TextStyle(
  //             fontSize: 18,
  //             color: Colors.black,
  //           )),
  //       icon: Icon(
  //         FontAwesomeIcons.shareAlt,
  //         color: Colors.black,
  //       ),
  //       onPressed: () {
  //         screenShotAndShare();
  //       },
  //       style: ElevatedButton.styleFrom(
  //           primary: Color.fromRGBO(226, 247, 255, 1),
  //           minimumSize: Size(270, 50),
  //           padding: EdgeInsets.all(0),
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(15),
  //             side: BorderSide(color: Colors.black),
  //           )));
  // }

  // screenShotAndShare() async {}
}
