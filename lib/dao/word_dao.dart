
import 'package:booksmart/domains/word_domain.dart';
import 'package:floor/floor.dart';
import 'package:flutter/cupertino.dart';

@dao
abstract class WordDao {
  @Query('SELECT * FROM WordDomain')
  Future<List<WordDomain>> findAllWordDomains();

  @Query('SELECT * FROM WordDomain WHERE id = :id')
  Future<WordDomain> findWordDomainById(int id);

  @Query('SELECT * FROM WordDomain WHERE word = :word')
  Future<WordDomain> findWordDomainByWord(String word);

  @insert
  Future<void> insertWordDomain(WordDomain wordDomain);

  @update
  Future<void> updateWordDomain(WordDomain wordDomain);

  @Query('SELECT * FROM WordDomain WHERE nextReviewTime < :time AND boxNum <= :box')
  Future<List<WordDomain>> findWordDomainByPassedReviewTimeAndPassedBox(int time, int box);

  @delete
  Future<void> deleteWordDomain(WordDomain wordDomain);
}