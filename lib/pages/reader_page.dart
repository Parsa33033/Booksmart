import 'dart:io';
import 'package:booksmart/actions/pdf_reader_action.dart';
import 'package:booksmart/config/database.dart';
import 'package:booksmart/config/store.dart';
import 'package:booksmart/constants/keys.dart';
import 'package:booksmart/converters/sentence_converter.dart';
import 'package:booksmart/converters/word_converter.dart';
import 'package:booksmart/domains/book_domain.dart';
import 'package:booksmart/domains/sentence_domain.dart';
import 'package:booksmart/domains/word_domain.dart';
import 'package:booksmart/model/sentence.dart';
import 'package:booksmart/pages/components/sentence_grabber.dart';
import 'package:booksmart/pages/main_page.dart';
import 'package:booksmart/pages/components/preloader.dart';
import 'package:booksmart/states/app_state.dart';
import 'package:booksmart/states/pdf_reader_state.dart';
import 'package:booksmart/states/sentence_state.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gx_file_picker/gx_file_picker.dart';
import 'package:mlkit_translate/mlkit_translate.dart';
import 'package:pdf_text/pdf_text.dart';
import 'package:redux/redux.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:async';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:translator/translator.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:translate/translate.dart';
// import 'package:translator/translator.dart';

// import 'components/translator/google_translator.dart';


class ReaderPage extends StatefulWidget {
  Function openDrawer;
  ReaderPage(this.openDrawer);
  @override
  _ReaderPageState createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  String langIn = "en";
  String langOut = "fa";

  TextEditingController _searchTEC = TextEditingController();
  bool isSearch = false;
  PdfTextSearchResult searchResult;

  Store<AppState> store;
  PdfReaderState pdfReaderState;

  GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey<SfPdfViewerState>();
  PdfViewerController _pdfViewerController = PdfViewerController();

  File file;
  String fileName = "";
  OverlayEntry _overlayEntry;
  PDFDoc _pdfDoc;
  int page;

  final String TRANSLATE = "Translate";
  String translateText;

  String word;
  String translation;

  SfPdfViewer content;

  int bookId;


  @override
  void initState() {
    super.initState();
    translateText = TRANSLATE;
    page = 0;
    store = getStore(context);
    pdfReaderState = store.state.pdfReaderState;
    init();
    setLanguage();
    setPdfStatus();
  }

  setPdfStatus() {
    _pdfViewerController.addListener(({property}) async {
      if (property == "pageChanged") {
        if (page != _pdfViewerController.pageNumber) {
          page = _pdfViewerController.pageNumber;
          store.dispatch(SetPdfReaderAction(PdfReaderState(fileName, file, _pdfViewerKey, _pdfViewerController, page)));
          BooksmartDatabase db = await getDatabase();
          db.bookDao.updateBookDomain(BookDomain(bookId, fileName, page));
        }
      }
    });
  }

  init() async {

    if (pdfReaderState != null || pdfReaderState.file.path == "") {
      file = pdfReaderState.file;
      await setPdfText();
      // _pdfViewerKey = pdfReaderState.pdfViewerKey;
      page = pdfReaderState.page;

    }
  }

  setLanguage() async {
    langIn = await getFromStorage(LANG_IN);
    langOut = await getFromStorage(LANG_OUT);
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return pdfviewer();
  }

  /// Picks a new PDF document from the device
  Future _pickPDFText() async {
    file = await FilePicker.getFile();
    fileName = file.path.substring(file.path.lastIndexOf(RegExp(r"[/\\]")) + 1, file.path.length);
    BooksmartDatabase db = await getDatabase();
    BookDomain bookDomain;
    try {
      bookDomain = await db.bookDao.findBookDomainByName(fileName);
    } catch (e) {

    }
    if (bookDomain != null && bookDomain.page != null) {
      setState(() {
        page = bookDomain.page;
        bookId = bookDomain.id;
      });
      store.dispatch(SetPdfReaderAction(PdfReaderState(fileName, file, _pdfViewerKey, _pdfViewerController, page)));
    } else {
      store.dispatch(SetPdfReaderAction(PdfReaderState(fileName, file, _pdfViewerKey, _pdfViewerController, page)));
      bookDomain = BookDomain(null, fileName, page);
      db.bookDao.insertBookDomain(bookDomain);
    }
    _pdfViewerController.jumpToPage(page);
    setState(() {
    });
    await setPdfText();
  }

