import 'package:questions_task/app/model/math_question.model.dart';

class QuestionRepo{
  List<MathQuestion> questions = [];
  void executeScheduledQuestion(Function(MathQuestion question) callBack) {
    questions.forEach((question) {
      if (question.duration.second == DateTime.now().second) {
        callBack(question);
      }
    });
  }
}