import 'package:flutter/material.dart';
import 'package:instagram_thecodingpapa/utils/styles.dart';
import 'package:instagram_thecodingpapa/widgets/sign_in_form.dart';
import 'package:instagram_thecodingpapa/widgets/sign_up_form.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  Widget currentWidget = SigninForm();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Stack(
            children: <Widget>[
              AnimatedSwitcher(
                duration: Duration(milliseconds: 300),
                  child: currentWidget),
              _goToSignUpPageBtn(context),
            ],
          )),
    );
  }

  Positioned _goToSignUpPageBtn(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: 40,
      child: FlatButton(
        shape: Border(top: BorderSide(color: Colors.grey[300])),
        onPressed: (){
          setState(() {
            if(currentWidget is SigninForm){
              currentWidget = SignUpForm();
            }else{
              currentWidget = SigninForm();
            }
          });
        },
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(),
            children: <TextSpan>[
              TextSpan(
                  text: (currentWidget is SigninForm)?"Don't have an account?":"Already have an account?",
                  style: authTxtStyle),
              TextSpan(
                  text: (currentWidget is SigninForm)?'  Sign Up':'  Sign In',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.blue[600])),
            ],
          ),
        ),
      ),
    );
  }
}
