

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

final PdfReaderState pdfReaderStateInit = PdfReaderState("", null, GlobalKey<SfPdfViewerState>(), PdfViewerController(), 0);

class PdfReaderState {
  String fileName;
  File file;
  GlobalKey<SfPdfViewerState> pdfViewerKey;
  PdfViewerController pdfViewerController;
  int page;

  PdfReaderState(this.fileName, this.file, this.pdfViewerKey, this.pdfViewerController, this.page);
}