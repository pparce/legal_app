import 'dart:io';

import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  var db;

  Future initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'datos.db');

    final exits = await databaseExists(path);

    if (exits) {
      print('db already exits');
      db = await openDatabase(path);
    } else {
      print('creating a copy from assets');
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}
      ByteData data = await rootBundle.load(join("assets", "datos.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
      print('db copied');
    }
  }

  Future loadConstitucion() async {
    var articulos = await db.rawQuery('SELECT * FROM "constitucion"');
    return articulos.toList();
  }

  Future loadPenal() async {
    var articulos = await db.rawQuery('SELECT * FROM "penal"');
    return articulos.toList();
  }
}
