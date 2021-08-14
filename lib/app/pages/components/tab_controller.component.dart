import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:questions_task/app/core/configs.dart';
import 'package:questions_task/app/model/math_question.model.dart';
import 'package:questions_task/app/pages/components/question_row.component.dart';

class TabControllerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: TabBar(
                indicatorColor: Theme.of(context).primaryColor,
                isScrollable: true,
                tabs: [
                  Text(
                    'Pending Questions',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  Text(
                    'Completed Questions',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<Map<String, dynamic>?>(
                  stream: FlutterBackgroundService().onDataReceived,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Center(child: Text('Nothing to show'));
                    final data = snapshot.data!;

                    final List<MathQuestion> list =
                        (json.decode(data[Config.questionsListKey]) as List)
                            .map((question) => MathQuestion.fromJson(question))
                            .toList();

                    return TabBarView(
                      children: [
                        list
                                    .where((element) => !element.completed)
                                    .toList()
                                    .length ==
                                0
                            ? Center(
                                child: const Text('Nothing to show'),
                              )
                            : ListView(
                                children: [
                                  for (final question in list
                                      .where((element) => !element.completed)
                                      .toList())
                                    QuestionRow(
                                      question: question,
                                      completed: false,
                                    ),
                                ],
                              ),
                        list
                                    .where((element) => element.completed)
                                    .toList()
                                    .length ==
                                0
                            ? Center(
                                child: const Text('Nothing to show'),
                              )
                            : ListView(
                                children: [
                                  for (final question in list
                                      .where((element) => element.completed)
                                      .toList())
                                    QuestionRow(
                                      question: question,
                                      completed: true,
                                    ),
                                ],
                              ),
                      ],
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
