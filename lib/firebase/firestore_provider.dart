import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_thecodingpapa/constants/firebase_keys.dart';
import 'package:instagram_thecodingpapa/data/post.dart';
import 'package:instagram_thecodingpapa/data/user.dart';
import 'package:instagram_thecodingpapa/firebase/transformer.dart';
import 'package:rxdart/rxdart.dart';

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

  Future<Map<String, dynamic>> createNewPost(
      String postKey, Map<String, dynamic> postData) async {
    final DocumentReference postRef =
        _firestore.collection(COLLECTION_POSTS).document(postKey);
    final DocumentSnapshot postSnapshot = await postRef.get();
    final DocumentReference userRef =
        _firestore.collection(COLLECTION_USERS).document(postData[KEY_USERKEY]);
    return _firestore.runTransaction((Transaction tx) async {
      await tx.update(userRef, {
        KEY_MYPOSTS: FieldValue.arrayUnion([postKey])
      });
      if (!postSnapshot.exists) {
        await tx.set(postRef, postData);
      }
    });
  }

  //Follow unfollow
  Future<Map<String, dynamic>> followUser(
      {String myUserKey, String otherUserKey}) async {
    //my doc ref&snapshot
    final DocumentReference myUserRef =
        _firestore.collection(COLLECTION_USERS).document(myUserKey);
    DocumentSnapshot myUserSnapshot = await myUserRef.get();

    //other doc ref&snapshot
    final DocumentReference otherUserRef =
        _firestore.collection(COLLECTION_USERS).document(otherUserKey);
    DocumentSnapshot otherUserSnapshot = await otherUserRef.get();

    //run transaction
    return _firestore.runTransaction((Transaction tx) async {
      if (myUserSnapshot.exists && otherUserSnapshot.exists) {
        await tx.update(myUserRef, <String, dynamic>{
          KEY_FOLLOWINGS: FieldValue.arrayUnion([otherUserKey])
        });

        int currentFollowers = otherUserSnapshot.data[KEY_FOLLOWERS];
        await tx.update(otherUserRef,
            <String, dynamic>{KEY_FOLLOWERS: currentFollowers + 1});
      }
    });
  }

  Future<Map<String, dynamic>> unfollowUser(
      {String myUserKey, String otherUserKey}) async {
    //my doc ref&snapshot
    final DocumentReference myUserRef =
        _firestore.collection(COLLECTION_USERS).document(myUserKey);
    DocumentSnapshot myUserSnapshot = await myUserRef.get();

    //other doc ref&snapshot
    final DocumentReference otherUserRef =
        _firestore.collection(COLLECTION_USERS).document(otherUserKey);
    DocumentSnapshot otherUserSnapshot = await otherUserRef.get();

    //run transaction
    return _firestore.runTransaction((Transaction tx) async {
      if (myUserSnapshot.exists && otherUserSnapshot.exists) {
        await tx.update(myUserRef, <String, dynamic>{
          KEY_FOLLOWINGS: FieldValue.arrayRemove([otherUserKey])
        });

        int currentFollowers = otherUserSnapshot.data[KEY_FOLLOWERS];
        await tx.update(otherUserRef,
            <String, dynamic>{KEY_FOLLOWERS: currentFollowers - 1});
      }
    });
  }

  Observable<List<Post>> fetchAllPostFromFollowers(List<dynamic> followings) {
    final CollectionReference collectionReference =
        _firestore.collection(COLLECTION_POSTS);

    List<Stream<List<Post>>> streams = [];

    for (int i = 0; i < followings.length; i++) {
      streams.add(collectionReference
          .where(KEY_USERKEY, isEqualTo: followings[i])
          .snapshots()
          .transform(toPosts));
    }

    return Observable.combineLatest(streams, (listOfPosts) {
      List<Post> combinedPosts = [];
      for (List<Post> posts in listOfPosts) {
        combinedPosts.addAll(posts);
      }
      return combinedPosts;
    });
  }
}

FirestoreProvider firestoreProvider = FirestoreProvider();
