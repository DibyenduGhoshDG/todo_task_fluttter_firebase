import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_task_fluttter_firebase/services/userService.dart';
import 'package:todo_task_fluttter_firebase/widget/primary_button.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  UserService _userService = UserService();
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
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
  }
}
