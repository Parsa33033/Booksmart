

import 'package:booksmart/config/database.dart';
import 'package:booksmart/converters/sentence_converter.dart';
import 'package:booksmart/domains/sentence_domain.dart';
import 'package:booksmart/model/sentence.dart';
import 'package:booksmart/states/sentence_state.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SentenceListPage extends StatefulWidget {
  @override
  _SentenceListPageState createState() => _SentenceListPageState();
}

class _SentenceListPageState extends State<SentenceListPage> {
  List<SentenceState> l = List();
  List<SentenceState> list = List();
  SentenceCategory sentenceCategory;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setSentenceList();
  }

  setSentenceList() async {
    BooksmartDatabase db = await getDatabase();
    List<SentenceDomain> sentenceDomainList = await db.sentenceDao.findAllSentenceDomain();
    setState(() {
      list = sentenceDomainList.map((e) => convertSentenceDomainToSentenceState(e)).toList();
      l = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: "sentence_search_hero",
        child: Icon(Icons.search),
        onPressed: () {
          showDialog(context: context,
              child: Dialog(
                child: Container(
                  width: 200,
                  child: DropdownButton(
                    isExpanded: true,
                    items: SentenceCategory.values.map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(EnumToString.convertToString(e)))).toList(),
                    value: sentenceCategory,
                    onChanged: (category) {
                      setState(() {
                        sentenceCategory = category;
                        l = list.where((e) {
                          return e.category == sentenceCategory;
                        }).toList();
                        Navigator.of(context).pop("dialog");
                      });
                    },
                  ),
                ),
              )
          );
        },
      ),
      body: Container(
        child: ListView.builder(
          itemCount: l.length,
          itemBuilder: (context, pos) {
            SentenceState sentenceState = l[pos];
            return InkWell(
              child: Container(
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey))
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(10),
                  title: Text(sentenceState.sentence),
                  onLongPress: () {
                    showDialog(
                      context: context,
                      child: Dialog(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: 100
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text("Do you want to delete this sentence?")
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
                                                child: Text("Yes"),
                                                onPressed: () async {
                                                  BooksmartDatabase db = await getDatabase();
                                                  await db.sentenceDao.deleteSentenceDomain(convertSentenceStateToSentenceDomain(sentenceState));
                                                  setState(() {
                                                    l.removeWhere((e) => e.id == sentenceState.id);
                                                  });
                                                  setSentenceList();
                                                  Navigator.of(context).pop("dialog");
                                                },
                                              ),
                                            )
                                        ),
                                        Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.all(5),
                                              child: RaisedButton(
                                                child: Text("No"),
                                                onPressed: ()  {
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
                  // subtitle: Text(EnumToString.convertToString(sentenceState.category)),
                ),
              ),
              onTap: () {

              },
            );
          },
        ),
      ),
    );
  }
}