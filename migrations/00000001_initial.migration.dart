import 'dart:async';
import 'package:aqueduct/aqueduct.dart';

class Migration1 extends Migration {
  @override
  Future upgrade() async {
    database.createTable(SchemaTable("_BookModel", [
      SchemaColumn("id", ManagedPropertyType.bigInteger,
          isPrimaryKey: true,
          autoincrement: true,
          isIndexed: false,
          isNullable: false,
          isUnique: false),
      SchemaColumn("title", ManagedPropertyType.string,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: true,
          isNullable: false,
          isUnique: true),
      SchemaColumn("author", ManagedPropertyType.string,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: false,
          isUnique: false),
      SchemaColumn("year", ManagedPropertyType.integer,
          isPrimaryKey: false,
          autoincrement: false,
          isIndexed: false,
          isNullable: false,
          isUnique: false)
    ]));
  }

  @override
  Future downgrade() async {}

  @override
  Future seed() async {
    final rows = [
      {
        'title': 'Head First Design Patterns',
        'author': 'Eric Freeman',
        'year': '2004'
      },
      {
        'title': 'Clean Code: A handbook of Agile Software Craftsmanship',
        'author': 'Robert C. Martin',
        'year': '2008'
      },
      {
        'title': 'Code Complete: A Practical Handbook of Software Construction',
        'author': 'Steve McConnel',
        'year': '2004'
      },
      {
        "title": "Flutter in Action",
        "author": "Eric Windmill",
        "year": '2019'
      },
    ];

    for (final row in rows) {
      await database.store.execute(
        "INSERT INTO _BookModel (title, author, year) VALUES (@title, @author, @year)",
        substitutionValues: {
          "title": row['title'],
          "author": row['author'],
          "year": row['year'],
        }
      );
    }
  }
}
