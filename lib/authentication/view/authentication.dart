import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pagination_list_view/additionalFiles/constants.dart';
import 'package:pagination_list_view/additionalFiles/global_functions_variables.dart';
import 'package:pagination_list_view/additionalFiles/routes.dart';
import 'package:pagination_list_view/authentication/vm/vm_authentication.dart';

class Authentication extends StatefulWidget {
  const Authentication({Key key}) : super(key: key);

  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool _isLoading = false;
  final StreamController<bool> _loadingController = StreamController.broadcast();

  @override
  void dispose() {
    _loadingController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: _loadingController.stream,
        builder: (ctx, snapshot) => Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Login With',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(height: mediumHeightWidth),
                  InkWell(
                    onTap: _isLoading ? null : _authenticate,
                    child: Image.asset(
                      'assets/google.jpg',
                      height: 60,
                      width: 60,
                    ),
                  )
                ],
              ),
            ),
            Visibility(
                visible: _isLoading,
                child: const Center(child: CircularProgressIndicator()))
          ],
        ),
      ),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _authenticate() async {
    try {
      _isLoading = true;
      _loadingController.add(true);
      UserCredential userCredential = await signInWithGoogle();
      await VmAuthentication().storeUserData(userCredential);
      showCustomSnackBar(context, 'Login Successful.');
      _isLoading = false;
      _loadingController.add(true);
      Navigator.pushReplacementNamed(
        context,
        MyRoutes.mainPage,
      );
    } catch (e) {
      _isLoading = false;
      _loadingController.add(true);
      showCustomSnackBar(context, "Something went wrong.",
          color: Colors.red); //show error msg at bottom of the screen
    }
  }
}
