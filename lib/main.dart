import 'package:flutter/material.dart';
import 'package:todo_task_fluttter_firebase/screens/add_task.dart';
import 'package:todo_task_fluttter_firebase/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_task_fluttter_firebase/services/sharePreference_instance.dart';
import 'package:todo_task_fluttter_firebase/services/userService.dart';
import 'package:todo_task_fluttter_firebase/sizeConfig.dart';
import 'package:flutter_screenutil/screenutil_init.dart';
import 'package:get/get.dart';
import 'package:todo_task_fluttter_firebase/screens/task_list_screen.dart';
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
import 'package:todo_task_fluttter_firebase/screens/task_list_screen.dart';
import 'package:todo_task_fluttter_firebase/services/sharePreference_instance.dart';
import 'package:todo_task_fluttter_firebase/services/userService.dart';
import 'package:todo_task_fluttter_firebase/sizeConfig.dart';
import 'package:todo_task_fluttter_firebase/validateService.dart';
import 'package:google_sign_in/google_sign_in.dart';

bool isLoggedIn = true;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sharePrefereceInstance.init();
  isLoggedIn = sharePrefereceInstance.isLoggedIn() ?? false;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return ScreenUtilInit(
        designSize: Size(width, height),
        allowFontScaling: false,
        builder: () => isLoggedIn ? TaskListScreen() : Login());
  }
}
