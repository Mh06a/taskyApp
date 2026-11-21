import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tasky/core/constants/database_constants.dart';

class DatabaseService {
  DatabaseService({String? path}) : _path = path;

  final String? _path;

  Future<Database>? _opening;
  Future<void>? _closing;

  Future<Database> get database async {
    final closing = _closing;
    if (closing != null) {
      await closing;
    }

    final opening = _opening ??= _open();

    try {
      return await opening;
    } catch (_) {
      if (identical(_opening, opening)) {
        _opening = null;
      }
      rethrow;
    }
  }

  Future<void> close() async {
    final existingClosing = _closing;

    if (existingClosing != null) {
      await existingClosing;
      return;
    }

    final opening = _opening;
    if (opening == null) return;

    _opening = null;

    final closing = _closeDatabase(opening);
    _closing = closing;

    try {
      await closing;
    } finally {
      if (identical(_closing, closing)) {
        _closing = null;
      }
    }
  }

  Future<void> _closeDatabase(Future<Database> opening) async {
    final db = await opening;
    await db.close();
  }

  Future<Database> _open() async {
    final path =
        _path ?? join(
          await getDatabasesPath(),
          DatabaseConstants.name,
        );

    return openDatabase(
      path,
      version: DatabaseConstants.version,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Keep this migration hook explicit. Schema changes must be incremental and
    // non-destructive; do not drop user tables during upgrades.
    if (oldVersion < 2) {
      // Version 2 introduces migration infrastructure only; schema is unchanged.
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE ${TasksTable.name} (
        ${TasksTable.id} TEXT PRIMARY KEY,
        ${TasksTable.title} TEXT NOT NULL,
        ${TasksTable.description} TEXT NOT NULL DEFAULT '',
        ${TasksTable.priority} TEXT NOT NULL DEFAULT 'normal',
        ${TasksTable.dueDate} INTEGER,
        ${TasksTable.hasDueTime} INTEGER NOT NULL DEFAULT 0,
        ${TasksTable.createdAt} INTEGER NOT NULL,
        ${TasksTable.completedAt} INTEGER
      )
    ''');
  }
}