import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil_init.dart';
import 'package:get/get.dart';
import 'package:todo_task_fluttter_firebase/screens/login.dart';
import 'package:todo_task_fluttter_firebase/screens/task_list_screen.dart';
import 'package:todo_task_fluttter_firebase/services/sharePreference_instance.dart';

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
