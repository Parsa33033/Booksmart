

import 'package:booksmart/actions/memorize_action.dart';
import 'package:booksmart/config/database.dart';
import 'package:booksmart/config/store.dart';
import 'package:booksmart/converters/word_converter.dart';
import 'package:booksmart/database_actions/word_db_action.dart';
import 'package:booksmart/domains/word_domain.dart';
import 'package:booksmart/states/app_state.dart';
import 'package:booksmart/states/word_state.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

class MemorizePage extends StatefulWidget {
  @override
  _MemorizePageState createState() => _MemorizePageState();
}

class _MemorizePageState extends State<MemorizePage> {
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  List<WordState> list = List();

  WordState word;

  TextEditingController _wordTED = TextEditingController();
  TextEditingController _translationTED = TextEditingController();
  TextEditingController _exampleTED = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getWordsWithTimePassed();
  }

  getWordsWithTimePassed() async {
    list = await getAllWordsWithTimePassedFromDb(context);
    setState(() {
      if (list.isNotEmpty) {
        word = list[0];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 90,
            child: Container(
                color: Colors.blueAccent,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 2),
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 2),
                  child: FlipCard(
                    key: cardKey,
                    speed: 100,
                    flipOnTouch: false,
                    front: InkWell(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: word != null ? Center(
                          child: Text(word.word, style: TextStyle(fontSize: 22),),
                        ) : Text(""),
                      ),
                      onTap: () {
                        if (word != null)
                          cardKey.currentState.toggleCard();
                      },
                    ),
                    back: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 10,
                              child: word != null ?
                              Align(
                                alignment: Alignment.center,
                                child: Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: InkWell(
                                      child: Text(word.word, style: TextStyle(fontSize: 22),),
                                      onLongPress: () {
                                        _wordTED.text = word.word;
                                        editText(context, word, _wordTED, () async {
                                          BooksmartDatabase db = await getDatabase();
                                          setState(() {
                                            word.word = _wordTED.text;
                                          });
                                          db.wordDao.updateWordDomain(convertWordStateToWordDomain(word));
                                        });
                                      },
                                    )
                                ),
                              )
                                  : Text(""),
                            ),
                            Expanded(
                              flex: 20,
                              child: word != null ?
                              Align(
                                alignment: Alignment.center,
                                child: Directionality(
                                    textDirection: TextDirection.ltr,
                                    child: InkWell(
                                      child: Text(word.translation, style: TextStyle(fontSize: 22),),
                                      onLongPress: () {
                                        _translationTED.text = word.translation;
                                        editText(context, word, _translationTED, () async {
                                          BooksmartDatabase db = await getDatabase();
                                          setState(() {
                                            word.translation = _translationTED.text;
                                          });
                                          db.wordDao.updateWordDomain(convertWordStateToWordDomain(word));
                                        });
                                      },
                                    )
                                ),
                              )
                                  : Text(""),
                            ),
                            Expanded(
                                flex: 30,
                                child: Padding(
                                  padding: EdgeInsets.all(15),
                                  child: word != null ?
                                  Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: SingleChildScrollView(
                                          child: InkWell(
                                            child: Text(word.example, style: TextStyle(fontSize: 14),),
                                            onLongPress: () {
                                              _exampleTED.text = word.example;
                                              editText(context, word, _exampleTED, () async {
                                                BooksmartDatabase db = await getDatabase();
                                                setState(() {
                                                  word.example = _exampleTED.text;
                                                });
                                                db.wordDao.updateWordDomain(convertWordStateToWordDomain(word));
                                              });
                                            },
                                          )
                                      )
                                  ): Text(""),
                                )
                            ),
                            Expanded(
                                flex: 10,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 10, right: 10),
                                          child: RaisedButton(
                                            color: Colors.red,
                                            child: Text("Did not know", style: TextStyle(color: Colors.white),),
                                            onPressed: () async {
                                              word.boxNum = 1;
                                              word.nextReviewTime = DateTime.now().add(Duration(minutes: 5));
                                              WordDomain wordDomain = convertWordStateToWordDomain(word);
                                              final db = await getDatabase();
                                              await db.wordDao.updateWordDomain(wordDomain);
                                              list.removeWhere((element) => element.id == word.id);
                                              cardKey.currentState.toggleCard();
                                              if (list.isEmpty) {
                                                getWordsWithTimePassed();
                                                if (list.isEmpty) word = null;
                                              } else {
                                                setState(() {
                                                  word = list[0];
                                                });
                                              }

                                              Store<AppState> store = getStore(context);
                                              store.state.memorizeState.reviewCount ++;
                                              store.dispatch(SetMemorizeStateAction(store.state.memorizeState));
                                            },
                                          ),
                                        )
                                    ),
                                    Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.only(left: 10, right: 10),
                                          child: RaisedButton(
                                            color: Colors.green,
                                            child: Text("Knew", style: TextStyle(color: Colors.white),),
                                            onPressed: () async {
                                              word.boxNum *= 2;
                                              if (word.boxNum >= 32) word.learned = true;
                                              word.nextReviewTime = DateTime.now().add(Duration(days: word.boxNum));
                                              WordDomain wordDomain = convertWordStateToWordDomain(word);
                                              final db = await getDatabase();
                                              await db.wordDao.updateWordDomain(wordDomain);
                                              list.removeWhere((element) => element.id == word.id);
                                              cardKey.currentState.toggleCard();
                                              if (list.isEmpty) {
                                                getWordsWithTimePassed();
                                                if (list.isEmpty) word = null;
                                              } else {
                                                setState(() {
                                                  word = list[0];
                                                });
                                              }

                                              Store<AppState> store = getStore(context);
                                              store.state.memorizeState.rememberedCount ++;
                                              store.dispatch(SetMemorizeStateAction(store.state.memorizeState));
                                            },
                                          ),
                                        )
                                    ),
                                  ],
                                )
                            )
                          ],
                        )
                    ),
                  ),
                )
            ),
          ),
          Expanded(
            flex: 10,
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              color: Colors.blueAccent, child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text("words reviewed: ${getStore(context).state.memorizeState.reviewCount}", style: TextStyle(color: Colors.white)),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text("words remembered: ${getStore(context).state.memorizeState.rememberedCount}", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            )),
          )
        ],
      )
    );
  }

  editText(BuildContext context, WordState wordState, TextEditingController controller, Function func) {
    showDialog(
      context: context,
      child: Dialog(
        child: Container(
          height: 230,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    controller: controller,
                    maxLines: 4,
                  ),
                )
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: RaisedButton(
                          child: Text("Save"),
                          onPressed: () async {
                            await func();
                            Navigator.of(context).pop("dialog");
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: RaisedButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.of(context).pop("dialog");
                          },
                        ),
                      ),
                    ),
                  ],
                )
              )
            ],
          ),
        ),
      )
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _wordTED.dispose();
    _translationTED.dispose();
    _exampleTED.dispose();
    super.dispose();
  }

}