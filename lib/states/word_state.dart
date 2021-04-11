import 'package:booksmart/model/word.dart';

final WordListState wordListStateInit = WordListState(List());

class WordListState {
  List<WordState> words;

  WordListState(this.words);
}

class WordState extends Word {
  WordState(int id, String word, String translation, DateTime timeOfReview,
      String example, DateTime nextReviewTime, int boxNum, bool learned)
      : super(id, word, translation, timeOfReview, example, nextReviewTime,
            boxNum, learned);

}
