
import 'package:booksmart/actions/word_action.dart';
import 'package:booksmart/states/app_state.dart';
import 'package:booksmart/states/word_state.dart';

AppState wordReducer(AppState state, dynamic action) {
  if (action is SetWordListAction) {
    WordListState wordListState = state.wordListState;
    wordListState.words = action.payload != null ? action.payload.words : wordListState.words;
    state.wordListState = wordListState;
    return state;
  } else {
    return state;
  }
}