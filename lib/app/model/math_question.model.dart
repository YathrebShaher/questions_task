import 'dart:convert';

enum MathOperation { ADD, SUB, MUL, DIV }

extension OperationExtension on MathOperation {
  String get symbol {
    switch (this) {
      case MathOperation.ADD:
        return '+';
      case MathOperation.SUB:
        return '-';
      case MathOperation.MUL:
        return '*';
      case MathOperation.DIV:
        return '/';
      default:
        return '+';
    }
  }

  String get name {
    switch (this) {
      case MathOperation.ADD:
        return 'Addition';
      case MathOperation.SUB:
        return 'Subtraction';
      case MathOperation.MUL:
        return 'Multiplication';
      case MathOperation.DIV:
        return 'Division';
      default:
        return 'Addition';
    }
  }
}

class MathQuestion {
  final double firstNum;
  final double secondNum;
  final String operator;
  final DateTime duration;
  final int seconds;
  bool completed;
  double get result {
    switch(operator){
      case '+':
        return firstNum + secondNum;
      case '-':
        return firstNum - secondNum;
      case '*':
        return firstNum * secondNum;
      case '/':
        return firstNum / secondNum;
    }
    return 0;
  }

  MathQuestion({
    required this.firstNum,
    required this.secondNum,
    required this.operator,
    required this.duration,
    required this.seconds,

    this.completed = false
  });

  // MathQuestion copyWith({
  //   double? firstNum,
  //   double? secondNum,
  //   MathOperation? operator,
  //   DateTime? duration,
  //   bool? completed,
  // }) {
  //   return MathQuestion(
  //       firstNum: firstNum ?? this.firstNum,
  //       secondNum : secondNum ?? this.secondNum,
  //       operator: operator ?? this.operator,
  //       duration: duration ?? this.duration,
  //       completed: completed??this.completed
  //   );
  // }

  Map<String, dynamic> toMap() {
    return {
      'firstNum': firstNum,
      'secondNum': secondNum,
      'operator': operator,
      'duration': duration.millisecondsSinceEpoch,
      'completed': completed,
      'seconds': seconds,
    };
  }

  factory MathQuestion.fromMap(Map<String, dynamic> map) {
    return MathQuestion(
      firstNum: map['firstNum'],
      secondNum: map['secondNum'],
      operator: map['operator'],
      seconds: map['seconds'],
      completed: map['completed'],
      duration: DateTime.fromMillisecondsSinceEpoch(map['duration']),
    );
  }

  String toJson() => json.encode(toMap());

  factory MathQuestion.fromJson(String source) =>
      MathQuestion.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MathQuestion(firstNum: $firstNum, secondNum: $secondNum, operator: $operator, duration: $duration)';
  }
}