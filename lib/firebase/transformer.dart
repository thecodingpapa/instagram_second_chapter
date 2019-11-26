import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_thecodingpapa/data/user.dart';

class Transformer {
  final toUser = StreamTransformer<DocumentSnapshot, User>.fromHandlers(
      handleData: (snapshot, sink) async {
    sink.add(User.fromSnapshot(snapshot));
  });

  final toUsers = StreamTransformer<QuerySnapshot, List<User>>.fromHandlers(
      handleData: (snapshot, sink) {
    List<User> users = [];
    snapshot.documents.forEach((doc) {
      users.add(User.fromSnapshot(doc));
    });
    sink.add(users);
  });

  final toUsersExceptMine =
      StreamTransformer<QuerySnapshot, List<User>>.fromHandlers(
          handleData: (snapshot, sink) async {
    List<User> users = [];
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    snapshot.documents.forEach((doc) {
      if (doc.documentID != user.uid) users.add(User.fromSnapshot(doc));
    });
    sink.add(users);
  });
}