  void setPdfText() async {
    if (file != null) {
      _pdfDoc = await PDFDoc.fromPath(file.path);
      setState(() {});
    }
  }

  void _showContextMenu(
      BuildContext context, PdfTextSelectionChangedDetails details) {
    bool isSentence = false;
    if (details.selectedText.isNotEmpty && details.selectedText.split(RegExp("[\s+|\t+|\n+|\r+]+")).length > 4) {
      isSentence = true;
    }
    final OverlayState _overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: details.globalSelectedRegion.center.dy - 55,
        left: details.globalSelectedRegion.bottomLeft.dx,
        child: isSentence ? Row(
          children: [
            RaisedButton(
              child: Text(TRANSLATE, style: TextStyle(fontSize: 17)),
              onPressed: () async {
                Clipboard.setData(ClipboardData(text: details.selectedText));
                String w = details.selectedText.trim();
                print(w.endsWith('C'));
                if (w.endsWith('C')) w = w.replaceRange(w.length - 1, w.length, "");
                print('Text copied to clipboard: ' + w);
                print("translating");
                String t = await translate(w);
                print("translated");
                String example = await findExample(w);
                setState(() {
                  word = w;
                  translation = t;
                });
                _pdfViewerController.clearSelection();
                showDialog(context: context,
                    builder: (_) {
                      return Dialog(
                          child: addWord(this.word, this.translation, example)
                      );
                    }
                );
              },
              color: Colors.white,
              elevation: 10,
            ),
            SizedBox(
              width: 5,
            ),
            RaisedButton(
              child: Text("Sentence", style: TextStyle(fontSize: 17)),
              onPressed: () async {
                String s = details.selectedText.trim();
                _pdfViewerController.clearSelection();
                s = s.replaceAll(RegExp(r"[\s+\t+\r+\n+]+"), " ");
                showDialog(
                    context: context,
                  child: Dialog(
                    child: SentenceGrabber(s)
                  )
                );
              },
              color: Colors.white,
              elevation: 10,
            ),
          ],
        ):
        RaisedButton(
          child: Text(TRANSLATE, style: TextStyle(fontSize: 17)),
          onPressed: () async {
            Clipboard.setData(ClipboardData(text: details.selectedText));
            String w = details.selectedText.trim();
            print(w.endsWith('C'));
            if (w.endsWith('C')) w = w.replaceRange(w.length - 1, w.length, "");
            print('Text copied to clipboard: ' + w);
            print("translating");
            String t = await translate(w);
            print("translated");
            String example = await findExample(w);
            setState(() {
              word = w;
              translation = t;
            });
            _pdfViewerController.clearSelection();
            showDialog(context: context,
                builder: (_) {
                  return Dialog(
                      child: addWord(this.word, this.translation, example)
                  );
                }
            );
          },
          color: Colors.white,
          elevation: 10,
        ),
      ),
    );
    _overlayState?.insert(_overlayEntry);
  }

  Future<String> findExample(String word) async {
    int pn = _pdfViewerController.pageNumber;
    String page = await _pdfDoc.pageAt(pn).text;
    page += ".";
    int index = page.indexOf(word);
    List<String> l = page.split(RegExp(r"[.?!]"));
    l = l.where((e) => e.contains(word)).toList();
    if (l.isEmpty) {
      if (pn > 0) {
        page += await _pdfDoc.pageAt(pn - 1).text;
        page += await _pdfDoc.pageAt(pn + 1).text;
      }
      index = page.indexOf(word);
      l = page.split(RegExp(r"[.?!]"));
      l = l.where((e) => e.contains(word)).toList();
    }
    String s = "";
    for (String str in l) {
      s += str;
    }
    s.replaceAll("\t|\n|\r", " ");
    return s;
  }

  Future<String> translate(String input) async {
    // Map<String, String> t = await TranslateIt(YANDEX_API_KEY)
    //     .translate(
    //     input,
    //     'en-fa', // only `ru` will also do same job
    //     type: 'html');
    // print("${t[0]} - ${t[1]} - ${t}");
    preloader(context);

    await setLanguage();

    String s = "";

    try {
      String t = await MlkitTranslate.translateText(
        source: langIn,
        text: input,
        target: langOut,
      );
      if (t.trim() == word.trim()) {
        try {
          final translator = GoogleTranslator();
          Translation tr = await translator.translate(input, from: langIn, to: langOut);
          t = t + "," + tr.text;
        } catch (e) {

        }
      }
      if (t == null || t == input || t.length == 0) {
        Navigator.of(context).pop("dialog");
        return await downloadModel(input);
      }
      Navigator.of(context).pop("dialog");
      return t;
    } catch (e) {
      Navigator.of(context).pop("dialog");
      return await downloadModel(input);
    }
  }

  Future<String> downloadModel(String input) async {
    Fluttertoast.showToast(
        msg: "Downloading the Dictionary...",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    await MlkitTranslate.downloadModel(langOut);
    return await MlkitTranslate.translateText(
      source: langIn,
      text: input,
      target: langOut,
    );
  }

  Widget addWord(String word, String translation, String example) {
    return ConstrainedBox(
        constraints: BoxConstraints(
            minHeight: 200,
            maxWidth: 400
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(word, style: TextStyle(fontSize: 22),),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(translation, style: TextStyle(fontSize: 22),),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(example, style: TextStyle(fontSize: 14),),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: RaisedButton(
                            color: Colors.red,
                            child: Text("Cancel"),
                            onPressed: () {
                              Navigator.of(context, rootNavigator: true).pop("dialog");
                            },
                          ),
                        )
                    ),
                    Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: RaisedButton(
                            color: Colors.green,
                            child: Text("Add"),
                            onPressed: () async {
                              BooksmartDatabase db = await getDatabase();
                              WordDomain wordDomain = WordDomain(
                                  null,
                                  word,
                                  translation,
                                  DateTime.now().toString(),
                                  example,
                                  DateTime.now().millisecondsSinceEpoch,
                                  1,
                                  false);
                              await db.wordDao.insertWordDomain(wordDomain);
                              Navigator.of(context, rootNavigator: true).pop("dialog");
                            },
                          ),
                        )
                    )
                  ],
                ),
              )
            ],
          ),
        )
    );
  }

  pdfviewer() {
    return Scaffold(
        appBar: AppBar(
          title: InkWell(
            child: Icon(Icons.menu),
            onTap: () {
              widget.openDrawer();
            },
          ),
          actions: <Widget>[
            isSearch ?
            IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: () {
                searchResult.clear();
                setState(() {
                  isSearch = false;
                });
              },
            ): Container(),
            isSearch ?
            IconButton(
              icon: Icon(
                Icons.arrow_drop_up,
                color: Colors.white,
              ),
              onPressed: () {
                searchResult.previousInstance();
              },
            ): Container(),
            isSearch ?
            IconButton(
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.white,
              ),
              onPressed: () {
                searchResult.nextInstance();
              },
            ): Container(),
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    child: Dialog(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: 200,
                          height: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextField(
                                  controller: _searchTEC,
                              ),
                              RaisedButton(
                                child: Text("Search"),
                                onPressed: () async {
                                  if (_searchTEC.text.length > 3) {
                                    preloader(context);
                                    searchResult = await _pdfViewerController.searchText(_searchTEC.text);
                                    if (searchResult.hasResult) {
                                      Navigator.of(context).pop("dialog");
                                      setState(() {
                                        isSearch = true;
                                      });
                                      print("has result");
                                    }
                                  } else {
                                    showDialog(
                                      context: context,
                                      child: Dialog(
                                        child: Text("search text should contain at least 3 characters"),
                                      )
                                    );
                                  }
                                },
                              )
                            ],
                          )
                        )
                    )
                );
              },
            ),
            IconButton(
              icon: Icon(
                Icons.bookmark,
                color: Colors.white,
              ),
              onPressed: () {
                _pdfViewerKey.currentState?.openBookmarkView();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.open_in_browser,
                color: Colors.white,
              ),
              onPressed: _pickPDFText
            ),
          ],
        ),
        body: file != null ? SfPdfViewer.file(
          file,
          key: _pdfViewerKey,
          controller: _pdfViewerController,
          enableTextSelection: true,
          onPageChanged: (details) {
            store.state.pdfReaderState.page = details.newPageNumber;
            store.dispatch(SetPdfReaderAction(store.state.pdfReaderState));
          },
          onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
            if (details.selectedText == null && _overlayEntry != null) {
              _overlayEntry?.remove();
              _overlayEntry = null;
            } else if (details.selectedText != null && _overlayEntry == null) {
              _showContextMenu(this.context, details);
            }
          },
        ): Container()
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _searchTEC.dispose();
    super.dispose();
  }
}