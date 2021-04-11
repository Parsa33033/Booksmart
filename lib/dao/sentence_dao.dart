
import 'package:booksmart/domains/sentence_domain.dart';
import 'package:floor/floor.dart';
import 'package:flutter/cupertino.dart';

@dao
abstract class SentenceDao {
  @Query('SELECT * FROM SentenceDomain')
  Future<List<SentenceDomain>> findAllSentenceDomain();

  @Query('SELECT * FROM SentenceDomain WHERE id = :id')
  Future<SentenceDomain> findSentenceDomainById(int id);

  @insert
  Future<void> insertSentenceDomain(SentenceDomain sentenceDomain);

  @update
  Future<void> updateSentenceDomain(SentenceDomain sentenceDomain);

  @delete
  Future<void> deleteSentenceDomain(SentenceDomain sentenceDomain);
}