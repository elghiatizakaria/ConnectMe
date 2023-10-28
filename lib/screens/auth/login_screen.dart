import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:we_chat/helper/dialogs.dart';
import 'package:we_chat/screens/home_screen.dart';
import '../../api/apis.dart';
import '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;


  @override
  void initState() {
    super.initState();

    //for auto triggering animation
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isAnimate = true;
        print("_isAnimate set to true");
      });
    });
  }

  _handleGoogleBtnClick(){
    Dialogs.showProgressbar(context);

    _signInWithGoogle().then((user) async {
      Navigator.pop(context);
      if(user != null){
        log('\nUser:${user.user}');
        log('\nUseradditionalUserInfo:${user.additionalUserInfo}');
        if((await APIs.userExists())){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> HomeScreen()));
        }else{
          APIs.createUser().then((value) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> HomeScreen()));
          });
        }
      }
       });;
  }


  Future<UserCredential?> _signInWithGoogle() async {

    try{
      await InternetAddress.lookup('google.com');
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return APIs.auth.signInWithCredential(credential);
    }catch(e){
      log('\n_signInWithGoogle: $e');
      Dialogs.showSnackbar(context, 'Something went wrong (check internet)');
      return null;
    }
  }



  //Sign Out function
  // _signOut() async {
  //   await FirebaseAuth.instance.signOut();
  //   await GoogleSignIn().signOut();
  // }


  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('welcome to We Chat'),
        ),
        body: Stack(
          children: [
            AnimatedPositioned(
                top: mq.height * .15,
                right: _isAnimate ? mq.width * .25 : -mq.width * .5,
                width: mq.width * .5,
                duration: const Duration(seconds: 1),
                child: Image.asset('images/icon.png')),
            Positioned(
                bottom: mq.height * .15,
                left: mq.width * .05,
                width: mq.width * .9,
                height: mq.height * .07,
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF99BED9),
                        shape: const StadiumBorder(),
                        elevation: 1),
                    onPressed: () {
                     _handleGoogleBtnClick();
                    },
                    icon: Image.asset(
                      'images/google.png',
                      height: mq.height * .05,
                    ),
                    label: RichText(
                      text: TextSpan(
                          style: TextStyle(color: Colors.black, fontSize: 19),
                          children: [
                            TextSpan(text: 'Sign In with'),
                            TextSpan(
                              text: ' Google',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ]),
                    )))
          ],
        ));
  }
}
