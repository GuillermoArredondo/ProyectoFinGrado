import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forumdroid/models/post_model.dart';
import 'package:forumdroid/theme/app_theme.dart';
import 'package:forumdroid/utils/firestore.dart';
import 'package:forumdroid/utils/general.dart';
import 'package:forumdroid/utils/validations.dart';
import 'package:intl/intl.dart';

class Post extends StatefulWidget {
  bool? edit;
  QueryDocumentSnapshot<Object?>? document;
  Post(this.edit, [this.document]);
  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  final _formKey = GlobalKey<FormState>();
  final _LinksKey = GlobalKey<FormState>();
  final _TagsKey = GlobalKey<FormState>();
  final post = PostModel();
  final _controllerEnlaces = TextEditingController();
  final _controllerTags = TextEditingController();
  final _controllerTitle = TextEditingController();
  final _controllerContent = TextEditingController();

  List<String> listaEnlaces = [];
  List<String> listaHashTags = [];

  @override
  void initState() {
    if (widget.edit!) {
      print(widget.document!.id);
      _controllerTitle.text = widget.document!['title'];
      _controllerContent.text = widget.document!['content'];
      listaEnlaces = List<String>.from(widget.document!['listEnlaces']);
      listaHashTags = List<String>.from(widget.document!['listHastags']);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildAppBar(),
        centerTitle: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Center(
              child: Column(
                children: [
                  _buildTitle(),
                  _buildContent(),
                  _buildEnlaces(),
                  _buildListEnlaces(),
                  _buildHashTags(),
                  _buildListHashtags(),
                  _buildSaveButton()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildTitle() {
      return Padding(
        padding: EdgeInsets.all(7),
        child: TextFormField(
            controller: _controllerTitle,
            decoration: InputDecoration(
              fillColor: Colors.blueGrey,
              hintText: "Título de la publicación",
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
              post.titulo = value!;
            },
            validator: (value) => valTitle(value!)),
      );
    
  }

  _buildContent() {
    return Padding(
      padding: EdgeInsets.all(7),
      child: TextFormField(
          controller: _controllerContent,
          maxLines: 10,
          minLines: 5,
          decoration: InputDecoration(
            fillColor: Colors.blueGrey,
            hintText: "Contenido",
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
            post.contenido = value!;
          },
          validator: (value) => valContent(value!)),
    );
  }

  _buildEnlaces() {
    return Padding(
      padding: EdgeInsets.all(7),
      child: Row(
        children: [
          Flexible(
            child: TextFormField(
              controller: _controllerEnlaces,
              decoration: InputDecoration(
                fillColor: Colors.blueGrey,
                hintText: "Nuevo enlace",
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
              onSaved: (value) {
                //post.titulo = value!;
              },
              //validator: (value) => valName(value!)
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 5)),
          ElevatedButton(
            onPressed: () {
              setState(() {
                listaEnlaces.add(_controllerEnlaces.text);
                _controllerEnlaces.text = '';
              });
            },
            child: FaIcon(
              FontAwesomeIcons.plusCircle,
              size: 25,
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(10),
              primary: Colors.black,
              shape: CircleBorder(),
            ),
          ),
        ],
      ),
    );
  }

  _buildListEnlaces() {
    return Padding(
        padding: EdgeInsets.all(7),
        child: Container(
          decoration: BoxDecoration(
              //color: Color.fromRGBO(226, 247, 255, 1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black, width: 2)),
          height: 120,
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return Divider();
            },
            itemBuilder: (context, i) {
              return _buildRowEnlace(listaEnlaces[i]);
            },
            itemCount: listaEnlaces.length,
          ),
        ));
  }

  _buildRowEnlace(String row) {
    return ListTile(
      title: Text(row),
      trailing: new Icon(FontAwesomeIcons.trash),
      onTap: () {
        setState(() {
          listaEnlaces.remove(row);
        });
      },
    );
  }

  _buildHashTags() {
    return Padding(
      padding: EdgeInsets.all(7),
      child: Row(
        children: [
          Flexible(
            child: TextFormField(
              controller: _controllerTags,
              decoration: InputDecoration(
                fillColor: Colors.blueGrey,
                hintText: "Nuevo Hashtag",
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
              onSaved: (value) {
                //post.titulo = value!;
              },
              //validator: (value) => valName(value!)
            ),
          ),
          Padding(padding: EdgeInsets.only(left: 5)),
          ElevatedButton(
            onPressed: () {
              setState(() {
                listaHashTags.add('#' + _controllerTags.text);
                _controllerTags.text = '';
              });
            },
            child: FaIcon(
              FontAwesomeIcons.plusCircle,
              size: 25,
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(10),
              primary: Colors.black,
              shape: CircleBorder(),
            ),
          ),
        ],
      ),
    );
  }

  _buildListHashtags() {
    return Padding(
        padding: EdgeInsets.all(7),
        child: Container(
          decoration: BoxDecoration(
              //color: Color.fromRGBO(226, 247, 255, 1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black, width: 2)),
          height: 120,
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return Divider();
            },
            itemBuilder: (context, i) {
              return _buildRowHashtag(listaHashTags[i]);
            },
            itemCount: listaHashTags.length,
          ),
        ));
  }

  _buildRowHashtag(String row) {
    return ListTile(
      title: Text(row),
      trailing: new Icon(FontAwesomeIcons.trash),
      onTap: () {
        setState(() {
          listaHashTags.remove(row);
        });
      },
    );
  }

  _buildSaveButton() {
    if(widget.edit!){
      return Padding(
      padding: const EdgeInsets.all(7),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: app_theme.primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            minimumSize: new Size(190, 50)),
        child: Text(
          'Guardar',
          style: new TextStyle(fontSize: 19),
        ),
        onPressed: () async {
          if (!_formKey.currentState!.validate()) {
            return;
          }
          _formKey.currentState!.save();

          post.enlaces = listaEnlaces;
          post.hashtags = listaHashTags;

          final DateTime now = DateTime.now();
          final DateFormat formatter = DateFormat('dd-MM-yyyy');
          final String formatted = formatter.format(now);
          post.fecha = formatted;
          await editPost(context, widget.document!, post);
           //alert(
           //    context, 'Éxito', 'La publicación se ha modificado correctamente', (){Navigator.pop(context);});
          
          //_resetAll();
          //Navigator.pop(context);
        },
      ),
    );
    }else{
      return Padding(
      padding: const EdgeInsets.all(7),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            primary: app_theme.primaryColor,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            minimumSize: new Size(190, 50)),
        child: Text(
          'Publicar',
          style: new TextStyle(fontSize: 19),
        ),
        onPressed: () async {
          if (!_formKey.currentState!.validate()) {
            return;
          }
          _formKey.currentState!.save();

          post.enlaces = listaEnlaces;
          post.hashtags = listaHashTags;

          final DateTime now = DateTime.now();
          final DateFormat formatter = DateFormat('dd-MM-yyyy');
          final String formatted = formatter.format(now);
          post.fecha = formatted;
          await addNewPost(post);
          alert(
              context, 'Éxito', 'La publicación se ha realizado correctamente');
          _resetAll();
        },
      ),
    );
    }
  }

  _resetAll() {
    setState(() {
      _controllerTitle.text = '';
      _controllerContent.text = '';
      listaEnlaces.clear();
      listaHashTags.clear();
    });
  }

  _buildAppBar() {
    if (widget.edit!) {
      return Text('Editar publicacion');
    } else {
      return Text('Publicar');
    }
  }
}
