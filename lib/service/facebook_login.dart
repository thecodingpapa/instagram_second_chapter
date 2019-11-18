import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:instagram_thecodingpapa/utils/simple_snack_bar.dart';

void signInFacebook(BuildContext context) async {
  final facebookLogin = FacebookLogin();
  final result = await facebookLogin.logIn(['email']);

  switch (result.status) {
    case FacebookLoginStatus.loggedIn:
      _handleFacebookToken(context, result.accessToken.token);
      break;
    case FacebookLoginStatus.cancelledByUser:
      simpleSnackbar(context, 'User cancel facebook sign in!');
      break;
    case FacebookLoginStatus.error:
      simpleSnackbar(context, 'Error while facebook sign in!');
      break;
  }
}

void _handleFacebookToken(BuildContext context, String token) async {
  final AuthCredential credential = FacebookAuthProvider.getCredential(
    accessToken: token,
  );
  final FirebaseUser user =
      (await FirebaseAuth.instance.signInWithCredential(credential)).user;
  if (user == null) {
    simpleSnackbar(context, 'Failed to sign in with Facebook.');
  }
}
