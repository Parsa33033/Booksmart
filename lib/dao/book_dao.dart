

import 'package:booksmart/domains/book_domain.dart';
import 'package:floor/floor.dart';


@dao
abstract class BookDao {
  @Query('SELECT * FROM BookDomain')
  Future<List<BookDomain>> findAllBookDomain();

  @Query('SELECT * FROM BookDomain WHERE id = :id')
  Future<BookDomain> findBookDomainById(int id);

  @Query('SELECT * FROM BookDomain WHERE name = :name')
  Future<BookDomain> findBookDomainByName(String name);

  @insert
  Future<void> insertBookDomain(BookDomain bookDomain);

  @update
  Future<void> updateBookDomain(BookDomain bookDomain);

  @delete
  Future<void> deleteBookDomain(BookDomain bookDomain);
}