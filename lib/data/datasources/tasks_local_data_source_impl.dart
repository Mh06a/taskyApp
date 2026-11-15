import 'package:sqflite/sqflite.dart';
import 'package:tasky/core/constants/database_constants.dart';
import 'package:tasky/core/services/database_service.dart';
import 'package:tasky/data/datasources/tasks_local_data_source.dart';
import 'package:tasky/data/models/task_model.dart';

final class TasksLocalDataSourceImpl implements TasksLocalDataSource {
  const TasksLocalDataSourceImpl(this._databaseService);

  final DatabaseService _databaseService;

  @override
  Future<List<TaskModel>> getTasks() async {
    final db = await _databaseService.database;
    final rows = await db.query(
      TasksTable.name,
      orderBy: '${TasksTable.createdAt} DESC',
    );
    return rows.map(TaskModel.fromMap).toList();
  }

  @override
  Future<void> insertTask(TaskModel task) async {
    final db = await _databaseService.database;
    await db.insert(
      TasksTable.name,
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  @override
  Future<bool> updateTask(TaskModel task) async {
    final db = await _databaseService.database;
    final updatedRows = await db.update(
      TasksTable.name,
      task.toMap(),
      where: '${TasksTable.id} = ?',
      whereArgs: [task.id],
    );
    return updatedRows > 0;
  }

  @override
  Future<void> deleteTask(String id) async {
    final db = await _databaseService.database;
    await db.delete(
      TasksTable.name,
      where: '${TasksTable.id} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> deleteAllTasks() async {
    final db = await _databaseService.database;
    await db.delete(TasksTable.name);
  }
}
