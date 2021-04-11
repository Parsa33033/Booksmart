

import 'package:booksmart/states/language_state.dart';
import 'package:booksmart/states/memorize_state.dart';
import 'package:booksmart/states/pdf_reader_state.dart';
import 'package:booksmart/states/sentence_state.dart';
import 'package:booksmart/states/word_state.dart';

final AppState appStateInit = AppState(
  wordListState: wordListStateInit,
  pdfReaderState: pdfReaderStateInit,
  languageState: languageStateInit,
  memorizeState: memorizeStateInit,
  sentenceListState: sentenceListStateInit
);

class AppState {
  WordListState wordListState;
  PdfReaderState pdfReaderState;
  LanguageState languageState;
  MemorizeState memorizeState;
  SentenceListState sentenceListState;
  AppState({this.wordListState, this.pdfReaderState, this.languageState, this.memorizeState, this.sentenceListState});
}