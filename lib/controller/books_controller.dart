import '../books_api.dart';
import '../model/book_model.dart';

class BooksController extends ResourceController {
  // Constructor to initialize the context
  BooksController(this.context);

  ManagedContext context;
  // invoked for GET /books
  @Operation.get()
  Future<Response> readAllBooks() async {
    final query = Query<BookModel>(context);
    final bookList = await query.fetch();

    return Response.ok(bookList);
  }

  // invoked for GET /books/[:id]
  @Operation.get('id')
  Future<Response> readBookById(@Bind.path('id') int id) async {
    final query = Query<BookModel>(context)
      ..where((item) => item.id).equalTo(id);
    final word = await query.fetchOne();

    if (word == null) {
      return Response.notFound();
    }

    return Response.ok(word);
  }

  // invoked for POST /books
  @Operation.post()
  Future<Response> createBook(
      @Bind.body(ignore: ['id']) BookModel newBook) async {
    final query = Query<BookModel>(context)..values = newBook;
    final insertedBook = await query.insert();

    return Response.ok(insertedBook);
  }

  // invoked for PUT /books/[:id]
  @Operation.put('id')
  Future<Response> replaceBook(@Bind.path('id') int id,
      @Bind.body(ignore: ['id']) BookModel putBook) async {
    final query = Query<BookModel>(context)
      ..values = putBook
      ..where((item) => item.id).equalTo(id);
    final replacedBook = await query.updateOne();

    return Response.ok(replacedBook);
  }

  // invoked for PATCH /books/[:id]
  @Operation('PATCH', 'id')
  Future<Response> updateBook(@Bind.path('id') int id,
      @Bind.body(ignore: ['id']) BookModel patchBook) async {
    final query = Query<BookModel>(context)
      ..values = patchBook
      ..where((item) => item.id).equalTo(id);
    final updatedBook = await query.updateOne();

    return Response.ok(updatedBook);
  }

  // invoked for DELETE /books/[:id]
  @Operation.delete('id')
  Future<Response> deleteBook(@Bind.path('id') int id) async {
    final query = Query<BookModel>(context)
      ..where((item) => item.id).equalTo(id);
    final deletedBook = await query.delete();
    final deletedMessage = {'message': 'Deleted $deletedBook book(s)'};

    return Response.ok(deletedMessage);
  }
}
