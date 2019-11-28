import 'dart:io';
import 'package:flutter/material.dart';

class SharePostPage extends StatefulWidget {
  final File imgFile;

  const SharePostPage({Key key, @required this.imgFile}) : super(key: key);

  @override
  _SharePostPageState createState() => _SharePostPageState();
}

class _SharePostPageState extends State<SharePostPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.file(widget.imgFile),
    );
  }
}
