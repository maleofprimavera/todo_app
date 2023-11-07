import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../model/task_model.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();
  @override
  List<Object?> get props => [];
}

class TaskStarted extends TaskEvent {
// final List<Map<String, Task>> listTasks;
const TaskStarted();

@override
List<Object?> get props => [];
}

class AddTask extends TaskEvent {
  final Task task;
  const AddTask({required this.task});

  @override
  List<Object?> get props => [task];
}

class RemoveTask extends TaskEvent {
  final String taskKey;
  const RemoveTask({required this.taskKey});

  @override
  List<Object?> get props => [taskKey];
}

class EditTaskTodo extends TaskEvent {
  final String keyTask;
  final Task task;

  const EditTaskTodo({required this.keyTask, required this.task});
  @override
  List<Object?> get props => [keyTask, task];
}

class AlterTask extends TaskEvent {
  final String keyTask;
  final bool isDone;
  const AlterTask({required this.keyTask, required this.isDone});

  @override
  List<Object?> get props => [keyTask, isDone];
}

