

import 'package:booksmart/actions/word_action.dart';
import 'package:booksmart/config/database.dart';
import 'package:booksmart/config/store.dart';
import 'package:booksmart/converters/word_converter.dart';
import 'package:booksmart/database_actions/word_db_action.dart';
import 'package:booksmart/domains/word_domain.dart';
import 'package:booksmart/states/word_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WordListPage extends StatefulWidget {
  @override
  _WordListPageState createState() => _WordListPageState();
}

class _WordListPageState extends State<WordListPage> {
  List<WordState> list = List();
  List<WordState> l = List();
  TextEditingController _wordTEC = TextEditingController();
  TextEditingController _translationTEC = TextEditingController();
  TextEditingController _exampleTEC = TextEditingController();

  TextEditingController _searchTEC = TextEditingController();
  TextEditingController _boxSearchTEC = TextEditingController();

  Widget listWidget;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setWordList();
  }

  setWordList() async {
    await getAllWordsFromDb(context);
    setState(() {
      list = getStore(context).state.wordListState.words;
      l = list;
      setListView();
    });
  }

  setListView() {

    setState(() {
      listWidget = ListView.builder(
        itemCount: l.length,
        itemBuilder: (context, pos) {
          WordState word = l[pos];
          return InkWell(
            child: Container(
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey))
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(10),
                title: Text("${word.word} - ${word.translation}"),
                subtitle: Text(word.example.length > 100 ? word.example.substring(0, 100) + "..." : word.example),
                trailing: Text("box: ${word.boxNum}"),
              ),
            ),
            onTap: () {
              _wordTEC.text = word.word;
              _translationTEC.text = word.translation;
              _exampleTEC.text = word.example;
              editWord(word);
            },
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.all(5),
            child: FloatingActionButton(
              heroTag: "word_search_hero",
              child: Icon(Icons.search),
              onPressed: () {
                showDialog(
                    context: context,
                    child: Dialog(
                        child: Container(
                            child: Row(
                              children: [
                                Text("search: "),
                                Expanded(
                                  flex: 6,
                                  child: TextField(
                                    controller: _searchTEC,
                                    onChanged: (str) {
                                      setState(() {
                                        if (str == "") {
                                          setState(() {
                                            l = list;
                                          });
                                        } else {
                                          setState(() {
                                            l = list.where((e) => e.word.toLowerCase().contains(str.toLowerCase()) || e.translation.toLowerCase().contains(str.toLowerCase())).toList();
                                          });
                                        }
                                        setListView();
                                      });
                                    },
                                  ),
                                ),
                                Text("box: "),
                                Expanded(
                                  flex: 1,
                                  child: TextField(
                                    controller: _boxSearchTEC,
                                    keyboardType: TextInputType.number,
                                    onChanged: (str) {
                                      setState(() {
                                        if (str == "") {
                                          setState(() {
                                            l = list;
                                          });
                                        } else {
                                          setState(() {
                                            l = list.where((e) => e.boxNum == int.parse(str)).toList();
                                          });
                                        }
                                        setListView();
                                      });
                                    },
                                  ),
                                )
                              ],
                            )
                        )
                    )
                );
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            child: FloatingActionButton(
              heroTag: "word_add_hero",
              child: Icon(Icons.add),
              onPressed: () {
                editWord(null);
              },
            ),
          ),
        ],
      ),
      body: Container(
        child: listWidget
      ),
    );
  }

  editWord(WordState word) {
    if (word == null) {
      _wordTEC.text = "";
      _translationTEC.text = "";
      _exampleTEC.text = "";
    }
    showDialog(
      context: context,
      child: Dialog(
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: _wordTEC,
                  )
                ),
                Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: _translationTEC,
                    )
                ),
                Container(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: _exampleTEC,
                      maxLines: 4,
                    )
                ),
                Container(
                  height: 80,
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          flex: 30,
                          child: Container(
                              height: 80,
                              width: 200,
                              padding: EdgeInsets.all(10),
                              child: RaisedButton(
                                child: Text("Save"),
                                onPressed: () async {
                                  BooksmartDatabase db = await getDatabase();
                                  if (word != null) {
                                    word.word = _wordTEC.text;
                                    word.translation = _translationTEC.text;
                                    word.example = _exampleTEC.text;
                                    WordDomain wordDomain = convertWordStateToWordDomain(word);
                                    setState(() {
                                      list[list.indexWhere((e) => e.id == word.id)] = word;
                                    });
                                    getStore(context).dispatch(SetWordListAction(WordListState(list)));
                                    await db.wordDao.updateWordDomain(wordDomain);
                                    Navigator.of(context).pop("dialog");
                                    setListView();
                                  } else {
                                    word = WordState(null, _wordTEC.text, _translationTEC.text, DateTime.now(),  _exampleTEC.text, DateTime.now(), 1, false);
                                    await db.wordDao.insertWordDomain(convertWordStateToWordDomain(word));
                                    Navigator.of(context).pop("dialog");
                                    setState(() {
                                      l.add(word);
                                    });
                                    setListView();
                                  }
                                },
                              )
                          ),
                        ),
                        word != null ?
                            Expanded(
                              flex: 30,
                              child: Container(
                                  height: 80,
                                  width: 200,
                                  padding: EdgeInsets.all(10),
                                  child: RaisedButton(
                                    child: Text("Delete"),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        child: Dialog(
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                              minHeight: 100,
                                            ),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.all(10),
                                                    child: Text("Are you positive that you want to delete ${word.word}"),
                                                  ),
                                                  Padding(
                                                      padding: EdgeInsets.all(10),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        children: [
                                                          Expanded(
                                                              child: Padding(
                                                                padding: EdgeInsets.all(5),
                                                                child: RaisedButton(
                                                                  child: Text("I'm sure!"),
                                                                  onPressed: () async {
                                                                    BooksmartDatabase db = await getDatabase();
                                                                    db.wordDao.deleteWordDomain(convertWordStateToWordDomain(word));
                                                                    setState(() {
                                                                      l.removeWhere((e) => e.id == word.id);
                                                                    });
                                                                    setListView();
                                                                    Navigator.of(context).pop("dialog");
                                                                    Navigator.of(context).pop("dialog");
                                                                  },
                                                                ),
                                                              )
                                                          ),
                                                          Expanded(
                                                              child: Padding(
                                                                padding: EdgeInsets.all(5),
                                                                child: RaisedButton(
                                                                  child: Text("Exit"),
                                                                  onPressed: () {
                                                                    Navigator.of(context).pop("dialog");
                                                                  },
                                                                ),
                                                              )
                                                          ),
                                                        ],
                                                      )
                                                  ),
                                                ],
                                              ),
                                            )
                                          )
                                        )
                                      );
                                    },
                                  )
                              ),
                            ) :
                        Expanded(
                            flex: 1,
                            child: Container()
                        ),
                        Expanded(
                          flex: 30,
                          child: Container(
                              height: 80,
                              width: 200,
                              padding: EdgeInsets.all(10),
                              child: RaisedButton(
                                child: Text("Exit"),
                                onPressed: () {
                                  Navigator.of(context).pop("dialog");
                                },
                              )
                          ),
                        )
                      ],
                    )
                ),
              ],
            ),
          ),
        ),
      )
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _wordTEC.dispose();
    _translationTEC.dispose();
    _exampleTEC.dispose();
    _searchTEC.dispose();
    _boxSearchTEC.dispose();
    super.dispose();
  }
}