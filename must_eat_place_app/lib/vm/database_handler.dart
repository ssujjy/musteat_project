import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/eat_place.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath(); // 설치할 위치를 정함.
    return openDatabase(
      join(path, 'eatplace.db'),
      onCreate: (db, version) async {
        await db.execute(
            "create table eatplace (seq integer primary key autoincrement, name text, phone text, lat real, lng real, image blob, review text, initdate text)");
      },
      version: 1,
    );
  }

  Future<List<EatPlace>> queryEatPlace() async {
    final Database db = await initializeDB();
    final List<Map<String, Object?>> queryResults =
        await db.rawQuery('select * from eatplace');
    return queryResults.map((e) => EatPlace.fromMap(e)).toList();
  }

  Future<int> insertEatPlace(EatPlace eatplace) async {
    // int result = 0;
    final Database db = await initializeDB();
    await db.rawInsert(
        'insert into eatplace(name, phone, lat, lng, image, review, inidate) values (?, ?, ?, ?, ?, ?, ?)',
        [eatplace.name, eatplace.phone, eatplace.lat, eatplace.lng, eatplace.image, eatplace.review, eatplace.initdate]);
    return 0;
  }

  Future<void> updateEatPlace(EatPlace eatplace) async {
    // int result = 0;
    final Database db = await initializeDB();
    await db.rawUpdate(
        'update eatplace set name=?, phone=?, lat=?, lng=?, image=?, review=?, initdate=?,  where seq=?',
        [eatplace.name, eatplace.phone, eatplace.lat, eatplace.lng, eatplace.image, eatplace.review, eatplace.initdate, eatplace.seq]);
    // return 0;
  }

  Future<void> deleteEatPlace(int seq) async {
    // int result = 0;
    final Database db = await initializeDB();
    await db.rawDelete('delete from eatplace where seq=?', [seq]);
    // return 0;
  }
}
