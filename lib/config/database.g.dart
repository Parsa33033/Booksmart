// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorBooksmartDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$BooksmartDatabaseBuilder databaseBuilder(String name) =>
      _$BooksmartDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$BooksmartDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$BooksmartDatabaseBuilder(null);
}

class _$BooksmartDatabaseBuilder {
  _$BooksmartDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$BooksmartDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$BooksmartDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<BooksmartDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name)
        : ':memory:';
    final database = _$BooksmartDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$BooksmartDatabase extends BooksmartDatabase {
  _$BooksmartDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  WordDao _wordDaoInstance;

  SentenceDao _sentenceDaoInstance;

  BookDao _bookDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `WordDomain` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `word` TEXT, `translation` TEXT, `timeOfReview` TEXT, `example` TEXT, `nextReviewTime` INTEGER, `boxNum` INTEGER, `learned` INTEGER)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `SentenceDomain` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `sentence` TEXT, `category` TEXT)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `BookDomain` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT, `page` INTEGER)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  WordDao get wordDao {
    return _wordDaoInstance ??= _$WordDao(database, changeListener);
  }

  @override
  SentenceDao get sentenceDao {
    return _sentenceDaoInstance ??= _$SentenceDao(database, changeListener);
  }

  @override
  BookDao get bookDao {
    return _bookDaoInstance ??= _$BookDao(database, changeListener);
  }
}

