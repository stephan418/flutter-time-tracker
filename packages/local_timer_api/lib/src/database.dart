import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:timer_api/timer_api.dart';
import 'package:uuid/uuid.dart';

part 'database.g.dart';

/// The drift table for storing ´Task´ objects
///
/// Tasks represent units of work to be done by the user
@UseRowClass(Task)
class TaskItems extends Table {
  /// Auto-generated UUIDv4 primary key
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();

  /// Arbitrary-length title
  TextColumn get title => text()();

  /// Arbitrary-length description
  TextColumn get description => text()();

  /// Flag representing the backend sync status of the `Task`
  BoolColumn get isSynced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

/// The drift table for storing `Session` objects
///
/// Sessions represent an amount of consecutive time ([seconds]) worked at a
/// specific time ([startedAt]), optionally linked to a specific `Task`
/// ([taskId])
@UseRowClass(Session)
class SessionItems extends Table {
  /// Auto-generated UUIDv4 primary key
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();

  /// Number of consecutively elapsed seconds
  IntColumn get seconds => integer()();

  /// Date and time when the session was started
  DateTimeColumn get startedAt => dateTime()();

  /// The id of the optionally linked task
  TextColumn get taskId => text().nullable().references(TaskItems, #id)();
}

/// Low-level wrapper around the offline database used by the app
@DriftDatabase(tables: [TaskItems, SessionItems])
class AppDatabase extends _$AppDatabase {
  /// Creates a new instance of the database and opens a connection to the
  /// database file.
  ///
  /// The default location for the file is in the users 'Documents' directory
  AppDatabase({this.dbFileName}) : super(_openConnection());

  final String? dbFileName;

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    return NativeDatabase.createInBackground(file);
  });
}
