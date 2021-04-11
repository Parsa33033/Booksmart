import 'package:floor/floor.dart';

class Word {
  int id;

  String word;

  String translation;

  DateTime timeOfReview;

  String example;

  DateTime nextReviewTime;

  int boxNum;

  bool learned;

  Word(this.id, this.word, this.translation, this.timeOfReview,
      this.example, this.nextReviewTime, this.boxNum, this.learned);
}