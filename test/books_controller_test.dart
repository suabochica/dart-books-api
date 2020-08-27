import 'harness/app.dart';

Future main() async {
  final harness = Harness()..install();

  group("GET: ", () {
    test("GET /books return 200 OK", () async {
      final response = await harness.agent.get('/books');

      expect(response.statusCode, 200);
    });

    test("GET /whatever return 404 Not Found", () async {
      final response = await harness.agent.get('/whatever');

      expect(response.statusCode, 404);
    });

    test("GET /books/1 return 404 Not Found for empty database", () async {
      final response = await harness.agent.get('/books/1');

      expect(response.statusCode, 404);
    });

    test("GET /books/id object after POST request has the expected body", () async {
        final postResponse = await harness.agent.post('/books', body: {
            'title': 'RESTful Web APIs: Services for a Changing World',
            'author': 'Leonard Richardson',
            'year': 2013,
        });
        final id = postResponse.body.as<Map>()['id'];
        final response = await harness.agent.get('/books/$id');

        expectResponse(response, 200, body: {
            'id': id,
            'title': 'RESTful Web APIs: Services for a Changing World',
            'author': 'Leonard Richardson',
            'year': 2013,
        });
    });
  });

  group("POST: ", () {
      test("POST /books return 400 Bad Request for empty body", () async {
          final response = await harness.agent.post('/books', body: {});

          expect(response.statusCode, 400);
      });

      test("POST /books return 200 OK for body with valid keys", () async {
          final response = await harness.agent.post('/books', body: {
              'title': 'title',
              'author': 'author',
              'year': 2013,
          });

          expect(response.statusCode, 200);
      });

      test("POST /books return 400 Bad Request for body with wrong keys", () async {
          final response = await harness.agent.post('/books', body: {
              'name': 'title',
              'writer': 'author',
              'age': 2013,
          });

          expect(response.statusCode, 400);
      });
  });
}
