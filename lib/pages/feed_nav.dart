import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forumdroid/utils/firestore.dart';
import 'package:forumdroid/utils/general.dart';

class Feed extends StatefulWidget {
  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Publicaciones'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return _buildListview(snapshot);
          }
        },
      ),
    );
  }

  _buildListview(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    return ListView(
      children: snapshot.data!.docs.map((document) {
        return Center(
          child: Padding(
              padding: const EdgeInsets.all(10), child: _bluidItem(document)),
        );
      }).toList(),
    );
  }

  _bluidItem(QueryDocumentSnapshot<Object?> document) {
    return InkWell(
      onTap: () {
        print(document['title']);
      },
      child: Container(
          width: 360,
          height: 220,
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
          //_buildRow2(document),
          //_buildRow3(document),
          //_buildRow4(document)
        ],
      ),
    );
  }

  _buildRow1(QueryDocumentSnapshot<Object?> document) {
    return Row(
      children: [
        Container(
          width: 180,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: FutureBuilder<String>(
                      future: getUserImage(document['idUser']),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
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
                            future: getUserNameById(document['idUser']),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Text(
                                  snapshot.data!.substring(0, 1),
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
                  Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                  child: FutureBuilder<String>(
                    future: getUserNameById(document['idUser']),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(
                          snapshot.data!,
                          style: _buildTextStyle(17.0, true),
                        );
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                ),
                )
                ],
              ),
              
            ],
          ),
        ),
        Container(
          //width: 20,
            child: Padding(
              padding: const EdgeInsets.only(left: 77),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 77,
                        //alignment: Alignment.topRight,
                        child: Text(document['fecha'], style: _buildTextStyle(15.0, false),),
                      ),
                    ],
                  )
                ],
              ),
            ),
        
        )
      ],
    );
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
}
