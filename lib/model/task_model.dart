import 'dart:io';
import 'package:json_annotation/json_annotation.dart';
part 'task_model.g.dart';

@JsonSerializable()
class Task {
  String taskName;
  String? taskDescription;
  final DateTime createdTime;
  DateTime dueTime;
  bool isDone = false;

  Task(
      {required this.taskName,
      this.taskDescription,
      required this.createdTime,
      required this.dueTime, this.isDone = false});

  void setTaskName(String taskName) {
    this.taskName = taskName;
  }

  void setDescription(String description) {
    this.taskDescription = description;
  }

  void setDueTime(DateTime dueTime) {
    this.dueTime = dueTime;
  }

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}
