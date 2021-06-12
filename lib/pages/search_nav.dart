import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forumdroid/pages/post_nav.dart';
import 'package:forumdroid/pages/profile_nav.dart';
import 'package:forumdroid/utils/firestore.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:qrscan/qrscan.dart' as Scanner;

class Search extends StatefulWidget {

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  String _scanBarcode = 'Unknown';


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
          scanQR();
        },
        style: ElevatedButton.styleFrom(
            primary: Color.fromRGBO(226, 247, 255, 1),
            minimumSize: Size(270, 50),
            padding: EdgeInsets.all(0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              //side: BorderSide(color: Colors.black),
            )));
  }

  Future<void> scanQR() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
      getUserProfile(barcodeScanRes).then((value) {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Profile(true,value)));
      });

      
  }
}