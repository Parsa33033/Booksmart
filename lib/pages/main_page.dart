

import 'dart:io';

import 'package:booksmart/pages/memorize_page.dart';
import 'package:booksmart/pages/reader_page.dart';
import 'package:booksmart/pages/sentence_list_page.dart';
import 'package:booksmart/pages/settings_page.dart';
import 'package:booksmart/pages/world_list_page.dart';
import 'package:booksmart/states/word_state.dart';
// import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gx_file_picker/gx_file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int selectedIndex;
  Widget content;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  String lang = "english";
  String langT = "farsi";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedIndex = 0;
    content = ReaderPage(openDrawer);
  }

  openDrawer() {
    scaffoldKey.currentState.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      // appBar: AppBar(
      //   title: InkWell(
      //     child:
      // ),
      drawer: Drawer(
        child: Container(
          width: 300,
          height: MediaQuery.of(context).size.height,
          color: Colors.grey,
          padding: EdgeInsets.only(bottom: 10, top: 30, left: 20, right: 40),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  child: Container(
                      padding: EdgeInsets.only(top: 15, bottom: 10),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Icon(Icons.book, color: Colors.white,),
                          ),
                          Text("Read", style: TextStyle(fontSize: 20, color: Colors.white),),
                        ],
                      )
                  ),
                  onTap: () {
                    setState(() {
                      content = ReaderPage(openDrawer);
                    });
                  },
                ),
                Container(
                  height: 15,
                  child: Divider(color: Colors.white,),
                ),
                InkWell(
                  child: Container(
                      padding: EdgeInsets.only(top: 15, bottom: 10),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Icon(Icons.memory, color: Colors.white,),
                          ),
                          Text("Memorize Vocab", style: TextStyle(fontSize: 20, color: Colors.white),),
                        ],
                      )
                  ),
                  onTap: () {
                    // setState(() {
                    //   content = MemorizePage();
                    // });
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => MemorizePage()));
                  },
                ),
                Container(
                  height: 15,
                  child: Divider(color: Colors.white,),
                ),
                InkWell(
                  child: Container(
                      padding: EdgeInsets.only(top: 15, bottom: 10),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Icon(Icons.list, color: Colors.white,),
                          ),
                          Text("Word List", style: TextStyle(fontSize: 20, color: Colors.white),),
                        ],
                      )
                  ),
                  onTap: () {
                    // setState(() {
                    //   content = WordListPage();
                    // });
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => WordListPage()));
                  },
                ),
                Container(
                  height: 15,
                  child: Divider(color: Colors.white,),
                ),
                InkWell(
                  child: Container(
                      padding: EdgeInsets.only(top: 15, bottom: 10),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Icon(Icons.list, color: Colors.white,),
                          ),
                          Text("Sentence List", style: TextStyle(fontSize: 20, color: Colors.white),),
                        ],
                      )
                  ),
                  onTap: () {
                    // setState(() {
                    //   content = SentenceListPage();
                    // });
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => SentenceListPage()));
                  },
                ),
                Container(
                  height: 15,
                  child: Divider(color: Colors.white,),
                ),
                InkWell(
                  child: Container(
                      padding: EdgeInsets.only(top: 15, bottom: 10),
                      child: Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Icon(Icons.settings, color: Colors.white,),
                          ),
                          Text("Settings", style: TextStyle(fontSize: 20, color: Colors.white),),
                        ],
                      )
                  ),
                  onTap: () async {
                    showDialog(
                      context: context,
                      child: SettingsPage()
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Container(
        child: content,
      ),
    );
  }

}