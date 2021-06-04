import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forumdroid/models/user_model.dart';
import 'package:forumdroid/theme/app_theme.dart';
import 'package:forumdroid/utils/general.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'my_profile.dart';

class Profile extends StatefulWidget {
  
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

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
          title: Text('Mi Perfil'),
          centerTitle: true,
          actions: [
            ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MyProfile()));
            },
            child: FaIcon(
              FontAwesomeIcons.cog,
              size: 20,
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(0),
              //primary: Colors.black,
              //shape: CircleBorder(),
            ),
          )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 580),
          child: Container(
            decoration: BoxDecoration(
                color: Color.fromRGBO(226, 247, 255, 1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black, width: 1)),
            child: Column(
              children: [_buildRow1(), _buildRow2()],
            ),
          ),
        ));
  }

  _buildRow1() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
          child: FutureBuilder<String>(
            future: getIconPrefs(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return CircleAvatar(child: new Text(snapshot.data!));
              }
              return CircularProgressIndicator();
            },

          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
          child: FutureBuilder<String>(
            future: getNamePrefs(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data!, style: _thisTextStyle(),);
              }
              return CircularProgressIndicator();
            },

          )
        ),
        // Container(
        //   alignment: Alignment.topRight,
        //   padding: EdgeInsets.fromLTRB(160, 10, 0, 0),
        //   child: ElevatedButton(
        //     onPressed: () {
        //       Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => MyProfile()));
        //     },
        //     child: FaIcon(
        //       FontAwesomeIcons.cog,
        //       size: 20,
        //     ),
        //     style: ElevatedButton.styleFrom(
        //       padding: EdgeInsets.all(0),
        //       primary: Colors.black,
        //       shape: CircleBorder(),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  _buildRow2() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(15, 30, 0, 0),
          child: Text('XX Seguidores', style: TextStyle(fontSize: 15)),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(180, 30, 0, 0),
          child: Text(
            'XX Posts',
            style: TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }

  _thisTextStyle() {
    return TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  }

}
