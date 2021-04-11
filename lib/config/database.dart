
// database.dart

// required package imports
import 'dart:async';
import 'package:booksmart/dao/book_dao.dart';
import 'package:booksmart/dao/sentence_dao.dart';
import 'package:booksmart/dao/word_dao.dart';
import 'package:booksmart/domains/book_domain.dart';
import 'package:booksmart/domains/sentence_domain.dart';
import 'package:booksmart/domains/word_domain.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;


part 'database.g.dart'; // the generated code will be there

@Database(version: 2, entities: [WordDomain, SentenceDomain, BookDomain])
abstract class BooksmartDatabase extends FloorDatabase {
  WordDao get wordDao;
  SentenceDao get sentenceDao;
  BookDao get bookDao;
}

Future<BooksmartDatabase> getDatabase() async {
  BooksmartDatabase database = await $FloorBooksmartDatabase.databaseBuilder('booksmart.db').build();
  return database;
}