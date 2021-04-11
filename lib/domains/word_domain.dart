import 'package:floor/floor.dart';

@entity
class WordDomain {
  @PrimaryKey(autoGenerate: true)
  final int id;

  final String word;

  final String translation;

  final String timeOfReview;

  final String example;

  final int nextReviewTime;

  final int boxNum;

  final bool learned;

  WordDomain(this.id, this.word, this.translation, this.timeOfReview,
      this.example, this.nextReviewTime, this.boxNum, this.learned);
}