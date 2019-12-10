import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/tag.dart';
import 'package:instagram_thecodingpapa/constants/size.dart';
import 'package:instagram_thecodingpapa/data/post.dart';
import 'package:instagram_thecodingpapa/data/user.dart';
import 'package:instagram_thecodingpapa/firebase/firebase_storage.dart';
import 'package:instagram_thecodingpapa/firebase/firestore_provider.dart';
import 'package:instagram_thecodingpapa/isolates/resize_image.dart';
import 'package:instagram_thecodingpapa/utils/post_path.dart';
import 'package:instagram_thecodingpapa/widgets/my_progress_indicator.dart';
import 'package:instagram_thecodingpapa/widgets/share_switch.dart';

class SharePostPage extends StatefulWidget {
  final File imgFile;
  final String postKey;
  final User user;

  const SharePostPage(
      {Key key,
      @required this.imgFile,
      @required this.postKey,
      @required this.user})
      : super(key: key);

  @override
  _SharePostPageState createState() => _SharePostPageState();
}

class _SharePostPageState extends State<SharePostPage> {
  TextEditingController captionController = TextEditingController();
  bool _isImgProcessing = false;

  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        IgnorePointer(
          ignoring: _isImgProcessing,
          child: Scaffold(
            appBar: _appBar(),
            body: ListView(
              children: <Widget>[
                _thumbnailNCaption(),
                _divider,
                _sectionTitle(context, "Tag People"),
                _divider,
                _sectionTitle(context, "Add Location"),
                _divider,
                _addLocationTags(),
                _divider,
                _sectionTitle(context, "Also post to"),
                ShareSwitch(label: 'Facebook'),
                ShareSwitch(label: 'Twitter'),
                ShareSwitch(label: 'Tumblr'),
              ],
            ),
          ),
        ),
        Visibility(
          visible: _isImgProcessing,
          child: Container(
            color: Colors.black54,
            child: Center(
              child: MyProgressIndicator(),
            ),
          ),
        )
      ],
    );
  }

  void _uploadImageNCreateNewPost() async {
    setState(() {
      _isImgProcessing = true;
    });

    try {
      final File resized = await compute(getResizedImage, widget.imgFile);

      await storageProvider.uploadImg(resized, getImgPath(widget.postKey));

      final Map<String, dynamic> postData = Post.getMapForNewPost(
          widget.user.userKey,
          widget.user.username,
          widget.postKey,
          captionController.text);
      await firestoreProvider.createNewPost(widget.postKey, postData);
      setState(() {
        _isImgProcessing = false;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Widget _sectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: common_gap),
      child: Text(
        title,
        style: Theme.of(context).textTheme.subtitle,
      ),
    );
  }

  Divider get _divider => Divider(
        color: Colors.grey[200],
        thickness: 1,
      );

  Tags _addLocationTags() {
    List<String> _items = [
      "approval",
      "pigeon",
      "brown",
      "expenditure",
      "compromise",
      "citizen",
      "inspire",
      "relieve",
      "grave",
      "incredible",
      "invasion",
      "voucher",
      "girl",
      "relax",
      "problem",
      "queue",
      "aviation",
      "profile",
      "palace",
      "drive",
      "money",
      "revolutionary",
      "string",
      "detective",
      "follow",
      "text",
      "bet",
      "decade",
      "means",
      "gossip"
    ];
    return Tags(
      horizontalScroll: true,
      itemCount: _items.length,
      itemBuilder: (int index) {
        final item = _items[index];

        return ItemTags(
          key: Key(index.toString()),
          index: index,
          title: item,
          activeColor: Colors.grey[200],
          textActiveColor: Colors.black54,
          textStyle: TextStyle(
            fontSize: 13,
          ),
          borderRadius: BorderRadius.circular(3),
        );
      },
    );
  }

  AppBar _appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      title: Text("New Post"),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              _uploadImageNCreateNewPost();
            },
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
