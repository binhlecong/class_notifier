import 'package:class_notifier/models/classroom.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'classroom.db'),
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE classroom(
          id INTEGER PRIMARY KEY AUTOINCREMENT, 
          title TEXT, 
          description TEXT,
          alarmBefore INTEGER,
          dateTime TEXT,
          weekDays INTEGER,
          url TEXT,
          importance INTEGER)''');
      },
      version: 1,
    );
  }

  Future<int> insertClassroom(Classroom classRoom) async {
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

  Future<int> updateClassroom(Classroom classroom) async {
    Database db = await database();
    return await db.update('classroom', classroom.toMap(),
        where: 'id = ?', whereArgs: [classroom.id]);
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

  Future<Classroom> getClassroom(int id) async {
    Database db = await database();
    List<Map<String, dynamic>> maps = await db.query('classroom',
        columns: [
          'id',
          'title',
          'description',
          'alarmBefore',
          'dateTime',
          'weekDays',
          'url',
          'importance'
        ],
        where: 'id = ?',
        whereArgs: [id]);
    return Classroom.fromMap(maps.first);
  }

  Future<List<Classroom>> getClassrooms() async {
    Database _db = await database();
    List<Map<String, dynamic>> classroomMap = await _db.query('classroom');
    return List.generate(classroomMap.length, (index) {
      return Classroom.fromMap(classroomMap[index]);
    });
  }

  Future<void> deleteClassroom(int id) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM classroom WHERE id = '$id'");
  }
}
