


import 'package:booksmart/actions/language_action.dart';
import 'package:booksmart/actions/word_action.dart';
import 'package:booksmart/states/app_state.dart';
import 'package:booksmart/states/language_state.dart';

AppState languageReducer(AppState state, dynamic action) {
  if (action is SetLanguageStateAction) {
    LanguageState languageState = state.languageState;
    languageState = action.payload != null ? action.payload : languageState;
    state.languageState = languageState;
    return state;
  } else {
    return state;
  }
}