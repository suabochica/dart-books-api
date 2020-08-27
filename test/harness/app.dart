import 'package:books_api/books_api.dart';
import 'package:aqueduct_test/aqueduct_test.dart';

export 'package:books_api/books_api.dart';
export 'package:aqueduct_test/aqueduct_test.dart';
export 'package:test/test.dart';
export 'package:aqueduct/aqueduct.dart';

class Harness extends TestHarness<BooksApiChannel> with TestHarnessORMMixin {
  @override
  Future onSetUp() async {
    await resetData();
  }

  @override
  Future onTearDown() async {}

  @override
  ManagedContext get context => channel.context;
}
