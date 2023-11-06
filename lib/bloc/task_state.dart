import 'package:equatable/equatable.dart';

import '../model/task_model.dart';
import '../utils/task_shared_preference.dart';


enum TaskStatus{ initial, loading, success, error}
class TaskState extends Equatable{
  final List<Map<String, Task>> tasks;
  final TaskStatus status;

  const TaskState({this.tasks = const <Map<String, Task>>[],this.status = TaskStatus.initial});
  TaskState copyWith({
    TaskStatus? status,
    List<Map<String, Task>>? tasks,
  }) {
    return TaskState(
      status: status ?? this.status,
    );
  }

  // @override
  // factory TaskState.fromJson(Map<String, dynamic> json) {
  //   try {
  //     var listOfTodos = (json['todo'] as List<dynamic>)
  //         .map((e) => Todo.fromJson(e as Map<String, dynamic>))
  //         .toList();
  //
  //     return TodoState(
  //         todos: listOfTodos,
  //         status: TodoStatus.values.firstWhere(
  //                 (element) => element.name.toString() == json['status']
  //         )
  //     );
  //   } catch (e) {
  //     rethrow;
  //   }
  // }
  //
  // Map<String, dynamic> toJson() {
  //   return {
  //     'tasks': tasks,
  //     'status': status.name
  //   };
  // }
  @override
  List<Object?> get props => [TaskPreference,status];

}