import 'package:class_notifier/models/classroom.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'classroom.db'),
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE classroom(
          id INTEGER PRIMARY KEY, 
          title TEXT, 
          description TEXT,
          dateTime TEXT,
          weekDays INTEGER,
          url TEXT,
          importance INTEGER)''');
      },
      version: 1,
    );
  }

  Future<int> insertTask(Classroom classRoom) async {
    int classroomId = 0;
    Database _db = await database();
    await _db
        .insert('classroom', classRoom.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      classroomId = value;
    });
    return classroomId;
  }

  Future<void> updateClassroomTitle(int id, String title) async {
    Database _db = await database();
    await _db
        .rawUpdate("UPDATE classroom SET title = '$title' WHERE id = '$id'");
  }

  Future<void> updateClassroomDescription(int id, String description) async {
    Database _db = await database();
    await _db.rawUpdate(
        "UPDATE classroom SET description = '$description' WHERE id = '$id'");
  }

  Future<List<Classroom>> getClassrooms() async {
    Database _db = await database();
    List<Map<String, dynamic>> classroomMap = await _db.query('classroom');
    return List.generate(classroomMap.length, (index) {
      return Classroom.fromMap(classroomMap[index]);
    });
  }

  Future<void> deleteTask(int id) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM classroom WHERE id = '$id'");
  }
}
