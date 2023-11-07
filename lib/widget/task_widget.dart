import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/bloc/task_event.dart';
import '../bloc/task_bloc.dart';
import '../bloc/task_state.dart';
import '../model/task_model.dart';
import '../utils/task_shared_preference.dart';
import 'edit_task_widget.dart';

class TaskWidget extends StatefulWidget {
  // final String taskName  ;
  // final String? taskDescription;
  // final DateTime dueTime;
  // final String keyTask;

  // TaskWidget(
  // {required this.taskName, this.taskDescription, required this.dueTime, required this.keyTask}); //

  final Task task;
  final String keyTask;

  TaskWidget({required this.task, required this.keyTask});

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    // widget.task.isDone
    return BlocProvider(
        create: (BuildContext context) => TaskBloc(),
        child: BlocConsumer<TaskBloc, TaskState>(listener: (context, state) {
          // Handle state changes here if needed
        }, builder: (context, state) {
          return Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 68, 68, 107),borderRadius: BorderRadius.circular(20)),
              height: 100,
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Center(
                child: ListTile(
                    onLongPress: () => showDialog(
                        context: context,
                        builder: (context) {
                          return EditTask(keyTask: widget.keyTask);
                        }),
                    textColor: Colors.white,
                    title: Text('${widget.task.taskName}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600),),
                    subtitle: Text('${widget.task.taskDescription}'),
                    trailing: Text('${DateFormat.MMMMd().add_jm().format(widget.task.dueTime)}'),
                    leading: Transform.scale(
                      scale: 1.4,
                      child: Checkbox(
                        side: BorderSide(color: Colors.white, width: 2.0),
                        activeColor: Colors.cyan,
                        shape: CircleBorder(),
                        value: widget.task.isDone,
                        onChanged: (bool? checked) {
                          widget.task.isDone = checked!;
                          context.read<TaskBloc>().add(
                              AlterTask(keyTask: widget.keyTask, isDone: checked!));
                          // TaskPreference.checkTask(
                          //     keyTask: widget.keyTask,
                          //     isDone: widget.task.isDone);
                        },
                      ),
                    )),
              ));
        }));
  }
}
