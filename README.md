# Books API

## Running the Application Locally

Run `aqueduct serve` from this directory to run the application. For running within an IDE, run `bin/main.dart`. By default, a configuration file named `config.yaml` will be used.

To generate a SwaggerUI client, run `aqueduct document client`.

## Running Application Tests

To run all tests for this application, run the following in this directory:

```
pub run test
```

The default configuration file used when testing is `config.src.yaml`. This file should be checked into version control. It also the template for configuration files used in deployment.

## Deploying an Application

See the documentation for [Deployment](https://aqueduct.io/docs/deploy/).

## Creating PostgreSQL Database

First, log in to the PostgreSQL v12.2.1 server:

    $ psql postgres
    
Your command line should be looks like:

    $ postgres=#
    
You can see all the databases in PostgreSQL running;

    $ \l
    
You can see all the databases users with their respective permissions in PostgreSQL running;

    $ \du

Let's create the `books` database via SQL:

    $ CREATE DATABASE books;
    
Now, let's create an user to the `books` database via SQL:

    $ CREATE USER books_user WITH createdb;

Time to modify the password of the created user via SQL:

    $ ALTER USER books_user WITH password 'B00ks.P4ss';
    
Finally we will give all the permissions to the `books_user`:

    $ GRANT all ON database books TO books_user;
    
Now we have a `books` database with his respective `books_user`.

To quit from the `psql` session just run:

    $ \q

## Aqueduct Migrations

To create a migration runs:

    $ aqueduct db generate

To run a migration:

    $ aqueduct db upgrade --connect postgres://username:password@localhost:5432/my_application
    
For this case, the command will:

    $ aqueduct db upgrade --connect postgres://books_user:B00ks.P4ss@localhost:5432/books

## Range Error

When you run the `aqueduct db upgrade` command and you have the next specifications:

- Dart v.2.8
- Aqueduct v.3.1
- PostgreSQL v.12.1

Probably you will get the next error:

```
-- Aqueduct CLI Version: 3.3.0+1
-- Aqueduct project version: 3.3.0+1
*** Uncaught error
    RangeError: Invalid value: Not in range 0..1114111, inclusive: -1
  **** Stacktrace
```

Currently, the aqueduct github repository have the [Issue#84i1](https://github.com/stablekernel/aqueduct/issues/841). The solution applied was downgrade Dart version to 2.7.2.

## Creating PostgreSQL Test Database
To create the unit testing of our project, is recommendable apply the testing on a different database. Let's create a new database in PostgreSQL:

    $ psql postgres
    $ CREATE DATABASE books_test;
    $ CREATE USER books_user_test WITH createdb;
    $ ALTER USER books_user_test WITH password 'B00ks.T3st';
    $ GRANT all ON database books_test TO books_user_test;
    
Remember that in our `channel.dart` file we consume the database credentials from `config.yaml`. For consume the testing database we should store these credentials in `config.src.yaml`, in the same way we did for the production database.

## Testing
Aqueduct comes with Harness as a tool to write our unit testing. First of all we have to set up the use of the testing database. Therefore, we have bring the `ManagedContext` of our `channel.ts` file into the `test/harness/app.dart` file with the next lines:

```dart
// All imports

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
```

Once our context is enable for the test suite, we should validate that the PostgreSQL and Aqueduct server are on an then we run our unit test with the next command:

    $ pub run test [path-to-file]

For this case, we create a `books_controller_test.dart` file to store all the unit testing related to out `books_controller.dart` file. So, to run these unit test we should execute the next command:

    $ pub run test test/books_controller_test.dart

