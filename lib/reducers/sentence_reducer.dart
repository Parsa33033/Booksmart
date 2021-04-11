

import 'package:booksmart/actions/sentence_action.dart';
import 'package:booksmart/states/app_state.dart';

AppState sentenceReducer(AppState state, dynamic action) {
  if (action is SetSentenceListStateAction) {
    state.sentenceListState.sentences = action.payload.sentences ?? state.sentenceListState.sentences;
    return state;
  } else {
    return state;
  }
}