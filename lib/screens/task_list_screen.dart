import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:todo_task_fluttter_firebase/model/add_task_model.dart';
import 'package:todo_task_fluttter_firebase/screens/add_task.dart';
import 'package:todo_task_fluttter_firebase/services/sharePreference_instance.dart';
import 'package:todo_task_fluttter_firebase/services/userService.dart';
import 'package:todo_task_fluttter_firebase/sizeConfig.dart';
import 'package:todo_task_fluttter_firebase/validateService.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  HashMap userValues = HashMap<String, String>();
  Map customWidth = Map<String, double>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  double borderWidth = 2.0;

  // ValidateService _validateService = ValidateService();
  late UserService _userService = UserService();
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      drawer: Drawer(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
              onTap: () async {
                await _userService.logOut(context);
              },
              child: Text('Log Out'))
        ],
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (ctx) => AddTask()));
        },
        backgroundColor: Colors.cyan,
        child: const Icon(
          Icons.add,
          size: 50,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              buildHeaderPart(),
              buildBodyPart(),
            ],
          ),
        ),
      ),
    );
  }

  List tempList = [
    {
      'name': 'Dibyendu',
      'time': 'Dibyendu',
      'address': 'Dibyendu',
    },
    {
      'name': 'Dibyendu',
      'time': 'Dibyendu',
      'address': 'Dibyendu',
    },
    {
      'name': 'Dibyendu',
      'time': 'Dibyendu',
      'address': 'Dibyendu',
    },
    {
      'name': 'Dibyendu',
      'time': 'Dibyendu',
      'address': 'Dibyendu',
    },
    {
      'name': 'Dibyendu',
      'time': 'Dibyendu',
      'address': 'Dibyendu',
    },
    {
      'name': 'Dibyendu',
      'time': 'Dibyendu',
      'address': 'Dibyendu',
    },
    {
      'name': 'Dibyendu',
      'time': 'Dibyendu',
      'address': 'Dibyendu',
    },
    {
      'name': 'Dibyendu',
      'time': 'Dibyendu',
      'address': 'Dibyendu',
    },
    {
      'name': 'Dibyendu',
      'time': 'Dibyendu',
      'address': 'Dibyendu',
    },
  ];

  Widget buildBodyPart() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15,
        left: 20,
        right: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'INBOX',
            style: TextStyle(
                fontSize: 0.05.sw,
                fontWeight: FontWeight.w600,
                color: Colors.black),
          ),
          SizedBox(
            height: 0.01.sh,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('taskList')
                  .doc('${sharePrefereceInstance.getUserId()}')
                  .collection('${sharePrefereceInstance.getUserId()}')
                  .snapshots(),
              builder: (BuildContext context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Oops! facing error');
                }
                if (snapshot.hasData) {
                  var doc = snapshot.data!.docs;
                  if (doc != null && doc.length >= 1) {
                    // print(doc.first.data());
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: doc.length,
                      itemBuilder: ((context, index) {
                        AddTaskModel taskModel =
                            AddTaskModel.fromJson(doc[index]);
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.grey,
                                  child: CircleAvatar(
                                      radius: 23,
                                      backgroundColor: Colors.white,
                                      child: Icon(Icons.music_note_sharp)),
                                ),
                                SizedBox(
                                  width: 0.04.sw,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 0.6.sw,
                                      child: Text(
                                        taskModel.taskName.toString(),
                                        style: TextStyle(
                                            fontSize: 0.05.sw,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 0.6.sw,
                                      child: Text(
                                        taskModel.taskDescription.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: true,
                                        style: TextStyle(
                                            fontSize: 0.04.sw,
                                            fontWeight: FontWeight.w400,
                                            color:
                                                Colors.black.withOpacity(0.5)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Text(
                              taskModel.taskDateTime
                                  .toString()
                                  .substring(11, 16),
                              style: TextStyle(
                                  fontSize: 0.04.sw,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black.withOpacity(0.5)),
                            ),
                          ],
                        );
                      }),
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                    );
                  } else {
                    return Center(
                        child: Text('You Have No Task, Please your task'));
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan),
                    ),
                  );
                }
              }),
        ],
      ),
    );
  }

  Widget buildHeaderPart() {
    return SizedBox(
      width: 1.sw,
      height: 0.3.sh,
      child: Stack(
        children: [
          buildHeaderImage(),
          buildShadowEffect(),
          buildHeaderContent(),
          buildLinearGradient()
        ],
      ),
    );
  }

  Widget buildHeaderImage() {
    return SizedBox(
      width: 1.sw,
      height: 0.3.sh,
      child: Image.asset(
        'asset/hill_img.jpg',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildShadowEffect() {
    return Container(
      width: 1.sw,
      height: 0.3.sh,
      child: Row(children: [
        Expanded(flex: 5, child: Container()),
        Expanded(
            flex: 3,
            child: Container(
              color: Colors.black.withOpacity(.2),
            )),
      ]),
    );
  }

  Widget buildHeaderContent() {
    return SizedBox(
      width: 1.sw,
      height: 0.3.sh,
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  // Scaffold.of(context).openDrawer();

                  scaffoldKey.currentState?.openDrawer();
                },
                child: const Icon(
                  Icons.menu,
                  size: 30,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 0.02.sh,
              ),
              getBigText('Your'),
              buildThingsRow(),
              SizedBox(
                height: 0.03.sh,
              ),
              buildDateWithProgressIndicator(),
            ]),
      ),
    );
  }

  Widget buildThingsRow() {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: getBigText('Things'),
        ),
        Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getColumnWithNumberAndText('24', 'Personal'),
                const SizedBox(
                  width: 5,
                ),
                getColumnWithNumberAndText('15', 'Business'),
              ],
            )),
      ],
    );
  }

  Widget buildDateWithProgressIndicator() {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Text(
            'Sep 5, 2015',
            style: TextStyle(fontSize: 0.03.sw, color: Colors.white),
          ),
        ),
        Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildProgressIndicator(context, 65),
                Text(
                  '    65% done',
                  style: TextStyle(fontSize: 0.03.sw, color: Colors.white),
                )
              ],
            )),
      ],
    );
  }

  Widget buildLinearGradient() {
    return Positioned(
      bottom: 1,
      child: SizedBox(
        width: 1.sw,
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                height: 4,
                width: 100,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [Colors.white, Colors.cyanAccent])),
              ),
            ),
            Expanded(flex: 3, child: Container()),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context, int score) {
    return CircularPercentIndicator(
      radius: 15,
      percent: score / 100,
      progressColor: Colors.white,
      backgroundColor: Colors.blue,
      lineWidth: 2,
      center: Container(),
    );
  }

  Widget getColumnWithNumberAndText(
    String numberValue,
    String text,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          numberValue,
          style: TextStyle(fontSize: 0.05.sw, color: Colors.white),
        ),
        Text(
          text,
          style: TextStyle(fontSize: 0.03.sw, color: Colors.white),
        ),
      ],
    );
  }

  Widget getBigText(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 0.09.sw, color: Colors.white),
    );
  }
}
