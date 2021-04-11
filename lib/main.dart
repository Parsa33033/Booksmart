import 'package:booksmart/actions/language_action.dart';
import 'package:booksmart/actions/word_action.dart';
import 'package:booksmart/config/store.dart';
import 'package:booksmart/pages/main_page.dart';
import 'package:booksmart/reducers/language_reducer.dart';
import 'package:booksmart/reducers/memorize_reducer.dart';
import 'package:booksmart/reducers/pdf_reader_reducer.dart';
import 'package:booksmart/reducers/sentence_reducer.dart';
import 'package:booksmart/reducers/word_reducer.dart';
import 'package:booksmart/states/app_state.dart';
import 'package:booksmart/states/language_state.dart';
import 'package:flutter/material.dart';
import 'package:mlkit_translate/mlkit_translate.dart';
import 'package:redux/redux.dart';

Store<AppState> store;

void main() {
  final reducer = combineReducers<AppState>([
    TypedReducer<AppState, dynamic>(wordReducer),
    TypedReducer<AppState, dynamic>(pdfReaderReducer),
    TypedReducer<AppState, dynamic>(languageReducer),
    TypedReducer<AppState, dynamic>(memorizeReducer),
    TypedReducer<AppState, dynamic>(sentenceReducer),
  ]);
  store = Store<AppState>(reducer, initialState: appStateInit);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  void init() async {
    String langIn = await getFromStorage(LANG_IN);
    String langOut = await getFromStorage(LANG_OUT);
    getStore(context).dispatch(SetLanguageStateAction(LanguageState(langIn, langOut)));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Booksmart',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MainPage()
    );
  }
}


