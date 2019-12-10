import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_thecodingpapa/utils/post_path.dart';

class StorageProvider {
  final FirebaseStorage _firebaseStorage = FirebaseStorage();

  Future<StorageTaskSnapshot> uploadImg(File image, String path) {
    final StorageReference storageReference =
        _firebaseStorage.ref().child(path);
    final StorageUploadTask uploadTask = storageReference.putFile(image);

    return uploadTask.onComplete;
  }

  Future<dynamic> getPostImageUri(String postKey) {
    return _firebaseStorage.ref().child(getImgPath(postKey)).getDownloadURL();
  }
}

final StorageProvider storageProvider = StorageProvider();
