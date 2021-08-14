import 'package:flutter/material.dart';
import 'package:questions_task/app/model/math_question.model.dart';

class QuestionRow extends StatelessWidget {
  const QuestionRow({
    required this.question,
    required this.completed,
  });

  final MathQuestion question;
  final bool completed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12, width: 2),
      ),
      child: Column(
        children: [
          Text(
            completed
                ? '${question.firstNum} ${question.operator} ${question.secondNum} = ${question.result}'
                : '${question.firstNum} ${question.operator} ${question.secondNum} = ??',
            style: TextStyle(fontSize: 25),
          ),
          Text('Delay: ${question.seconds} seconds'),
        ],
      ),
    );
  }
}
