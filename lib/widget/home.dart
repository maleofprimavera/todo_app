import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/bloc/task_bloc.dart';
import 'package:todo_app/bloc/task_event.dart';
import 'package:todo_app/bloc/task_state.dart';
import 'package:todo_app/widget/task_widget.dart';
import '../model/task_model.dart';
import '../utils/task_shared_preference.dart';
import 'create_task_widget.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void start(List<Map<String, Task>> listTasks) {}
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        lazy: true,
        create: (BuildContext context) => TaskBloc(),
        child: WillPopScope(
            onWillPop: () async {
              // Prevent the Home page from being popped.
              return false;
            },
            child: Scaffold(
              appBar: AppBar(
                title: const Text('TO-DO LIST'),
                centerTitle: true,
              ),
              body: BlocBuilder(bloc: TaskBloc(),builder: (context, state) {
                return FutureBuilder<List<Map<String, Task>>>(
                    future: TaskPreference.getAllTask(),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Map<String, Task>>> snapshot) {
                      TaskStatus _status = TaskStatus.success;
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        _status = TaskStatus.loading;
                        return const CircularProgressIndicator();
                      } else {
                        if (snapshot.hasError) {
                          _status = TaskStatus.error;
                          return Center(
                            child: Text(
                              '${snapshot.error} occurred',
                              style: const TextStyle(fontSize: 18),
                            ),
                          );
                        } else {
                          List<Map<String, Task>>? listTasks = snapshot.data;
                          print(listTasks!.length);
                          context.read<TaskBloc>().add(const TaskStarted());
                          return
                            BlocBuilder<TaskBloc, TaskState>(
                              builder: (context, state) {
                                print(state.tasks.length);
                                (state.tasks.length > 0)
                                    ? state.copyWith(status: TaskStatus.success)
                                    : state;
                                print(state.status);
                                if (state.status == TaskStatus.success)
                                {
                                  // Use your TaskWidget here based on the state
                                  return ListView.builder(
                                    itemCount: state.tasks.length,
                                    itemBuilder: (context, index) {
                                      Task _task =
                                          state.tasks[index].values.first;
                                      String _keyTask =
                                          state.tasks[index].keys.first;
                                      return TaskWidget(
                                        task: _task,
                                        keyTask: _keyTask,
                                      );
                                    },
                                  );
                                } else if (state.status == TaskStatus.loading) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else if (state.status == TaskStatus.error) {
                                  return const Center(
                                    child: Text(
                                      'An error occurred',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  );
                                } else {
                                  return const Center();
                                }
                              },
                            );
                        }
                      }
                    });
              }),
              floatingActionButton: ElevatedButton(
                style: ButtonStyle(side:MaterialStateProperty.all(BorderSide(color: Colors.indigo,width: 3))),
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) {
                    return const CreateTask();
                  },
                ),
                child: Container(
                  width: 100,
                  height: 60,
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Add To-do'), Icon(Icons.add_task)],
                  ),
                ),
              ),

            )));
  }
}