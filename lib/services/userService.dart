import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_task_fluttter_firebase/model/add_task_model.dart';
import 'package:todo_task_fluttter_firebase/screens/login.dart';
import 'package:todo_task_fluttter_firebase/screens/task_list_screen.dart';
import 'package:todo_task_fluttter_firebase/services/sharePreference_instance.dart';

class UserService {
  late FirebaseFirestore _firestore;

  int? statusCode;
  String? msg = '';
  String userCollection = 'users';
  String taskListCollection = 'taskList';

  UserService() {
    initializeFirebaseApp();
  }

  void initializeFirebaseApp() async {
    await Firebase.initializeApp();
    _firestore = FirebaseFirestore.instance;
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
}
