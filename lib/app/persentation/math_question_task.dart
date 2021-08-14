import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:questions_task/app/core/configs.dart';
import 'package:questions_task/app/model/math_question.model.dart';
import 'package:questions_task/app/repo/question-repo.dart';

void onStart() {
  final repository = QuestionRepo();

  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();

  service.onDataReceived.listen((event) {
    switch (event!["action"]) {
      case Config.addKey:
        repository.questions.add(MathQuestion.fromJson(event['question']));
        service.sendData({
          Config.questionsListKey:
              json.encode(repository.questions.map((question) => question.toJson()).toList())
        });
        break;
      case Config.questionsListKey:
        service.sendData({
          Config.questionsListKey:
              json.encode(repository.questions.map((question) => question.toJson()).toList())
        });
        break;
    }
  });

  service.setForegroundMode(false);

  Timer.periodic(Duration(seconds: 1), (timer) async {
    repository.executeScheduledQuestion((question) {
      service.setNotificationInfo(
          title: 'Solved',
          content: '${question.firstNum} ${question.operator} ${question.secondNum} = ${question.result}');

      question.completed = true;
      service.sendData({
        Config.questionsListKey:
            json.encode(repository.questions.map((q) => q.toJson()).toList())
      });
    });
    if (!(await service.isServiceRunning())) timer.cancel();
  });
}
