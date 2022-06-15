import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:todo_task_fluttter_firebase/model/add_task_model.dart';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:todo_task_fluttter_firebase/screens/add_task.dart';
import 'package:todo_task_fluttter_firebase/alertBox.dart';
import 'package:todo_task_fluttter_firebase/loader.dart';
import 'package:todo_task_fluttter_firebase/services/userService.dart';
import 'package:todo_task_fluttter_firebase/sizeConfig.dart';
import 'package:todo_task_fluttter_firebase/validateService.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:todo_task_fluttter_firebase/widget/primary_button.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  AddTaskModel addTaskModel = AddTaskModel();
  var isLoading = false;
  UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2A5798),
      appBar: AppBar(
        title: const Text('Add new Task'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color(0xFF2A5798),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            TextFormField(
              onChanged: (value) {
                addTaskModel.taskName = value;
              },
              style: TextStyle(fontSize: 0.05.sw, color: Colors.white),
              decoration: _inputDecoration(
                hintText: 'Task Name',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              onChanged: (value) {
                addTaskModel.taskDescription = value;
              },
              style: TextStyle(fontSize: 0.05.sw, color: Colors.white),
              decoration: _inputDecoration(
                hintText: 'Task Description',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            !isLoading
                ? PrimaryButton(
                    color: Colors.cyan,
                    onPressed: () async {
                      await addTaskToFirebase();
                    },
                    text: 'Add Task',
                  )
                : const CircularProgressIndicator(),
          ],
        ),
      )),
    );
  }

  Future<void> addTaskToFirebase() async {
    setState(() {
      isLoading = true;
    });
    addTaskModel.taskDateTime = DateTime.now().toString();
    await userService.addNewTask(addTaskModel);

    setState(() {
      isLoading = false;
    });
    Navigator.pop(context);
  }

  InputDecoration _inputDecoration({required String hintText}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle:
          TextStyle(fontSize: 0.04.sw, color: Colors.white.withOpacity(0.7)),
      contentPadding: const EdgeInsets.only(bottom: 3, left: 10),
      border: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
          width: 1,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
          width: 1,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.white,
          width: 1,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
    );
  }
}