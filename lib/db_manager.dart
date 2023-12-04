import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

dynamic getDatabaseFactory() {
  if (kIsWeb) {
    return databaseFactoryWeb;
  } else {
    return databaseFactoryIo;
  }
}

class DatabaseHelper {
  int controladorId = 0;
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 1;

  static final _storeName = 'category';
  static final _storeContactName = 'contact';

  static final columnId = 'id';
  static final columnName = 'name';
  static final columnLName = 'lname';
  static final columnMobile = 'mobile';
  static final columnEmail = 'email';
  static final columnCategory = 'cat';

  final _dbNameKey = kIsWeb ? 'web_database.db' : _databaseName;
  final _path = kIsWeb ? 'db' : null;



  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get _database async {
    final dbPath = await _getDatabasePath();
    final factory = getDatabaseFactory();
    final database = await factory.openDatabase(dbPath);
    return database;
  }

  Future<String> _getDatabasePath() async {
    if (kIsWeb) {
      // You may need to adjust this path as per your web directory structure
      return '$_path/$_dbNameKey';
    } else {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      return join(appDocDir.path, _dbNameKey);
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    var categoryStore = intMapStoreFactory.store(_storeName);
    await categoryStore.add(db, {'name': 'Sample'});
    var contactStore = intMapStoreFactory.store(_storeContactName);
  }

  Future<int> insert(Map<String, dynamic> row) async {
    final database = await _database;
    var store = intMapStoreFactory.store(_storeName);
    return await store.add(database, row);
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    final database = await _database;
    var store = intMapStoreFactory.store(_storeName);
    var snapshots = await store.find(database);
    return snapshots.map((snapshot) => snapshot.value).toList();
  }

  Future<List<Map<String, dynamic>>> queryAllRowsofContact() async {
    final database = await _database;
    var store = intMapStoreFactory.store(_storeContactName);
    var snapshots = await store.find(database);
    return snapshots.map((snapshot) => snapshot.value).toList();
  }

  Future<int> queryRowCount() async {
    final database = await _database;
    var store = intMapStoreFactory.store(_storeName);
    var count = await store.count(database);
    return count;
  }

  Future<int> update(Map<String, dynamic> row) async {
    final database = await _database;
    var store = intMapStoreFactory.store(_storeName);
    int id = row['name']; // Modifique aqui conforme a chave primária
    var finder = Finder(filter: Filter.byKey(id));
    return await store.update(database, row, finder: finder);
  }

  Future<int> delete(int id) async {
    final database = await _database;
    var store = intMapStoreFactory.store(_storeName);
    var finder = Finder(filter: Filter.byKey(id));
    return await store.delete(database, finder: finder);
  }

  Future<int> deleteContact(int id) async {
    final database = await _database;
    var store = intMapStoreFactory.store(_storeContactName);
    var finder = Finder(filter: Filter.byKey(id));
    return await store.delete(database, finder: finder);
  }

  Future<int> insertContact(Map<String, dynamic> row) async {
    final database = await _database;
    var store = intMapStoreFactory.store(_storeContactName);
    controladorId++;
    row['id'] = controladorId;
    return await store.add(database, row);
  }
}
