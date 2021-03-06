import 'package:app_budget/database.dart';
import 'package:sqflite/sqflite.dart';

class Repository {
  DatabaseConnection _databaseConnection;

  Repository() {
    _databaseConnection = DatabaseConnection();
  }

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _databaseConnection.setDatabase();
    return _database;
  }

  insertData(table, data) async {
    var connection = await database;
    return await connection.insert(table, data);
  }

  readData(table) async {
    var connection = await database;
    return await connection.query(table);
  }

  readDataById(table, catId) async {
    var connection = await database;
    return await connection.query(table, where: 'id=?', whereArgs: [catId]);
  }

  readItemById(table, itemId) async {
    var connection = await database;
    return await connection.query(table, where: 'id=?', whereArgs: [itemId]);
  }

  updateData(table, data) async {
    var connection = await database;
    return await connection
        .update(table, data, where: 'id=?', whereArgs: [data['id']]);
  }

  deleteData(table, catId) async {
    var connection = await database;
    return await connection.rawDelete('DELETE FROM $table where id= $catId');
  }

  readDataWithId(table, catId) async {
    var connection = await database;
    return await connection.query(table, where: 'catId=?', whereArgs: [catId]);
  }

  updateAmountInCategory(table, data) async {
    var connection = await database;
    return await connection
        .update(table, data, where: 'id=?', whereArgs: [data['id']]);
  }

  readDataWithDate(table) async {
    // Moment rawDate = Moment.parse(pickdate);
    var connection = await database;
    var data = await connection.rawQuery('SELECT * FROM $table ');
    return data;
  }

  deleteItemHome(table, catId) async {
    var connection = await database;
    return await connection.rawDelete('DELETE FROM $table where catId= $catId');
  }
}
