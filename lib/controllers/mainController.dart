import 'package:flutter/material.dart';

class MainController{


  static void loading(BuildContext context) {
    showDialog(context: context, builder: (context) {
      return Center(child: CircularProgressIndicator(

      ),);
    },);
  }

  static void warningDialog(BuildContext context, Widget _title, Widget _content) {
    showDialog(context: context, builder: (context) {
      return AlertDialog(title: _title,
      content: _content,
      );
    },);
  }

  static void closeLoading(BuildContext context){
    Navigator.pop(context);
  }
  }

