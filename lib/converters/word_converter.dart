import 'package:booksmart/domains/word_domain.dart';
import 'package:booksmart/states/word_state.dart';

WordState convertWordDomainToWordState(WordDomain wordDomain) {
  WordState wordState;
  if (wordDomain != null) {
    wordState = WordState(
        wordDomain.id,
        wordDomain.word,
        wordDomain.translation,
        DateTime.parse(wordDomain.timeOfReview),
        wordDomain.example,
        DateTime.fromMillisecondsSinceEpoch(wordDomain.nextReviewTime),
        wordDomain.boxNum,
        wordDomain.learned);
  }
  return wordState;
}

WordDomain convertWordStateToWordDomain(WordState wordState) {
  WordDomain wordDomain;
  if (wordState != null) {
    wordDomain = WordDomain(
        wordState.id,
        wordState.word,
        wordState.translation,
        wordState.timeOfReview.toString(),
        wordState.example,
        wordState.nextReviewTime.millisecondsSinceEpoch,
        wordState.boxNum,
        wordState.learned);
  }
  return wordDomain;
}
