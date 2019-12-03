import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:instagram_thecodingpapa/constants/material_white_color.dart';
import 'package:instagram_thecodingpapa/data/provider/my_user_data.dart';
import 'package:instagram_thecodingpapa/firebase/firestore_provider.dart';
import 'package:instagram_thecodingpapa/main_page.dart';
import 'package:instagram_thecodingpapa/screens/auth_page.dart';
import 'package:instagram_thecodingpapa/widgets/my_progress_indicator.dart';
import 'package:provider/provider.dart';

void main() {
  return runApp(ChangeNotifierProvider<MyUserData>(
      builder: (context) => MyUserData(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Consumer<MyUserData>(
        builder: (context, myUserData, child) {
          switch (myUserData.status) {
            case MyUserDataStatus.progress:
              FirebaseAuth.instance.currentUser().then((firebaseUser) {
                if (firebaseUser == null)
                  myUserData.setNewStatus(MyUserDataStatus.none);
                else
                  firestoreProvider
                      .connectMyUserData(firebaseUser.uid)
                      .listen((user) {
                    myUserData.setUserData(user);
                  });
              });
              return MyProgressIndicator();
            case MyUserDataStatus.exist:
              return MainPage();
            default:
              return AuthPage();
          }
        },
      ),
      theme: ThemeData(primarySwatch: white),
    );
  }
}
