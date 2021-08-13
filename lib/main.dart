import 'package:flutter/material.dart';
import 'package:questions_task/app/pages/add_question.page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Question App',
      theme: ThemeData(
        primaryColor: Colors.pink,
        accentColor: Colors.white30,
        primarySwatch: Colors.pink,
      ),
      routes: {
        AddQuestionPage.ROUTE_NAME: (context) => AddQuestionPage(),
      },
      initialRoute: AddQuestionPage.ROUTE_NAME,
      debugShowCheckedModeBanner: false,
    );
  }
}
