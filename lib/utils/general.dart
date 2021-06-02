
import 'package:flutter/material.dart';
import 'package:forumdroid/theme/app_theme.dart';


//Muestra una alerta con su mensaje
void alert(BuildContext context, String titulo, String msg,
    [onPressed]) {
  showDialog(
      context: context,
      builder: (buildcontext) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(msg),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
              primary: app_theme.primaryColor,
              shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              minimumSize: new Size(70, 40)),
              onPressed: (){
                Navigator.pop(context);
                onPressed();
              },
              child: new Text('OK')
            )
          ],
          elevation: 20,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        );
      });
}