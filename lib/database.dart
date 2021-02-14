import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConnection {
  setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'db_budgetApp');
    var database =
        await openDatabase(path, version: 1, onCreate: _onCreatingDatabase);
    return database;
  }

  _onCreatingDatabase(Database database, int version) async {
    await database.execute(
        'CREATE TABLE categories (id INTEGER PRIMARY KEY AUTOINCREMENT , name TEXT, amount DOUBLE, maximum DOUBLE)');
    await database.execute(
        'CREATE TABLE  items(id INTEGER PRIMARY KEY AUTOINCREMENT,  name TEXT, amount DOUBLE, date TEXT, catId INTEGER, FOREIGN KEY (catId) REFERENCES categories(id) on delete cascade)');
  }
}
