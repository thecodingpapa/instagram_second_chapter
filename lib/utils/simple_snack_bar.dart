import 'package:flutter/material.dart';

void simpleSnackbar(BuildContext context, String txt){
  final snackBar = SnackBar(content: Text(txt));
  Scaffold.of(context).showSnackBar(snackBar);
}