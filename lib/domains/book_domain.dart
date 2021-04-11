
import 'package:floor/floor.dart';

@entity
class BookDomain {
  @PrimaryKey(autoGenerate: true)
  int id;
  String name;
  int page;

  BookDomain(this.id, this.name, this.page);
}
