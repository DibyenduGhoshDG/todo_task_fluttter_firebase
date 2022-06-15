class AddTaskModel {
  String? taskName;
  String? taskDescription;
  String? taskDateTime;
  AddTaskModel() {}
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['taskName'] = taskName;
    data['taskDescription'] = taskDescription;
    data['taskDateTime'] = taskDateTime;
    return data;
  }

  AddTaskModel.fromJson(json) {
    taskName = json['taskName'];
    taskDescription = json['taskDescription'];
    taskDateTime = json['taskDateTime'];
  }
}
