

import 'package:booksmart/model/sentence.dart';

final SentenceListState sentenceListStateInit = SentenceListState(List());

class SentenceListState {
  List<SentenceState> sentences;
  SentenceListState(this.sentences);
}

class SentenceState extends Sentence {
  SentenceState(int id, String sentence, SentenceCategory category) : super(id, sentence, category);
}