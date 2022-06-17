import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:todo_task_fluttter_firebase/model/add_task_model.dart';
import 'package:todo_task_fluttter_firebase/services/userService.dart';
import 'package:todo_task_fluttter_firebase/widget/primary_button.dart';
import 'package:intl/intl.dart';

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
    if (widget.addTaskModel != null) {
      dateController.text = widget.addTaskModel!.taskDateTime!;
      addTaskModel.taskName = widget.addTaskModel!.taskName!;
      addTaskModel.taskDescription = widget.addTaskModel!.taskDescription!;
    }
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
              controller: dateController,
              readOnly: true,
              onTap: () {
                var datePart = dateController.text.split(' ');
                var dateFormat = datePart[0].split('-');
                DateTime selectedDate = dateController.text == ''
                    ? DateTime.now()
                    : DateTime(
                        int.parse(dateFormat[2]),
                        int.parse(dateFormat[1]),
                        int.parse(dateFormat[0]),
                      );
                showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2025),
                ).then((value) {
                  if (value != null) {
                    dateController.text =
                        DateFormat('dd-MM-yyyy').format(value);
                  }
                  //  else {
                  //   dateController.text = widget.addTaskModel!.taskDateTime!;
                  // }
                  print(dateController.text);
                });
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
                    text: widget.docId == null ? 'Add Task' : 'Update Task',
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
    addTaskModel.taskDateTime = dateController.text;
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
    addTaskModel.taskDateTime = dateController.text;
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
