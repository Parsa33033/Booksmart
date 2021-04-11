

import 'package:booksmart/model/sentence.dart';
import 'package:floor/floor.dart';

@entity
class SentenceDomain{
  @PrimaryKey(autoGenerate: true)
  final int id;

  final String sentence;

  final String category;

  SentenceDomain(this.id, this.sentence, this.category);
}