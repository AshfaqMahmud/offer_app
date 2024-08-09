import 'package:offer_app/model/AdModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';

class DBhelper {
  static final DBhelper _instance = DBhelper._internal();
  static Database? _db;

  factory DBhelper() {
    return _instance;
  }

  DBhelper._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;

    _db = await _initDatabase();

    return _db!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'ad_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE ads(id INTEGER PRIMARY KEY AUTOINCREMENT, adImage TEXT, adDescription TEXT)",
        );
      },
    );
  }

  Future<int> insertAd (Ad ad) async {
    Database db = await database;
    return await db.insert('ads', ad.toMap());
  }

  Future<List<Ad>> getAds() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('ads');
    return List.generate(maps.length, (i) {
      return Ad.fromMap(maps[i]);
    });
  }

  Future<int> updateAd(Ad ad) async {
    Database db = await database;
    return await db.update('ads', ad.toMap(), where: 'id = ?', whereArgs: [ad.id]);
  }

  Future<int> deleteAd(int id) async {
    Database db = await database;
    return await db.delete('ads', where: 'id = ?', whereArgs: [id]);
  }
}
