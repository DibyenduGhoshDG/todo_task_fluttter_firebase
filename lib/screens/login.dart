import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:todo_task_fluttter_firebase/alertBox.dart';
import 'package:todo_task_fluttter_firebase/loader.dart';
import 'package:todo_task_fluttter_firebase/screens/task_list_screen.dart';
import 'package:todo_task_fluttter_firebase/services/userService.dart';
import 'package:todo_task_fluttter_firebase/sizeConfig.dart';
import 'package:todo_task_fluttter_firebase/validateService.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_task_fluttter_firebase/widget/primary_button.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<State> _keyLoader = GlobalKey<State>();
  HashMap userValues = HashMap<String, String>();
  Map customWidth = Map<String, double>();

  double borderWidth = 2.0;
  UserService _userService = UserService();
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    // SizeConfig().init(context);
    // customScreenWidth(SizeConfig.screenSize);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: 1.sh,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: !isLoading
                      ? SizedBox(
                          height: 0.07.sh,
                          width: 0.9.sw,
                          child: PrimaryButton(
                            color: Colors.cyan,
                            onPressed: () async {
                              googleLogin();
                            },
                            text: 'Continue With Google',
                          ))
                      : const CircularProgressIndicator(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //google login -------------------------------------------------------------------
  Future<void> googleLogin() async {
    setState(() {
      isLoading = true;
    });
    await _userService.login(context);
    setState(() {
      isLoading = false;
    });
    // if (isLoggedIn) {
    //   // ignore: use_build_context_synchronously
    //   Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (ctx) => TaskListScreen()),
    //     (route) => false,
    //   );
    // }
  }
}
