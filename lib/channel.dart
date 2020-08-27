import 'books_api.dart';
import './controller/books_controller.dart';

class BooksApiChannel extends ApplicationChannel {
  ManagedContext context;

  @override
  Future prepare() async {
    logger.onRecord.listen(
        (rec) => print("$rec ${rec.error ?? ""} ${rec.stackTrace ?? ""}"));

    final dataModel = ManagedDataModel.fromCurrentMirrorSystem();

    final config = BooksConfig(options.configurationFilePath);
    final database = PostgreSQLPersistentStore.fromConnectionInfo(
      config.database.username,
      config.database.password,
      config.database.host,
      config.database.port,
      config.database.databaseName
    );

    context = ManagedContext(dataModel, database);
  }

  @override
  Controller get entryPoint {
    final router = Router();

    router.route('/').linkFunction((request) async {
      return Response.ok('<h1>Welcome Books</h1>');
    });

    router.route('/books/[:id]').link(() => BooksController(context));

    router.route("/example").linkFunction((request) async {
      return Response.ok({"key": "value"});
    });

    return router;
  }
}

class BooksConfig extends Configuration {
  BooksConfig(String path) : super.fromFile(File(path));

  // This value should match with the property in config.yml
  DatabaseConfiguration database;
}
