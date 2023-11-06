import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/task_model.dart';

class TaskPreference {
  static SharedPreferences? _taskPrefs;
  // stringify the task model
  //add to shared preference with key
  // SharedPreferences _taskPrefs = {} as SharedPreferences;
  // Task? task;
  // String _keyTask = "";
  static Future init() async {
    SharedPreferences.resetStatic();
    _taskPrefs = await SharedPreferences.getInstance();
  }

  static Future setTask(String _keyTask, Task task) async =>
      await _taskPrefs?.setString(_keyTask, jsonEncode(task).toString());
  static Future getTask(String _keyTask) async =>
      await _taskPrefs?.getString(_keyTask);
  static Future deleteTask(String _keytask) async =>
      await _taskPrefs?.remove(_keytask);

  // functions that are corresponding to actions
  static saveTask (
      {required String taskName,
      String? taskDescription,
      required DateTime createdTime,
      required DateTime dueTime}) {
    Task task = Task(
        taskName: taskName,
        createdTime: createdTime,
        taskDescription: taskDescription,
        dueTime: dueTime);
    setTask(createdTime.toString(), task);
    print(_taskPrefs!.getString(task.createdTime.toString()));
  }

    static editTask(
      {String? taskName,
      String? taskDescription,
      DateTime? dueTime,
      required String keyTask}) async {
    Task task = Task.fromJson(json.decode(await getTask(keyTask)));
    if (taskName != task.taskName && taskName != null) {
      task.setTaskName(taskName);
    }
    if (taskDescription != task.taskDescription && taskDescription != null) {
      task.setDescription(taskDescription);
    }
    if (dueTime != task.dueTime && dueTime != null) {
      task.setDueTime(dueTime);
    }
    setTask(keyTask, task);
  }

  static checkTask({required String keyTask, required bool isDone}) async {
    Task task = Task.fromJson(json.decode(await getTask(keyTask)));
    task.isDone = isDone;
    setTask(keyTask, task);
  }

  static delete({required String keyTask}) {
    deleteTask(keyTask);
  }

  static getTaskWithKey({required String keyTask}) async {
    print(keyTask);
    String? taskString = await getTask(keyTask);
    print("taskString is:  ${taskString}");
    if (taskString != null) {
      Task task = Task.fromJson(json.decode(taskString));
      return task;
    } else {
      return null;
    }
  }

  static Future<List<Map<String, Task>>> getAllTask() async {
    List<Map<String, Task>> listTaskWithKey = [];
    Set? setKeys = await _taskPrefs?.getKeys();
    if (setKeys != null) {
      // setKeys?.map((e)=> print(TaskPreference.getTask(e).toString()));
      for (dynamic key in setKeys!) {
        listTaskWithKey
            .add({key: await TaskPreference.getTaskWithKey(keyTask: key)});
      }
      ;
      print(setKeys.toString());
      print(listTaskWithKey.toString());
      return listTaskWithKey;
    }
    return [];
  }

}
