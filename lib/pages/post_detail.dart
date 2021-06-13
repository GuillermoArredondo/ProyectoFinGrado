import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forumdroid/utils/firestore.dart';
import 'package:forumdroid/utils/general.dart';
import 'package:url_launcher/url_launcher.dart';

class PostDetail extends StatefulWidget {
  QueryDocumentSnapshot<Object?> document;

  PostDetail(this.document);

  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  bool voted = false;
  @override
  void initState() {
    _setVoteInit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(226, 247, 255, 1),
                borderRadius: BorderRadius.circular(20),
                //border: Border.all(color: Colors.black, width: 1),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: _buildContainer(),
            ),
            Padding(padding: EdgeInsets.only(top: 10)),
            Container(
              decoration: BoxDecoration(
                color: Color.fromRGBO(226, 247, 255, 1),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              //border: Border.all(color: Colors.black, width: 1)),
              child: _buildListLinks(),
            ),
            Padding(padding: EdgeInsets.only(top: 20)),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(35, 0, 0, 0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(226, 247, 255, 1),
                          minimumSize: Size(200, 50),
                          padding: EdgeInsets.all(0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            //side: BorderSide(color: Colors.black),
                          )),
                      onPressed: () {},
                      child: Text('Comentarios',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ))),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(50, 0, 0, 0),
                  child: InkWell(
                    onTap: () {
                      _vote();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Color.fromRGBO(226, 247, 255, 1),
                          borderRadius: BorderRadius.circular(20),
                          //border: Border.all(color: Colors.black, width: 1)
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 2,
                              offset: Offset(0, 3),
                            ),
                          ]),
                      child: _checkVoted(),
                    ),
                  ),
                )
              ],
            )
            //_buildListLinks()
          ],
        ),
      ),
    );
  }

  _buildContainer() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, top: 10),
      child: Container(
        height: _buildHeight(widget.document),
        width: 500,
        child: Column(
          children: [
            _buildRow1(widget.document),
            _buildRow2(widget.document),
            _buildRow3(widget.document),
            _buildRow4(widget.document)
          ],
        ),
      ),
    );
  }

  _buildRow1(QueryDocumentSnapshot<Object?> document) {
    return Row(
      children: [
        Container(
          width: 214,
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
                                      fit: BoxFit.cover,
                                      image:
                                          new NetworkImage(snapshot.data!))));
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
            padding: const EdgeInsets.only(left: 52),
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
        )
      ],
    );
  }

  _buildRow2(QueryDocumentSnapshot<Object?> document) {
    return Row(
      children: [
        Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
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
            //border: Border.all(color: Colors.black, width: 1)
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ]));
  }

  _buildListLinks() {
    List<String> links = List.from(widget.document['listEnlaces']);
    return Container(
        width: 500,
        height: links.length * 79,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Enlaces:',
                    style: _buildTextStyle(16.0, true),
                  )),
            ),
            _buildList(links)
          ],
        ));
  }

  _buildList(List<String> links) {
    return Container(
      height: _buildHeightListLinks(links),
      width: 360,
      child: ListView.builder(
        itemBuilder: (context, i) {
          return _buildRowLink(links[i]);
        },
        itemCount: links.length,
      ),
    );
  }

  _buildHeightListLinks(List<String> links) {
    if (links.length <= 1) {
      return 40.0;
    } else {
      return links.length * 55.0;
    }
  }

  _buildRowLink(String link) {
    return ListTile(
      title: Text(
        link,
        style: TextStyle(color: Colors.blue),
      ),
      onTap: () async {
        if (await canLaunch('https://' + link)) {
          await launch('https://' + link);
        } else {
          
        }
      },
    );
  }

  _checkVoted() {
    if (voted) {
      voted = false;
      return Icon(FontAwesomeIcons.solidHeart);
    } else {
      voted = true;
      return Icon(FontAwesomeIcons.heart);
    }
  }

  _vote() async {
    await getIdUserPrefs().then((value) async {
      if (await searchVote(value, widget.document)) {
        setState(() {
          
        });
        quitarVoto(value, widget.document);
      } else {
        ponerVoto(value, widget.document);
        setState(() {
          
        });
      }
    });
  }

  _setVoteInit() async {
    await getIdUserPrefs().then((value) async {
      if (await searchVote(value, widget.document)) {
        setState(() {
          voted = true;
        });
      } else {
        setState(() {
          voted = false;
        });
      }
    });
  }

  _textContent(QueryDocumentSnapshot<Object?> document) {
    return Text(
      document['content'],
      style: _buildTextStyle(15.0, false),
    );
  }

  _buildHeight(QueryDocumentSnapshot<Object?> document) {
    var doc = document['content'].toString().length;
    if (doc < 100) {
      return 205.0;
    } else if (doc > 100 && doc < 150) {
      return document['content'].toString().length * 1.85;
    } else if (doc > 150 && doc < 200) {
      return document['content'].toString().length * 1.62;
    }else if(doc >= 200 && doc < 300){
      return document['content'].toString().length * 1.15;
    } else {
      return document['content'].toString().length * 0.75;
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
}
