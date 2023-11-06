// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Task _$TaskFromJson(Map<String, dynamic> json) => Task(
      taskName: json['taskName'] as String,
      taskDescription: json['taskDescription'] as String?,
      createdTime: DateTime.parse(json['createdTime'] as String),
      dueTime: DateTime.parse(json['dueTime'] as String),
      isDone: json['isDone'] as bool? ?? false,
    );

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'taskName': instance.taskName,
      'taskDescription': instance.taskDescription,
      'createdTime': instance.createdTime.toIso8601String(),
      'dueTime': instance.dueTime.toIso8601String(),
      'isDone': instance.isDone,
    };
