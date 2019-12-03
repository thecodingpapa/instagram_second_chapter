import 'dart:io';
import 'package:flutter/material.dart';
import 'package:instagram_thecodingpapa/constants/size.dart';

class SharePostPage extends StatefulWidget {
  final File imgFile;
  final String postKey;

  const SharePostPage({Key key, @required this.imgFile, this.postKey})
      : super(key: key);

  @override
  _SharePostPageState createState() => _SharePostPageState();
}

class _SharePostPageState extends State<SharePostPage> {
  TextEditingController captionController = TextEditingController();

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: ListView(
        children: <Widget>[
          _thumbnailNCaption(),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text("New Post"),
      actions: <Widget>[
        FlatButton(
            onPressed: null,
            child: Text(
              "Share",
              textScaleFactor: 1.4,
              style: TextStyle(
                color: Colors.blue,
              ),
            )),
      ],
    );
  }

  Row _thumbnailNCaption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(common_gap),
          child: Image.file(
            widget.imgFile,
            width: size.width / 6,
            height: size.width / 6,
            fit: BoxFit.cover,
          ),
        ),
        Expanded(
          child: TextField(
            controller: captionController,
            autofocus: true,
            decoration: InputDecoration(
                border: InputBorder.none, hintText: 'Write a caption...'),
          ),
        )
      ],
    );
  }
}
