import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_task_fluttter_firebase/model/add_task_model.dart';
import 'package:todo_task_fluttter_firebase/services/userService.dart';
import 'package:todo_task_fluttter_firebase/widget/primary_button.dart';

class AddTask extends StatefulWidget {
  AddTaskModel? addTaskModel;
  String? docId;
  AddTask({Key? key, this.addTaskModel, this.docId}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  AddTaskModel addTaskModel = AddTaskModel();
  var isLoading = false;
  UserService userService = UserService();
  TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    // if(addTaskModel != null){

    // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A5798),
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
              initialValue: widget.addTaskModel?.taskName ?? '',
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
              initialValue: widget.addTaskModel?.taskDescription ?? '',
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
            TextFormField(
              initialValue: widget.addTaskModel?.taskDescription ?? '',
              controller: dateController,
              // onChanged: (value) {
              //   addTaskModel.taskDescription = value;
              // },
              onTap: () {
                // addTaskModel.taskDescription = value;
                // DateTime.s
              },
              style: TextStyle(fontSize: 0.05.sw, color: Colors.white),
              decoration: _inputDecoration(
                hintText: 'Task Date',
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            !isLoading
                ? PrimaryButton(
                    color: Colors.cyan,
                    onPressed: () async {
                      if (widget.docId == null) {
                        await addTaskToFirebase();
                      } else {
                        await updateTaskToFirebase();
                      }
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

  Future<void> updateTaskToFirebase() async {
    setState(() {
      isLoading = true;
    });
    await userService.updateItem(
        addTaskModel: addTaskModel, docId: widget.docId!);
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
