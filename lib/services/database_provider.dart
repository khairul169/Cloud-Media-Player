import 'dart:async';
import 'package:idb_shim/idb.dart';
import 'package:idb_sqflite/idb_client_sqflite.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

class DBProvider {
  static Database _db;

  static final String storeItems = 'items';

  static Future<Database> getDatabase() async {
    if (_db != null) {
      return _db;
    }

    // Database factory
    var idbFactory = getIdbFactorySqflite(sqflite.databaseFactory);

    // Open database
    _db = await idbFactory.open(
      'app.db',
      version: 1,
      onUpgradeNeeded: onUpgradeNeeded,
    );
    return _db;
  }

  static void onUpgradeNeeded(VersionChangeEvent event) {
    var db = event.database;
    db.createObjectStore(storeItems, autoIncrement: true);
  }

  static Future<ObjectStore> getStore(String name, [bool write = false]) async {
    var db = await getDatabase();
    var tx = db.transaction(name, write ? idbModeReadWrite : idbModeReadOnly);
    return tx.objectStore(name);
  }

  static Future<int> save(String storeName, dynamic data, {int id}) async {
    var store = await getStore(storeName, true);
    if (id != null) {
      await store.put(data, id);
      return id;
    } else {
      return await store.add(data) as int;
    }
  }

  static Future<dynamic> getById(String storeName, int id) async {
    var store = await getStore(storeName);
    var object = await store.getObject(id);
    return object;
  }

  static Future<void> remove(String storeName, int id) async {
    var store = await getStore(storeName, true);
    await store.delete(id);
  }

  static Future<DBFindResult> findWhere(
    String storeName,
    Function(dynamic data) isTrue,
  ) async {
    var store = await getStore(storeName);
    var completer = Completer<DBFindResult>();

    store.openCursor(direction: idbDirectionPrev).listen((cursor) {
      var value = cursor.value;
      if (isTrue(value)) {
        completer.complete(DBFindResult(
          id: cursor.primaryKey,
          data: cursor.value,
        ));
      } else {
        cursor.next();
      }
    }, onDone: () {
      completer.complete(null);
    });

    return await completer.future;
  }
}

class DBFindResult {
  final int id;
  final dynamic data;

  DBFindResult({this.id, this.data});
}
