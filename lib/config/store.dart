

import 'package:booksmart/actions/word_action.dart';
import 'package:booksmart/main.dart';
import 'package:booksmart/states/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:redux/redux.dart';

final String LANG_IN = "lang_in";
final String LANG_OUT = "lang_out";

Store<AppState> getStore(BuildContext context) {
  Store<AppState> s;
  if (context == null) {
    return store;
  }
  try {
    s = StoreProvider.of<AppState>(context);
  } catch (e) {
    s = store;
  }
  return s;
}

Future<void> saveToStorage(String key, String value) async {
  FlutterSecureStorage storage = FlutterSecureStorage();
  await storage.write(key: key, value: value);
  print("${key} --- ${value}");
}

Future<String> getFromStorage(String key) async {
  FlutterSecureStorage storage = FlutterSecureStorage();
  String s = await storage.read(key: key);
  if (s == null) {
    if (key == LANG_IN) {
      return "en";
    } else if (key == LANG_OUT) {
      return "fa";
    } else {
      return "en";
    }
  }
  return s;
}