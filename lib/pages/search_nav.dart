import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qrscan/qrscan.dart' as Scanner;

class Search extends StatefulWidget {

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              Padding(padding: EdgeInsets.all(20)),
              _buildButton()
            ],
          ),
        ),
      ),
    );
  }

  _buildButton() {
    return ElevatedButton.icon(
        label: Text('Leer QR',
            style: TextStyle(
              fontSize: 18,
              color: Colors.black,
            )),
        icon: Icon(
          FontAwesomeIcons.qrcode,
          color: Colors.black,
        ),
        onPressed: () {
          _leer();
        },
        style: ElevatedButton.styleFrom(
            primary: Color.fromRGBO(226, 247, 255, 1),
            minimumSize: Size(270, 50),
            padding: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(color: Colors.black),
            )));
  }

  _leer() async {
    String barcode = await Scanner.scan();
    print(barcode);
  }
}