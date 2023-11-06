import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:todo_app/bloc/task_event.dart';
import 'package:todo_app/bloc/task_state.dart';
import 'package:todo_app/widget/edit_task_widget.dart';
import '../model/task_model.dart';
import '../utils/task_shared_preference.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskState? overrideState;
  TaskBloc([this.overrideState]) : super(const TaskState()) {
    on<TaskStarted>(_onStarted);
    on<AddTask>(_onAddTask);
    on<RemoveTask>(_onRemoveTask);
    on<EditTaskTodo>(_onEditTask);
    on<AlterTask>(_onAlterTask);
  }
  void _onStarted (
    TaskStarted event,
    Emitter<TaskState> emit,
  ) async {
    state.status == TaskStatus.success;
    emit(state.copyWith(status: TaskStatus.success, tasks: await TaskPreference.getAllTask()));
  }

  void _onAddTask(
    AddTask event,
    Emitter<TaskState> emit,
  ) async {
    final data = event.task;
    emit(state.copyWith(status: TaskStatus.loading));
    try {
      // List<Map<String, Task>> temp = [];
      // temp.addAll(state.tasks);
      // temp.insert(0, event.task);
      await TaskPreference.saveTask(
          taskName: data.taskName,
          createdTime: data.createdTime,
          dueTime: data.dueTime,
          taskDescription: data.taskDescription);
      emit(state.copyWith(
          tasks: await TaskPreference.getAllTask(),
          status: TaskStatus.success));
    } catch (e) {
      emit(state.copyWith(status: TaskStatus.error));
    }
  }

  void _onRemoveTask(
    RemoveTask event,
    Emitter<TaskState> emit,
  ) async {
    final _keytask = event.taskKey;
    emit(state.copyWith(status: TaskStatus.loading));
    try {
      await TaskPreference.deleteTask(_keytask);
      emit(state.copyWith(
          tasks: await TaskPreference.getAllTask(),
          status: TaskStatus.success));
    } catch (e) {
      emit(state.copyWith(status: TaskStatus.error));
    }
  }

  void _onAlterTask(
    AlterTask event,
    Emitter<TaskState> emit,
  ) async {
    final _keytask = event.keyTask;
    final _isDone = event.isDone;
    emit(state.copyWith(status: TaskStatus.loading));
    try {
      await TaskPreference.checkTask(keyTask: _keytask, isDone: _isDone);
      emit(state.copyWith(
          tasks: await TaskPreference.getAllTask(),
          status: TaskStatus.success));
    } catch (e) {
      emit(state.copyWith(status: TaskStatus.error));
    }
  }

  // @override
  // TaskState? fromJson(Map<String, dynamic> json) {
  //   return TaskState.fromJson(json);
  // }
  //
  // @override
  // Map<String, dynamic>? toJson(TaskState state) {
  //   return state.toJson();
  // }

  void _onEditTask(EditTaskTodo event, Emitter<TaskState> emit) async {
    final String _keytask = event.keyTask;
    final Task _task = event.task;
    emit(state.copyWith(status: TaskStatus.loading));
    try {
      await TaskPreference.editTask(
          keyTask: _keytask,
          taskName: _task.taskName,
          taskDescription: _task.taskDescription,
          dueTime: _task.dueTime);
      emit(state.copyWith(
          tasks: await TaskPreference.getAllTask(),
          status: TaskStatus.success));
    } catch (e) {
      emit(state.copyWith(status: TaskStatus.error));
    }
  }
}
