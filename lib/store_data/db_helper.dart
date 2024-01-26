import 'package:sqflite/sqflite.dart';
import 'account_model.dart';


class DBHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = 'accounts';

  static Future<void> initDb() async {
    if (_db != null) {
      return;
    }

    try {
      String path = '${await getDatabasesPath()}/account.db'; // Add the path separator
      _db = await openDatabase(
        path,
        version: _version,
        onCreate: (Database db, int version) async {
          await db.execute(

            'CREATE TABLE $_tableName('
                'id INTEGER PRIMARY KEY AUTOINCREMENT, '
                'fullname TEXT, '
                'date STRING, '
                'gender STRING,'
                'email STRING,'
                'entryDate STRING, '
                'empstatus STRING, '
                'phone STRING, '
                'color INTEGER, '
                'isCompleted INTEGER)',
          );
        },
      );
      print('Database Created');
    } catch (e) {
      print('Error = $e');
    }
  }

  static Future<int> insert(Account? account) async {
    if (_db == null) {
      await initDb();
    }
    print('insert function called');
    return await _db!.insert(_tableName, account!.toJson());
  }

  static Future<int> delete(Account account) async {
    if (_db == null) {
      await initDb();
    }
    print('delete function called');
    return await _db!.delete(_tableName, where: 'id = ?', whereArgs: [account.id]);
  }

  static Future<int> deleteAll() async {
    if (_db == null) {
      await initDb();
    }
    print('delete All function called');
    return await _db!.delete(_tableName);
  }

  static Future<List<Map<String, dynamic>>> query() async {
    if (_db == null) {
      await initDb();
    }
    print('query function called');
    return await _db!.query(_tableName);
  }

  static Future<int> update(int id) async {
    if (_db == null) {
      await initDb();
    }
    print('update function called');
    return await _db!.rawUpdate('''
      UPDATE $_tableName
      SET isCompleted = ?
      WHERE id = ?
     ''', [1, id]);
  }
}
