
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:forumdroid/utils/firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class PostDetail extends StatefulWidget {

  QueryDocumentSnapshot<Object?> document;

  PostDetail(this.document);

  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        centerTitle: true,
      ),
      body: 
         Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(226, 247, 255, 1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 1)),
                child: _buildContainer(),
              ),
              Padding(padding: EdgeInsets.only(top: 10)),
              Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(226, 247, 255, 1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black, width: 1)),
                child: _buildListLinks(),
              ),
              //_buildListLinks()
            ],
          ),
        ),
      
    );
  }

  _buildContainer(){
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
            padding: const EdgeInsets.only(left: 77),
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
            color: Color.fromRGBO(226, 236, 255 , 1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.black, width: 1)));
  }


  _buildListLinks(){
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
              child: Text('Enlaces:', style: _buildTextStyle(16.0, true),)
            ),
          ),
          _buildList(links)
        ],
      )
    );
  }

  _buildList(List<String> links){
    return Container(
      height: links.length * 50.0,
      width: 360,
      child: ListView.builder(
            itemBuilder: (context, i){
              return _buildRowLink(links[i]);
            },
            itemCount: links.length,
          ),
    );
  }


  _buildRowLink(String link){
    return ListTile(
        title: Text(link, style: TextStyle(color: Colors.blue),),
        //trailing: new Icon(FontAwesomeIcons.trash),
        onTap: () async {
          if(await canLaunch('https://'+link)){
            await launch('https://'+link);
          }else{
            print('NO');
          }

        },
    );
  }


  _textContent(QueryDocumentSnapshot<Object?> document) {
      return Text(
        document['content'],
        style: _buildTextStyle(15.0, false),
      ); 
  }

  _buildHeight(QueryDocumentSnapshot<Object?> document){
    if(document['content'].toString().length < 100){
      return 205.0;
    }else{
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