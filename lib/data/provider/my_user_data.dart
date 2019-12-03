import 'package:flutter/foundation.dart';
import 'package:instagram_thecodingpapa/data/user.dart';

class MyUserData extends ChangeNotifier {
  User _myUserData;
  User get data => _myUserData;

  MyUserDataStatus _myUserDataStatus = MyUserDataStatus.progress;
  MyUserDataStatus get status => _myUserDataStatus;

  void setUserData(User user) {
    _myUserData = user;
    _myUserDataStatus = MyUserDataStatus.exist;
    notifyListeners();
  }

  void setNewStatus(MyUserDataStatus status) {
    _myUserDataStatus = status;
    notifyListeners();
  }

  void clearUser() {
    _myUserData = null;
    _myUserDataStatus = MyUserDataStatus.none;
    notifyListeners();
  }
}

enum MyUserDataStatus { progress, none, exist }
