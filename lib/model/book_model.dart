import '../books_api.dart';

class BookModel extends ManagedObject<_BookModel> implements _BookModel {

}

class _BookModel {
  @primaryKey
  int id;

  @Column(unique: true, indexed: true)
  String title;
  String author;
  int year;
}
