import 'package:SeeThroughMe/login_form.dart';
import 'package:flutter/material.dart';
import 'package:SeeThroughMe/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(SeeThroughMeApp());
}

class SeeThroughMeApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'SeeThroughMe',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginForm());
  }
}