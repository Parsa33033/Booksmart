
import 'package:booksmart/config/database.dart';
import 'package:booksmart/converters/sentence_converter.dart';
import 'package:booksmart/model/sentence.dart';
import 'package:booksmart/states/sentence_state.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SentenceGrabber extends StatefulWidget {
  String sentence;

  SentenceGrabber(this.sentence);

  @override
  _SentenceGrabberState createState() => _SentenceGrabberState();
}

class _SentenceGrabberState extends State<SentenceGrabber> {

  SentenceCategory sentenceCategory;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sentenceCategory = SentenceCategory.spiritual;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            flex: 5,
            child: SingleChildScrollView(
              child: Text(this.widget.sentence),
            ),
          ),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
                child: DropdownButton(
                  items: SentenceCategory.values.map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(EnumToString.convertToString(e)))).toList(),
                  value: sentenceCategory,
                  onChanged: (category) {
                    setState(() {
                      sentenceCategory = category;
                    });
                  },
                )
            ),
          ),
          Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: RaisedButton(
                          child: Text("Save"),
                          onPressed: () async {
                            BooksmartDatabase db = await getDatabase();
                            SentenceState sentenceState = SentenceState(null, this.widget.sentence, sentenceCategory);
                            db.sentenceDao.insertSentenceDomain(convertSentenceStateToSentenceDomain(sentenceState));
                            Navigator.of(context).pop("dialog");
                          },
                        ),
                      ),
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
                      ),
                    ),
                  ],
                ),
              )
          )
        ],
      ),
    );
  }
}