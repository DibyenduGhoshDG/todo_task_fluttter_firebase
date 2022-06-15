// import 'package:app_frontend/components/modals/internetConnection.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:todo_task_fluttter_firebase/alertBox.dart';
import 'package:todo_task_fluttter_firebase/loader.dart';
import 'package:todo_task_fluttter_firebase/model/add_task_model.dart';
import 'package:todo_task_fluttter_firebase/screens/login.dart';
import 'package:todo_task_fluttter_firebase/screens/task_list_screen.dart';
import 'package:todo_task_fluttter_firebase/services/sharePreference_instance.dart';
import 'package:todo_task_fluttter_firebase/services/userService.dart';
import 'package:todo_task_fluttter_firebase/sizeConfig.dart';
import 'package:todo_task_fluttter_firebase/validateService.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserService {
  late FirebaseAuth _auth;
  late FirebaseFirestore _firestore;
  // late FlutterSecureStorage _storage;

  int? statusCode;
  String? msg = '';
  String userCollection = 'users';
  String taskListCollection = 'taskList';

  UserService() {
    initializeFirebaseApp();
  }

  void initializeFirebaseApp() async {
    // bool internetConnection = await checkInternetConnectivity();
    // if (internetConnection) {
    await Firebase.initializeApp();
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
    // _storage = new FlutterSecureStorage();
    // }
  }

  // void storeJWTToken(String idToken, refreshToken) async {
  //   await _storage.write(key: 'idToken', value: idToken);
  //   await _storage.write(key: 'refreshToken', value: refreshToken);
  // }

  // String? validateToken(String token) {
  //   bool isExpired = Jwt.isExpired(token);

  //   if (isExpired) {
  //     return null;
  //   } else {
  //     Map<String, dynamic> payload = Jwt.parseJwt(token);
  //     return payload['user_id'];
  //   }
  // }

  Future<void> logOut(context) async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
      ],
    );
    await googleSignIn.signOut();
    sharePrefereceInstance.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (ctx) => Login()),
      (route) => false,
    );
  }

  Future<bool> login(context) async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: [
          'email',
        ],
      );
      await googleSignIn.signIn().then((GoogleSignInAccount? acc) async {
        await googleSignIn.signIn();
        acc!.authentication.then((GoogleSignInAuthentication auth) async {
          var body = {
            "name": acc.displayName,
            "email": acc.email,
            "acc_id": acc.id,
          };
          await _firestore
              .collection(userCollection)
              .doc('${acc.id}')
              .set(body);
          // _firestore.collection(taskListCollection).doc('${acc.id}');
          sharePrefereceInstance.setUserId(acc.id);
          sharePrefereceInstance.setLoggedIn(true);
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (ctx) => TaskListScreen()),
            (route) => false,
          );
          return true;
        }).catchError((error) {
          throw error;
        });
      }).catchError((error) {
        throw error;
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  String? getUserId() {
    return sharePrefereceInstance.getUserId();
  }

  Future<void> addNewTask(AddTaskModel addTaskModel) async {
    try {
      await _firestore
          .collection(taskListCollection)
          .doc('${getUserId()}')
          .collection('${getUserId()}')
          .add(addTaskModel.toJson());
    } catch (e) {
      print(e.toString());
    }
  }

  // void handleAuthErrors(error) {
  //   String errorCode = error.code;
  //   switch (errorCode) {
  //     case "ERROR_EMAIL_ALREADY_IN_USE":
  //       {
  //         statusCode = 400;
  //         msg = "Email ID already existed";
  //       }
  //       break;
  //     case "ERROR_WRONG_PASSWORD":
  //       {
  //         statusCode = 400;
  //         msg = "Password is wrong";
  //       }
  //   }
  // }

  String capitalizeName(String name) {
    name = name[0].toUpperCase() + name.substring(1);
    return name;
  }

  String userEmail() {
    var user = _auth.currentUser;
    return user.email;
  }

  Future<List> userWishlist() async {
    String? uid = await getUserId();
    QuerySnapshot userRef = await _firestore
        .collection('users')
        .where('userId', isEqualTo: uid)
        .get();

    Map userData = userRef.docs[0].data();
    List userWishList = [];

    if (userData.containsKey('wishlist')) {
      for (String item in userData['wishlist']) {
        Map<String, dynamic> tempWishList = new Map();
        DocumentSnapshot productRef =
            await _firestore.collection('products').doc(item).get();
        tempWishList['productName'] = productRef.data()['name'];
        tempWishList['price'] = productRef.data()['price'];
        tempWishList['image'] = productRef.data()['image'];
        tempWishList['productId'] = productRef.id;
        userWishList.add(tempWishList);
      }
    }
    return userWishList;
  }

  Future<void> deleteUserWishlistItems(String productId) async {
    String? uid = getUserId();
    QuerySnapshot userRef = await _firestore
        .collection('users')
        .where('userId', isEqualTo: uid)
        .get();
    String documentId = userRef.docs[0].id;
    Map<String, dynamic> wishlist = userRef.docs[0].data();
    wishlist['wishlist'].remove(productId);

    await _firestore
        .collection('users')
        .doc(documentId)
        .update({'wishlist': wishlist['wishlist']});
  }

  // String getConnectionValue(var connectivityResult) {
  //   String status = '';
  //   switch (connectivityResult) {
  //     case ConnectivityResult.mobile:
  //       status = 'Mobile';
  //       break;
  //     case ConnectivityResult.wifi:
  //       status = 'Wi-Fi';
  //       break;
  //     case ConnectivityResult.none:
  //       status = 'None';
  //       break;
  //     default:
  //       status = 'None';
  //       break;
  //   }
  //   return status;
  // }

  // Future<bool> checkInternetConnectivity() async {
  //   final Connectivity _connectivity = Connectivity();
  //   ConnectivityResult result = await _connectivity.checkConnectivity();
  //   String connection = getConnectionValue(result);
  //   if (connection == 'None') {
  //     return false;
  //   } else {
  //     return true;
  //   }
  // }
}
