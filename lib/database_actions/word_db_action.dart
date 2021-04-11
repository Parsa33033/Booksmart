
import 'package:booksmart/actions/word_action.dart';
import 'package:booksmart/config/database.dart';
import 'package:booksmart/config/store.dart';
import 'package:booksmart/converters/word_converter.dart';
import 'package:booksmart/domains/word_domain.dart';
import 'package:booksmart/states/app_state.dart';
import 'package:booksmart/states/word_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';

Future<List<WordState>> getAllWordsFromDb(BuildContext context) async {
  BooksmartDatabase db = await getDatabase();
  List<WordDomain> wordDomainList = await db.wordDao.findAllWordDomains();
  List<WordState> wordStateList = wordDomainList.map((wordDomain) => convertWordDomainToWordState(wordDomain)).toList();
  Store<AppState> store = getStore(context);
  store.dispatch(SetWordListAction(WordListState(wordStateList)));
  return wordStateList;
}

Future<List<WordState>> getAllWordsWithTimePassedFromDb(BuildContext context) async {
  BooksmartDatabase db = await getDatabase();
  List<WordDomain> wordDomainList = await db.wordDao.findWordDomainByPassedReviewTimeAndPassedBox(DateTime.now().millisecondsSinceEpoch, 32);
  // List<WordState> words = (await getAllWordsFromDb(context)).where((e) => e.nextReviewTime.isBefore(DateTime.now())).toList();
  List<WordState> wordStateList = wordDomainList.map((wordDomain) => convertWordDomainToWordState(wordDomain)).toList();
  return wordStateList;
}