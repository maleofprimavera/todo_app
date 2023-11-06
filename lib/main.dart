import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_app/utils/task_shared_preference.dart';
import 'package:todo_app/widget/home.dart';
import 'bloc/task_bloc.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TaskPreference.init();
  // TaskPreference.saveTask(taskName: "Hello", createdTime: DateTime.now(), dueTime: DateTime.now().add(Duration(days: 3)));
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: 'Flutter ToDo List Demo',
        theme: ThemeData(
          colorScheme: const ColorScheme.light(
              background: Colors.white,
              // onBackground: Colors.black,
              primary: Color.fromARGB(255,40,40,81),
              onPrimary: Colors.white,
              secondary: Colors.teal,
              onSecondary: Colors.white,
          ),
        ),
        home:BlocProvider(
          create: (BuildContext context) => TaskBloc(),
          child: const Home(),)
    );
  }
}