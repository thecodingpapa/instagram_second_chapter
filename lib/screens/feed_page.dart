import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:instagram_thecodingpapa/constants/size.dart';
import 'package:instagram_thecodingpapa/data/post.dart';
import 'package:instagram_thecodingpapa/data/provider/my_user_data.dart';
import 'package:instagram_thecodingpapa/firebase/firestore_provider.dart';
import 'package:instagram_thecodingpapa/screens/comments_page.dart';
import 'package:instagram_thecodingpapa/utils/profile_img_path.dart';
import 'package:instagram_thecodingpapa/widgets/comment.dart';
import 'package:instagram_thecodingpapa/widgets/my_progress_indicator.dart';
import 'package:instagram_thecodingpapa/firebase/firebase_storage.dart';
import 'package:path/path.dart' as prefix0;
import 'package:provider/provider.dart';

class FeedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Post>>.value(
      value: firestoreProvider.fetchAllPostFromFollowers(
          Provider.of<MyUserData>(context).data.followings),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: null,
              icon: ImageIcon(
                AssetImage('assets/actionbar_camera.png'),
                color: Colors.black,
              )),
          title: Image.asset(
            'assets/insta_text_logo.png',
            height: 26,
          ),
          actions: <Widget>[
            IconButton(
                onPressed: () {
//                firestoreProvider.sendData().then((_) {
//                  print('data sent to firestore!');
//                });
                },
                icon: ImageIcon(
                  AssetImage('assets/actionbar_camera.png'),
                  color: Colors.black,
                )),
            IconButton(
                onPressed: () {
//                firestoreProvider.getData();
                },
                icon: ImageIcon(
                  AssetImage('assets/direct_message.png'),
                  color: Colors.black,
                )),
          ],
        ),
        body: Consumer<List<Post>>(
          builder: (context, postList, child) {
            return ListView.builder(
                itemCount: postList == null ? 0 : postList.length,
                itemBuilder: (BuildContext context, int index) {
                  Post post = postList[index];
                  return _postItem(post, context);
                });
          },
        ),
      ),
    );
  }

  Column _postItem(Post post, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _postHeader(post.username),
        _postImage(post.postUri),
        _postActions(post.postKey),
        _postLikes(),
        _postCaption(context, post),
        _allComments(post)
      ],
    );
  }

  Widget _allComments(Post post) => Visibility(
        visible: post.numOfComments > 0 && post.numOfComments != null,
        child: Consumer<MyUserData>(
          builder: (context, myUserData, child) {
            return FlatButton(
                onPressed: () {
                  _goToComments(context, myUserData, post.postKey);
                },
                child: Text(
                  'show all ${post.numOfComments} comments',
                  style: TextStyle(color: Colors.grey[600]),
                ));
          },
        ),
      );

  Padding _postCaption(BuildContext context, Post post) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: common_gap, vertical: common_xs_gap),
      child: Comment(
        username: post.lastCommentor,
        caption: 'I love summer soooooooooooooo much~~~~~~~~~~!!!!',
      ),
    );
  }

  Padding _postLikes() {
    return Padding(
      padding: const EdgeInsets.only(left: common_gap),
      child: Text(
        '80 likes',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Row _postActions(String postKey) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: ImageIcon(
            AssetImage('assets/bookmark.png'),
            color: Colors.black87,
          ),
          onPressed: null,
        ),
        Consumer<MyUserData>(
          builder: (context, myUserData, child) {
            return IconButton(
              icon: ImageIcon(
                AssetImage('assets/comment.png'),
                color: Colors.black87,
              ),
              onPressed: () {
                _goToComments(context, myUserData, postKey);
              },
            );
          },
        ),
        IconButton(
          icon: ImageIcon(
            AssetImage('assets/direct_message.png'),
            color: Colors.black87,
          ),
          onPressed: null,
        ),
        Spacer(),
        IconButton(
          icon: ImageIcon(
            AssetImage('assets/heart_selected.png'),
            color: Colors.redAccent,
          ),
          onPressed: null,
        ),
      ],
    );
  }

  _goToComments(BuildContext context, MyUserData myUserData, String postKey) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return CommentsPage(myUserData.data, postKey);
    }));
  }

  Row _postHeader(String username) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(common_gap),
          child: CircleAvatar(
            backgroundImage:
                CachedNetworkImageProvider(getProfileImgPath(username)),
            radius: profile_radius,
          ),
        ),
        Expanded(child: Text(username)),
        IconButton(
          icon: Icon(
            Icons.more_horiz,
            color: Colors.black87,
          ),
          onPressed: null,
        )
      ],
    );
  }

  Widget _postImage(String postUri) {
    return CachedNetworkImage(
      imageUrl: postUri,
      placeholder: (context, url) {
        return new MyProgressIndicator();
      },
      imageBuilder: (BuildContext context, ImageProvider imageProvider) =>
          AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover)),
        ),
      ),
    );
  }
}
