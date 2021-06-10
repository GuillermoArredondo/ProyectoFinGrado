import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forumdroid/models/user_model.dart';
import 'package:forumdroid/pages/post_detail.dart';
import 'package:forumdroid/theme/app_theme.dart';
import 'package:forumdroid/utils/firestore.dart';
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
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => MyProfile()));
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
          padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Color.fromRGBO(226, 247, 255, 1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black, width: 1)),
                child: Column(
                  children: [_buildRowF(), _buildRowS()],
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 5)),
              _buildList()
            ],
          ),
        ));
  }

  _buildRowF() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
          child: FutureBuilder<String>(
            future: getUrlPrefs(),
            builder: (context, snapshot) {
              if ((snapshot.hasData) && (snapshot.data != 'null')) {
                return Container(
                    width: 45,
                    height: 45,
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
                        style: TextStyle(fontSize: 20),
                      );
                    }
                    return CircularProgressIndicator();
                  },
                ),
                radius: 22,
              );
            },
          ),
        ),
        Container(
            padding: EdgeInsets.fromLTRB(10, 10, 0, 0),
            child: FutureBuilder<String>(
              future: getNamePrefs(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data!,
                    style: _thisTextStyle(),
                  );
                }
                return CircularProgressIndicator();
              },
            )),
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

  _buildRowS() {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(15, 20, 0, 10),
          child: FutureBuilder<int>(
            future: getNumPosts(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Text(snapshot.data.toString() + ' Posts',
                    style: TextStyle(fontSize: 15));
              }
              return CircularProgressIndicator();
            },
          ),
        ),
        Container(
          padding: EdgeInsets.fromLTRB(200, 20, 0, 10),
          child: Text(
            '0 Seguidores',
            style: TextStyle(fontSize: 15),
          ),
        ),
      ],
    );
  }

  _buildList() {
    return FutureBuilder<String>(
      future: getIdUserPrefs(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').where('idUser', isEqualTo: snapshot.data).orderBy('fecha', descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return _buildListview(snapshot);
          }
        },
      );
      }
        return CircularProgressIndicator();
      },
    );
  }

  _buildListview(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    return Container(
      height: 578,
      child: Expanded(
        child: ListView(
          children: snapshot.data!.docs.map((document) {
            return Center(
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.all(10),
                      child: _bluidItem(document)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5, bottom: 10),
                        child: Icon(
                          FontAwesomeIcons.solidHeart,
                          size: 15,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 30, bottom: 10),
                        child: Text(
                            List.from(document['listVotos']).length.toString()),
                      )
                    ],
                  )
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  _bluidItem(QueryDocumentSnapshot<Object?> document) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => PostDetail(document)));
      },
      child: Container(
          width: 360,
          height: 265,
          child: Padding(
            padding: const EdgeInsets.only(left: 10, top: 10),
            child: _buildContainer(document),
          ),
          decoration: BoxDecoration(
              color: Color.fromRGBO(226, 247, 255, 1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black, width: 1))),
    );
  }

  _buildContainer(QueryDocumentSnapshot<Object?> document) {
    return Container(
      child: Column(
        children: [
          _buildRow1(document),
          _buildRow2(document),
          _buildRow3(document),
          _buildRow4(document)
        ],
      ),
    );
  }

  _buildRow1(QueryDocumentSnapshot<Object?> document) {
    return Row(
      children: [
        Container(
          //width: 20,
          child: Padding(
            padding: const EdgeInsets.only(left: 0),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 77,
                      //alignment: Alignment.topRight,
                      child: Text(
                        document['fecha'],
                        style: _buildTextStyle(15.0, false),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Container(
          width: 250,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(190, 0, 0, 0),
                    child: InkWell(
                      child: Icon(FontAwesomeIcons.edit),
                      onTap: (){
                        
                      },
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      child: InkWell(
                      child: Icon(FontAwesomeIcons.trashAlt),
                      onTap: (){
                        alertOptions(
                          context,
                          'Eliminar',
                          '¿Estás seguro que quieres eliminar esta publicación?',
                          document.id
                        );
                      },
                    )
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  _buildRow2(QueryDocumentSnapshot<Object?> document) {
    return Row(
      children: [
        Container(
            padding: EdgeInsets.fromLTRB(0, 40, 0, 0),
            child: Text(
              document['title'],
              style: _buildTextStyle(17.0, false),
            ))
      ],
    );
  }

  _buildRow3(QueryDocumentSnapshot<Object?> document) {
    return Row(
      children: [
        Container(
            width: 325,
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: _textContent(document))
      ],
    );
  }

  _buildRow4(QueryDocumentSnapshot<Object?> document) {
    List<String> tags = List.from(document['listHastags']);
    return Row(
      children: [
        Container(
          alignment: Alignment.bottomLeft,
          width: 330,
          margin: EdgeInsets.fromLTRB(10, 20, 0, 0),
          height: 40.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (context, i) {
              return _buildRowTag(tags[i]);
            },
            itemCount: tags.length,
          ),
        ),
      ],
    );
  }

  _buildRowTag(String tag) {
    return Container(
        margin: EdgeInsets.only(left: 5),
        width: 100,
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Center(child: Text(tag)),
          ),
        ),
        decoration: BoxDecoration(
            color: Color.fromRGBO(226, 236, 255, 1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black, width: 1)));
  }

  _textContent(QueryDocumentSnapshot<Object?> document) {
    if (document['content'].toString().length > 151) {
      return Text(
        document['content'].toString().substring(0, 215) + '...',
        style: _buildTextStyle(14.0, false),
      );
    } else {
      return Text(
        document['content'],
        style: _buildTextStyle(15.0, false),
      );
    }
  }

  _buildTextStyle(size, bold) {
    if (bold) {
      return TextStyle(fontSize: size, fontWeight: FontWeight.bold);
    } else {
      return TextStyle(
        fontSize: size,
      );
    }
  }

  _thisTextStyle() {
    return TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
  }
}
