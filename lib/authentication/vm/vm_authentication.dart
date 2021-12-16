import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pagination_list_view/additionalFiles/global_functions_variables.dart';
import 'package:pagination_list_view/additionalFiles/shared_Pref.dart';

class VmAuthentication with ChangeNotifier {
  String _userName;
  String _email;
  String _userId;
  String _profilePicUrl;

  String get username {
    return _userName;
  }

  String get email {
    return _email;
  }

  String get userId {
    return _userId;
  }

  String get profilePicUrl {
    return _profilePicUrl;
  }

  bool get isAuth {
    return _userId != null;
  }

  Future<bool> tryAutologin() async {
    final prefs = await getShared();

    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedData =
        await json.decode(prefs.getString('userData')) as Map<String, Object>;

    _userId = extractedData['userId'];
    _userName = extractedData['userName'];
    _email = extractedData['email'];
    _profilePicUrl = extractedData['profilePicUrl'];
    notifyListeners();
    return true;
  }

  Future<void> storeUserData(UserCredential userCredential) async {
    var user = userCredential.user;
    _userName = user.displayName;
    _email = user.email;
    _profilePicUrl = user.photoURL;
    _userId = user.uid;
    notifyListeners();
    try {
        FirebaseFirestore   firestoreInstance = FirebaseFirestore.instance;
        Map<String, dynamic> userData = {
          "userId": _userId,
          "userName": _userName,
          "email": _email,
          "profilePicUrl": _profilePicUrl,
        };

        await firestoreInstance.collection("users").doc(_userId).set(userData);

        setStringToPref("userData", json.encode(userData));
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> logout() async {
    await removePref('userData');
    _userName = null;
    _email = null;
    _userId = null;
    _profilePicUrl = null;
    notifyListeners();
  }
}
