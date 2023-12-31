import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/task_state.dart';

import '../bloc/task_bloc.dart';
import '../bloc/task_event.dart';
import '../model/task_model.dart';
import '../notification/notification_api.dart';
import 'home.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({super.key});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDescriptionController =
      TextEditingController();

  String _taskName = "";
  String? _taskDescription;
  DateTime? _pickDate;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => TaskBloc(),
      child: BlocConsumer<TaskBloc, TaskState>(listener: (context, state) {
        // Handle state changes here if needed
      }, builder: (context, state) {
        return AlertDialog(
          backgroundColor: Colors.cyan,
          title: const Text('Create task'),
          content: Container(
            height: 200,
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextField(
                  controller: _taskNameController,
                  decoration: const InputDecoration(
                      label: Text('Task'), hintText: "Go for groceries"),
                  onSubmitted: (value) {
                    setState(() {
                      _taskName = value;
                    });
                  },
                ),
                TextField(
                  controller: _taskDescriptionController,
                  decoration: const InputDecoration(
                      label: Text('Description'),
                      hintText: "Banana, Apple, Cider Vinegar"),
                  onSubmitted: (value) {
                    setState(() {
                      _taskDescription = value;
                    });
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.datetime,
                        controller: _dateController,
                        decoration: const InputDecoration(
                          label: Text('Due Date'),
                          hintText: "Enter Date",
                        ),
                        onSubmitted: (value) {
                            _pickDate = DateTime.tryParse(value)!;
                            print("Date picked: " + _pickDate.toString());
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        DateTime? _futurePickedDate;
                        TimeOfDay? _timeOfDay;
                        _futurePickedDate = (await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2500),
                        ));
                        _timeOfDay = await (showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        ));
                        _futurePickedDate = _futurePickedDate!.copyWith(
                            hour: _timeOfDay!.hour, minute: _timeOfDay!.minute);
                          _pickDate = _futurePickedDate!;
                          _dateController.text = _pickDate.toString();
                          print("Date picked: " + _pickDate.toString());
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel')),
            TextButton(
                // todo add bloc here, event
                onPressed: () async {
                  _taskName = _taskNameController.text;
                  _taskDescription = _taskDescriptionController.text;
                  _pickDate = DateTime.parse(_dateController.text);
                  Task task = Task(
                      taskName: (_taskName == "") ? "Untitled" : _taskName,
                      createdTime: DateTime.now(),
                      dueTime: _pickDate!,
                      taskDescription: _taskDescription);
                  // await NotificationApi.showNotification(scheduledDate: DateTime.now().add(Duration(seconds: 15)), title: task.taskName, body: "${task.taskDescription}");
                  NotificationApi().showNotification(
                      id: 0, body: _taskName, title: "Added a new todo");
                  context.read<TaskBloc>().add(AddTask(task: task));
                  print("epoch: " +
                      DateTime.now().microsecondsSinceEpoch.toString());
                  // await TaskPreference.saveTask(taskName: _taskName, createdTime: DateTime.now(), dueTime: _pickDate!,taskDescription: _taskDescription);
                  Navigator.pop(context, 'Save');
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => const Home()));
                },
                child: const Text('Save')),
          ],
        );
      }),
    );
  }
}
