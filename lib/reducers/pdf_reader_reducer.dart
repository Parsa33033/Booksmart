

import 'package:booksmart/actions/pdf_reader_action.dart';
import 'package:booksmart/states/app_state.dart';
import 'package:booksmart/states/pdf_reader_state.dart';

AppState pdfReaderReducer(AppState state, dynamic action) {
  if (action is SetPdfReaderAction) {
    state.pdfReaderState = action.payload;
    return state;
  } else {
    return state;
  }
}