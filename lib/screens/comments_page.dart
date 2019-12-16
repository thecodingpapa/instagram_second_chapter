import 'package:flutter/material.dart';
import 'package:instagram_thecodingpapa/constants/size.dart';
import 'package:instagram_thecodingpapa/data/comment.dart';
import 'package:instagram_thecodingpapa/data/user.dart';
import 'package:instagram_thecodingpapa/firebase/firestore_provider.dart';
import 'package:instagram_thecodingpapa/utils/profile_img_path.dart';
import 'package:instagram_thecodingpapa/widgets/comment.dart';
import 'package:provider/provider.dart';

class CommentsPage extends StatefulWidget {
  final User user;
  final String postKey;

  const CommentsPage(
    this.user,
    this.postKey, {
    Key key,
  }) : super(key: key);

  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  TextEditingController _commentsController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void dispose() {
    _commentsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamProvider.value(
                value: firestoreProvider.fetchAllComments(widget.postKey),
                child: Consumer<List<CommentModel>>(
                  builder: (context, commentList, child) {
                    return ListView.separated(
                        itemBuilder: (context, index) {
                          CommentModel comment = commentList[index];
                          return Comment(
                            username: comment.username,
                            showProfile: true,
                            dateTime: comment.commenttime,
                            caption: comment.comment,
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            thickness: common_gap,
                          );
                        },
                        itemCount:
                            commentList == null ? 0 : commentList.length);
                  },
                ),
              ),
            ),
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
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        firestoreProvider.createNewComment(
                            widget.postKey,
                            CommentModel.getMapForNewComment(
                                widget.user.userKey,
                                widget.user.username,
                                _commentsController.text));
                      }
                    },
                    child: Text(
                      'Post',
                      style: Theme.of(context).textTheme.button,
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
