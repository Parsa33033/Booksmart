

import 'package:booksmart/states/language_state.dart';
import 'package:booksmart/states/word_state.dart';

class SetWordListAction {
  WordListState payload;
  SetWordListAction(this.payload);
}
