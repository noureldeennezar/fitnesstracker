import 'package:sqflite/sqflite.dart';
import '../models/workout.dart';
import '../models/exercise.dart';
import 'package:path/path.dart';

class WorkoutDatabase {
  static final WorkoutDatabase _instance = WorkoutDatabase._internal();
  factory WorkoutDatabase() => _instance;
  WorkoutDatabase._internal();
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'workout_database.db');
    return await openDatabase(
      path,
      version: 3,  // Increment the version number
      onCreate: (db, version) async {
        await _createDb(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          await db.execute('DROP TABLE IF EXISTS exercises');
          await db.execute('DROP TABLE IF EXISTS workouts');
          await _createDb(db);
        }
      },
    );
  }

  Future<void> _createDb(Database db) async {
    await db.execute('''CREATE TABLE workouts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT,
        category TEXT  
      )''');
    await db.execute('''CREATE TABLE exercises (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        workoutId INTEGER,
        name TEXT,
        duration INTEGER,
        FOREIGN KEY(workoutId) REFERENCES workouts(id) ON DELETE CASCADE
      )''');
  }

  Future<void> insertWorkout(Workout workout) async {
    final db = await database;
    final workoutId = await db.insert('workouts', workout.toMap());
    for (var exercise in workout.exercises) {
      await db.insert('exercises', {
        'workoutId': workoutId,
        'name': exercise.name,
        'duration': exercise.duration,
      });
    }
  }

  Future<List<Workout>> getAllWorkouts() async {
    final db = await database;
    final workoutsData = await db.query('workouts');
    List<Workout> workouts = [];

    for (var workoutData in workoutsData) {
      final exercisesData = await db.query(
        'exercises',
        where: 'workoutId = ?',
        whereArgs: [workoutData['id']],
      );

      final exercises = exercisesData
          .map((exercise) => Exercise(
        name: exercise['name'] as String,
        duration: exercise['duration'] as int,
      ))
          .toList();

      workouts.add(Workout(
        id: workoutData['id'] as int,
        name: workoutData['name'] as String,
        description: workoutData['description'] as String?, // Nullable
        category: workoutData['category'] != null ? workoutData['category'] as String : null, // Handle nullable category
        exercises: exercises,
      ));
    }
    return workouts;
  }

  Future<void> updateWorkout(Workout workout) async {
    final db = await database;
    await db.update(
      'workouts',
      workout.toMap(),
      where: 'id = ?',
      whereArgs: [workout.id],
    );
    await db.delete('exercises', where: 'workoutId = ?', whereArgs: [workout.id]);
    for (var exercise in workout.exercises) {
      await db.insert('exercises', {
        'workoutId': workout.id,
        'name': exercise.name,
        'duration': exercise.duration,
      });
    }
  }

  Future<int> deleteWorkout(int id) async {
    final db = await database;
    return await db.delete(
      'workouts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
