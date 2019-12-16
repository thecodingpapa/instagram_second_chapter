import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_thecodingpapa/constants/firebase_keys.dart';

class CommentModel {
  final String comment;
  final String commnetKey;
  final String userKey;
  final String username;
  final DateTime commenttime;
  final DocumentReference reference;

  CommentModel.fromMap(Map<String, dynamic> map, this.commnetKey,
      {this.reference})
      : comment = map[KEY_COMMENT],
        userKey = map[KEY_USERKEY],
        username = map[KEY_USERNAME],
        commenttime = (map[KEY_COMMENTTIME] as Timestamp).toDate();

  CommentModel.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, snapshot.documentID,
            reference: snapshot.reference);

  static Map<String, dynamic> getMapForNewComment(
      String userKey, String username, String comment) {
    Map<String, dynamic> map = Map();

    map[KEY_USERKEY] = userKey;
    map[KEY_USERNAME] = username;
    map[KEY_COMMENT] = comment;
    map[KEY_COMMENTTIME] = DateTime.now().toUtc();

    return map;
  }
}
