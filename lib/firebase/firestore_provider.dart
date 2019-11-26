import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_thecodingpapa/constants/firebase_keys.dart';
import 'package:instagram_thecodingpapa/data/user.dart';
import 'package:instagram_thecodingpapa/firebase/transformer.dart';

class FirestoreProvider with Transformer {
  final Firestore _firestore = Firestore.instance;

  Future<void> attemptCreateUser({String userKey, String email}) {
    final DocumentReference userRef =
        _firestore.collection(COLLECTION_USERS).document(userKey);
    return _firestore.runTransaction((Transaction tx) async {
      DocumentSnapshot snapshot = await tx.get(userRef);
      if (snapshot.exists) {
        return;
      } else {
        await tx.set(userRef, User.getMapForCreateUser(email));
      }
    });
  }

  Stream<User> connectMyUserData(String userKey) {
    return _firestore
        .collection(COLLECTION_USERS)
        .document(userKey)
        .snapshots()
        .transform(toUser);
  }

  Stream<List<User>> fetchAllUsers() {
    return _firestore
        .collection(COLLECTION_USERS)
        .snapshots()
        .transform(toUsers);
  }

//  Future<void> sendData() {
//    return Firestore.instance
//        .collection(COLLECTION_USERS)
//        .document('123123123')
//        .setData({'email': 'testing@test.com', 'author': 'author'});
//  }
//
//  void getData() {
//    Firestore.instance
//        .collection(COLLECTION_USERS)
//        .document('123123123')
//        .get()
//        .then((DocumentSnapshot ds) {
//      print(ds.data);
//    });
//  }
}

FirestoreProvider firestoreProvider = FirestoreProvider();
