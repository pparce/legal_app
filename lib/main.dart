import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:legal/src/app.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:legal/src/database/models/articulo.model..dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ArticuloAdapter());

  // Hive.deleteFromDisk();
  runApp(MyApp());
}
