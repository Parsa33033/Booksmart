import 'package:booksmart/domains/sentence_domain.dart';
import 'package:booksmart/model/sentence.dart';
import 'package:booksmart/states/sentence_state.dart';
import 'package:enum_to_string/enum_to_string.dart';

SentenceDomain convertSentenceStateToSentenceDomain(
    SentenceState sentenceState) {
  SentenceDomain sentenceDomain;
  if (sentenceState != null) {
    sentenceDomain = SentenceDomain(sentenceState.id, sentenceState.sentence,
        EnumToString.convertToString(sentenceState.category));
  }
  return sentenceDomain;
}

SentenceState convertSentenceDomainToSentenceState(
    SentenceDomain sentenceDomain) {
  SentenceState sentenceState;
  if (sentenceDomain != null) {
    sentenceState = SentenceState(
        sentenceDomain.id,
        sentenceDomain.sentence,
        EnumToString.fromString(SentenceCategory.values, sentenceDomain.category));
  }
  return sentenceState;
}
