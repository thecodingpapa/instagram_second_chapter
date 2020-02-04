import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_thecodingpapa/constants/firebase_keys.dart';

class Post {
  final String postKey;
  final String userKey;
  final String username;
  final String postImg;
  final String postUri;
  final List<dynamic> numOfLikes;
  final String caption;
  final String lastCommentor;
  final String lastComment;
  final DateTime lastCommentTime;
  final int numOfComments;
  final DateTime postTime;
  final DocumentReference reference;

  Post.fromMap(Map<String, dynamic> map, this.postKey, {this.reference})
      : userKey = map[KEY_USERKEY],
        username = map[KEY_USERNAME],
        postImg = map[KEY_POSTIMG],
        postUri = map[KEY_POSTURI],
        caption = map[KEY_CAPTION],
        lastComment = map[KEY_LASTCOMMENT],
        lastCommentor = map[KEY_LASTCOMMENTOR],
        lastCommentTime = map[KEY_LASTCOMMENTTIME] == null
            ? DateTime.now().toUtc()
            : (map[KEY_LASTCOMMENTTIME] as Timestamp).toDate(),
        numOfLikes = map[KEY_NUMOFLIKES],
        numOfComments = map[KEY_NUMOFCOMMENTS],
        postTime = (map[KEY_POSTTIME] as Timestamp).toDate();

  Post.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, snapshot.documentID,
            reference: snapshot.reference);

  static Map<String, dynamic> getMapForNewPost(String userKey, String username,
      String postImg, String postUri, String caption) {
    Map<String, dynamic> map = Map();

    map[KEY_USERKEY] = userKey;
    map[KEY_USERNAME] = username;
    map[KEY_POSTIMG] = postImg;
    map[KEY_POSTURI] = postUri;
    map[KEY_CAPTION] = caption;
    map[KEY_LASTCOMMENT] = "";
    map[KEY_LASTCOMMENTOR] = "";
    map[KEY_LASTCOMMENTTIME] = DateTime.now().toUtc();
    map[KEY_NUMOFLIKES] = [];
    map[KEY_NUMOFCOMMENTS] = 0;
    map[KEY_POSTTIME] = DateTime.now().toUtc();

    return map;
  }
}
