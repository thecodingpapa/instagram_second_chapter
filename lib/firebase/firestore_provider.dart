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
        await tx.update(userRef, snapshot.data);
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

  Stream<List<User>> fetchAllUsersExceptMine() {
    return _firestore
        .collection(COLLECTION_USERS)
        .snapshots()
        .transform(toUsersExceptMine);
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

//Post

  Future<Map<String,dynamic>> createNewPost(String postKey, Map<String, dynamic> postData) {
    final DocumentReference postRef =
        _firestore.collection(COLLECTION_POSTS).document(postKey);
    final DocumentReference userRef =
        _firestore.collection(COLLECTION_USERS).document(postData[KEY_USERKEY]);
    return _firestore.runTransaction((Transaction tx) async {
      await tx.update(userRef, {
        KEY_MYPOSTS: FieldValue.arrayUnion([postKey])
      });
      DocumentSnapshot postSnapshot = await tx.get(postRef);
      if(!postSnapshot.exists){
        await tx.set(postRef, postData);
      }
    });
  }
}

FirestoreProvider firestoreProvider = FirestoreProvider();
