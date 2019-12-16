import 'package:flutter/material.dart';
import 'package:instagram_thecodingpapa/constants/size.dart';
import 'package:instagram_thecodingpapa/data/user.dart';
import 'package:instagram_thecodingpapa/utils/profile_img_path.dart';
import 'package:instagram_thecodingpapa/widgets/comment.dart';

class CommentsPage extends StatefulWidget {
  final User user;

  const CommentsPage(this.user, {Key key}) : super(key: key);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  TextEditingController _commentsController = TextEditingController();

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Commenst'),
      ),
      body: Column(
        children: <Widget>[
          ListView.separated(
              itemBuilder: (context, index) {
                return Comment();
              },
              separatorBuilder: (context, index) {
                return Divider(
                  thickness: common_gap,
                );
              },
              itemCount: null),
          Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(
                  getProfileImgPath(widget.user.username),
                ),
                radius: profile_radius,
              ),
              Divider(
                thickness: common_gap,
              ),
              Expanded(
                child: TextFormField(
                  controller: _commentsController,
                  showCursor: true,
                  decoration: InputDecoration(
                    hintText: 'Add a comment...',
                    border: InputBorder.none,
                  ),
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Input something!!';
                    }
                    return null;
                  },
                ),
              ),
              Divider(
                thickness: common_gap,
              ),
              FlatButton(
                  onPressed: () {},
                  child: Text(
                    'Post',
                    style: Theme.of(context).textTheme.button,
                  ))
            ],
          )
        ],
      ),
    );
  }
}
