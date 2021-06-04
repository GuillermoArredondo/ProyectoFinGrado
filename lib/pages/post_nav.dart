import 'package:flutter/material.dart';

class Post extends StatefulWidget {

  @override
  _PostState createState() => _PostState();
}

class _PostState extends State<Post> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(50),
                child: Container(
                  
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(226, 247, 255, 1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black, width: 1)
                    
                  ),
                  child: Text('prueba'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}