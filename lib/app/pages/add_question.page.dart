import 'package:flutter/material.dart';

import 'components/form.component.dart';
import 'components/tab_controller.component.dart';

class AddQuestionPage extends StatefulWidget {
  static const String ROUTE_NAME = 'ADD_QUESTION_ROUTE';

  @override
  _AddQuestionPageState createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Questions Task')),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            FormWidget(),
            Expanded(
              child: TabControllerWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
