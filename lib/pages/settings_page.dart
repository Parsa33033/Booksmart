import 'dart:io';

import 'package:booksmart/actions/language_action.dart';
import 'package:booksmart/actions/word_action.dart';
import 'package:booksmart/config/database.dart';
import 'package:booksmart/config/store.dart';
import 'package:booksmart/domains/sentence_domain.dart';
import 'package:booksmart/domains/word_domain.dart';
import 'package:booksmart/pages/components/preloader.dart';
import 'package:booksmart/states/app_state.dart';
import 'package:booksmart/states/language_state.dart';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gx_file_picker/gx_file_picker.dart';
import 'package:language_pickers/language_picker_dropdown.dart';
import 'package:language_pickers/language_pickers.dart';
import 'package:language_pickers/languages.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:redux/redux.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String lang_in = "en";
  String lang_out = "fa";
  final String BOOKSMART_WORD_CSV = "booksmart_words.csv";
  final String BOOKSMART_SENTENCE_CSV = "booksmart_sentences.csv";
  Language _selectedDropdownLanguageIn =
      LanguagePickerUtils.getLanguageByIsoCode('en');
  Language _selectedDropdownLanguageOut =
      LanguagePickerUtils.getLanguageByIsoCode('fa');

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setLang();
  }

  setLang() {
    AppState state = getStore(context).state;
    String lin = state.languageState.langIn;
    String lout = state.languageState.langOut;
    setState(() {
      lang_in = lin;
      lang_out = lout;
      _selectedDropdownLanguageIn =
          LanguagePickerUtils.getLanguageByIsoCode(lang_in);
      _selectedDropdownLanguageOut =
          LanguagePickerUtils.getLanguageByIsoCode(lang_out);
    });
  }

  Future<void> exportDb(String fileName, bool withToast) async {
    preloader(context);
    // Directory dbDir = await getApplicationDocumentsDirectory();
    // String dbDirPath = dbDir.parent.parent.parent.parent.path + "/data/com.booksmart.booksmart";
    Directory dir = await getExternalStorageDirectory();
    // print(dbDir.parent.parent.parent.parent.path + "/data/com.booksmart.booksmart");
    // Directory dir = await DownloadsPathProvider.downloadsDirectory;
    // File f = File(dbDirPath + "/databases/${fileName}");
    BooksmartDatabase db = await getDatabase();

    try {
      List<WordDomain> wordDomainList = await db.wordDao.findAllWordDomains();
      List<List<dynamic>> wordDomainListAsList =
      wordDomainList.map((e) => convertWordDomainToList(e)).toList();
      String wordCsv = ListToCsvConverter().convert(wordDomainListAsList);
      File wordfile = File(
          "${dir.parent.parent.parent.parent.path}/Download/${BOOKSMART_WORD_CSV}");
      Permission.storage.request().then((value) {
        // file.copy("${dir.parent.parent.parent.parent.path}/Download/${fileName}");
        wordfile.writeAsString(wordCsv);
        if (withToast) {
          Fluttertoast.showToast(
              msg: "List of words exported to Downloads",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      });
    } catch (e) {

    }

    try {
      List<SentenceDomain> sentenceDomainList = await db.sentenceDao.findAllSentenceDomain();
      List<List<dynamic>> sentenceDomainListAsList =
      sentenceDomainList.map((e) => convertSentenceDomainToList(e)).toList();
      String sentenceCsv = ListToCsvConverter().convert(sentenceDomainListAsList);
      File sentencefile = File(
          "${dir.parent.parent.parent.parent.path}/Download/${BOOKSMART_SENTENCE_CSV}");
      Permission.storage.request().then((value) {
        sentencefile.writeAsString(sentenceCsv);
        if (withToast) {
          Fluttertoast.showToast(
              msg: "List of sentences exported to Downloads",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      });
    } catch(e) {}

    // List<SentenceDomain> sentenceDomainList = await db.sentenceDao.findAllSentenceDomain();
    // print("----->${csv}");

    Navigator.of(context).pop("dialog");
  }

  List<dynamic> convertWordDomainToList(WordDomain wordDomain) {
    List l = List()
      ..add(wordDomain.id)
      ..add(wordDomain.word)
      ..add(wordDomain.translation)
      ..add(wordDomain.timeOfReview)
      ..add(wordDomain.example)
      ..add(wordDomain.nextReviewTime)
      ..add(wordDomain.boxNum)
      ..add(wordDomain.learned);
    return l;
  }

  WordDomain convertListToWordDomain(List l) {
    return WordDomain(null, l[1], l[2], l[3], l[4], l[5], l[6], l[7] == "true" ? true : false);
  }

  List<dynamic> convertSentenceDomainToList(SentenceDomain sentenceDomain) {
    List l = List()
      ..add(sentenceDomain.id)
      ..add(sentenceDomain.sentence)
      ..add(sentenceDomain.category);
    return l;
  }

  SentenceDomain convertListToSentenceDomain(List l) {
    return SentenceDomain(null, l[1], l[2]);
  }

  Future<void> importDB() async {
    final file = await FilePicker.getFile();
    String csv = await file.readAsString();
    List<List<dynamic>> l = CsvToListConverter().convert(csv);
    BooksmartDatabase db = await getDatabase();
    if (file.path.contains(BOOKSMART_WORD_CSV))
      for (final wordString in l) {
        WordDomain wordDomain = convertListToWordDomain(wordString);
        await db.wordDao.insertWordDomain(wordDomain);
      }
    else if (file.path.contains(BOOKSMART_SENTENCE_CSV)) {
      for (final sentenceString in l) {
        SentenceDomain sentenceDomain = convertListToSentenceDomain(sentenceString);
        await db.sentenceDao.insertSentenceDomain(sentenceDomain);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Dialog(
          child: Container(
              height: 250,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Text("input language:"),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(5),
                      height: 50,
                      child: LanguagePickerDropdown(
                        initialValue: lang_in,
                        itemBuilder: _buildDropdownItem,
                        onValuePicked: (Language language) async {
                          _selectedDropdownLanguageIn = language;
                          String isoCode = _selectedDropdownLanguageIn.isoCode;
                          await saveToStorage(LANG_IN, isoCode);
                          Store<AppState> store = getStore(context);
                          store.state.languageState.langIn = isoCode;
                          store.dispatch(SetLanguageStateAction(
                              store.state.languageState));
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Text("output language:"),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(5),
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: LanguagePickerDropdown(
                        initialValue: lang_out,
                        itemBuilder: _buildDropdownItem,
                        onValuePicked: (Language language) async {
                          _selectedDropdownLanguageOut = language;
                          String isoCode = _selectedDropdownLanguageOut.isoCode;
                          await saveToStorage(LANG_OUT, isoCode);
                          Store<AppState> store = getStore(context);
                          store.state.languageState.langOut = isoCode;
                          store.dispatch(SetLanguageStateAction(
                              store.state.languageState));
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: RaisedButton(
                                child: Text("Export Database"),
                                onPressed: () async {
                                  await exportDb("booksmart.db", true);
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: RaisedButton(
                                child: Text("Import Database"),
                                onPressed: () async {
                                  await importDB();
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ))),
    );
  }

  Widget _buildDropdownItem(Language language) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 8.0,
        ),
        Text("${language.name} (${language.isoCode})"),
      ],
    );
  }
}