class _$WordDao extends WordDao {
  _$WordDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _wordDomainInsertionAdapter = InsertionAdapter(
            database,
            'WordDomain',
            (WordDomain item) => <String, dynamic>{
                  'id': item.id,
                  'word': item.word,
                  'translation': item.translation,
                  'timeOfReview': item.timeOfReview,
                  'example': item.example,
                  'nextReviewTime': item.nextReviewTime,
                  'boxNum': item.boxNum,
                  'learned':
                      item.learned == null ? null : (item.learned ? 1 : 0)
                }),
        _wordDomainUpdateAdapter = UpdateAdapter(
            database,
            'WordDomain',
            ['id'],
            (WordDomain item) => <String, dynamic>{
                  'id': item.id,
                  'word': item.word,
                  'translation': item.translation,
                  'timeOfReview': item.timeOfReview,
                  'example': item.example,
                  'nextReviewTime': item.nextReviewTime,
                  'boxNum': item.boxNum,
                  'learned':
                      item.learned == null ? null : (item.learned ? 1 : 0)
                }),
        _wordDomainDeletionAdapter = DeletionAdapter(
            database,
            'WordDomain',
            ['id'],
            (WordDomain item) => <String, dynamic>{
                  'id': item.id,
                  'word': item.word,
                  'translation': item.translation,
                  'timeOfReview': item.timeOfReview,
                  'example': item.example,
                  'nextReviewTime': item.nextReviewTime,
                  'boxNum': item.boxNum,
                  'learned':
                      item.learned == null ? null : (item.learned ? 1 : 0)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<WordDomain> _wordDomainInsertionAdapter;

  final UpdateAdapter<WordDomain> _wordDomainUpdateAdapter;

  final DeletionAdapter<WordDomain> _wordDomainDeletionAdapter;

  @override
  Future<List<WordDomain>> findAllWordDomains() async {
    return _queryAdapter.queryList('SELECT * FROM WordDomain',
        mapper: (Map<String, dynamic> row) => WordDomain(
            row['id'] as int,
            row['word'] as String,
            row['translation'] as String,
            row['timeOfReview'] as String,
            row['example'] as String,
            row['nextReviewTime'] as int,
            row['boxNum'] as int,
            row['learned'] == null ? null : (row['learned'] as int) != 0));
  }

  @override
  Future<WordDomain> findWordDomainById(int id) async {
    return _queryAdapter.query('SELECT * FROM WordDomain WHERE id = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => WordDomain(
            row['id'] as int,
            row['word'] as String,
            row['translation'] as String,
            row['timeOfReview'] as String,
            row['example'] as String,
            row['nextReviewTime'] as int,
            row['boxNum'] as int,
            row['learned'] == null ? null : (row['learned'] as int) != 0));
  }

  @override
  Future<WordDomain> findWordDomainByWord(String word) async {
    return _queryAdapter.query('SELECT * FROM WordDomain WHERE word = ?',
        arguments: <dynamic>[word],
        mapper: (Map<String, dynamic> row) => WordDomain(
            row['id'] as int,
            row['word'] as String,
            row['translation'] as String,
            row['timeOfReview'] as String,
            row['example'] as String,
            row['nextReviewTime'] as int,
            row['boxNum'] as int,
            row['learned'] == null ? null : (row['learned'] as int) != 0));
  }

  @override
  Future<List<WordDomain>> findWordDomainByPassedReviewTimeAndPassedBox(
      int time, int box) async {
    return _queryAdapter.queryList(
        'SELECT * FROM WordDomain WHERE nextReviewTime < ? AND boxNum <= ?',
        arguments: <dynamic>[time, box],
        mapper: (Map<String, dynamic> row) => WordDomain(
            row['id'] as int,
            row['word'] as String,
            row['translation'] as String,
            row['timeOfReview'] as String,
            row['example'] as String,
            row['nextReviewTime'] as int,
            row['boxNum'] as int,
            row['learned'] == null ? null : (row['learned'] as int) != 0));
  }

  @override
  Future<void> insertWordDomain(WordDomain wordDomain) async {
    await _wordDomainInsertionAdapter.insert(
        wordDomain, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateWordDomain(WordDomain wordDomain) async {
    await _wordDomainUpdateAdapter.update(wordDomain, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteWordDomain(WordDomain wordDomain) async {
    await _wordDomainDeletionAdapter.delete(wordDomain);
  }
}

class _$SentenceDao extends SentenceDao {
  _$SentenceDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _sentenceDomainInsertionAdapter = InsertionAdapter(
            database,
            'SentenceDomain',
            (SentenceDomain item) => <String, dynamic>{
                  'id': item.id,
                  'sentence': item.sentence,
                  'category': item.category
                }),
        _sentenceDomainUpdateAdapter = UpdateAdapter(
            database,
            'SentenceDomain',
            ['id'],
            (SentenceDomain item) => <String, dynamic>{
                  'id': item.id,
                  'sentence': item.sentence,
                  'category': item.category
                }),
        _sentenceDomainDeletionAdapter = DeletionAdapter(
            database,
            'SentenceDomain',
            ['id'],
            (SentenceDomain item) => <String, dynamic>{
                  'id': item.id,
                  'sentence': item.sentence,
                  'category': item.category
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<SentenceDomain> _sentenceDomainInsertionAdapter;

  final UpdateAdapter<SentenceDomain> _sentenceDomainUpdateAdapter;

  final DeletionAdapter<SentenceDomain> _sentenceDomainDeletionAdapter;

  @override
  Future<List<SentenceDomain>> findAllSentenceDomain() async {
    return _queryAdapter.queryList('SELECT * FROM SentenceDomain',
        mapper: (Map<String, dynamic> row) => SentenceDomain(row['id'] as int,
            row['sentence'] as String, row['category'] as String));
  }

  @override
  Future<SentenceDomain> findSentenceDomainById(int id) async {
    return _queryAdapter.query('SELECT * FROM SentenceDomain WHERE id = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => SentenceDomain(row['id'] as int,
            row['sentence'] as String, row['category'] as String));
  }

  @override
  Future<void> insertSentenceDomain(SentenceDomain sentenceDomain) async {
    await _sentenceDomainInsertionAdapter.insert(
        sentenceDomain, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateSentenceDomain(SentenceDomain sentenceDomain) async {
    await _sentenceDomainUpdateAdapter.update(
        sentenceDomain, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteSentenceDomain(SentenceDomain sentenceDomain) async {
    await _sentenceDomainDeletionAdapter.delete(sentenceDomain);
  }
}

class _$BookDao extends BookDao {
  _$BookDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _bookDomainInsertionAdapter = InsertionAdapter(
            database,
            'BookDomain',
            (BookDomain item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'page': item.page
                }),
        _bookDomainUpdateAdapter = UpdateAdapter(
            database,
            'BookDomain',
            ['id'],
            (BookDomain item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'page': item.page
                }),
        _bookDomainDeletionAdapter = DeletionAdapter(
            database,
            'BookDomain',
            ['id'],
            (BookDomain item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'page': item.page
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<BookDomain> _bookDomainInsertionAdapter;

  final UpdateAdapter<BookDomain> _bookDomainUpdateAdapter;

  final DeletionAdapter<BookDomain> _bookDomainDeletionAdapter;

  @override
  Future<List<BookDomain>> findAllBookDomain() async {
    return _queryAdapter.queryList('SELECT * FROM BookDomain',
        mapper: (Map<String, dynamic> row) => BookDomain(
            row['id'] as int, row['name'] as String, row['page'] as int));
  }

  @override
  Future<BookDomain> findBookDomainById(int id) async {
    return _queryAdapter.query('SELECT * FROM BookDomain WHERE id = ?',
        arguments: <dynamic>[id],
        mapper: (Map<String, dynamic> row) => BookDomain(
            row['id'] as int, row['name'] as String, row['page'] as int));
  }

  @override
  Future<BookDomain> findBookDomainByName(String name) async {
    return _queryAdapter.query('SELECT * FROM BookDomain WHERE name = ?',
        arguments: <dynamic>[name],
        mapper: (Map<String, dynamic> row) => BookDomain(
            row['id'] as int, row['name'] as String, row['page'] as int));
  }

  @override
  Future<void> insertBookDomain(BookDomain bookDomain) async {
    await _bookDomainInsertionAdapter.insert(
        bookDomain, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateBookDomain(BookDomain bookDomain) async {
    await _bookDomainUpdateAdapter.update(bookDomain, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteBookDomain(BookDomain bookDomain) async {
    await _bookDomainDeletionAdapter.delete(bookDomain);
  }
}
