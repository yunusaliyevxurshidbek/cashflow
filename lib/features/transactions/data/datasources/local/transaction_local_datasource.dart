import 'dart:convert';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart' hide DatabaseException;
import '../../../../../../core/errors/exceptions.dart';
import '../../../domain/entities/transaction_entity.dart';
import '../../models/transaction_model.dart';

class TransactionLocalDataSource {
  final String dbPath;
  Database? _db;
  static const _table = 'transactions';

  TransactionLocalDataSource({required this.dbPath});

  Future<void> init() async {
    try {
      final dir = p.dirname(dbPath);
      await databaseFactory.setDatabasesPath(dir);
      _db = await openDatabase(dbPath, version: 1, onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS $_table (
            id TEXT PRIMARY KEY,
            type TEXT NOT NULL,
            category TEXT NOT NULL,
            amount REAL NOT NULL,
            date INTEGER NOT NULL,
            note TEXT
          )
        ''');
      }, onOpen: (db) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS $_table (
            id TEXT PRIMARY KEY,
            type TEXT NOT NULL,
            category TEXT NOT NULL,
            amount REAL NOT NULL,
            date INTEGER NOT NULL,
            note TEXT
          )
        ''');
      });
    } catch (e) {
      throw DatabaseException('Failed to init database: $e');
    }
  }

  Database get _requireDb {
    final db = _db;
    if (db == null) throw DatabaseException('Database not initialized');
    return db;
  }

  Future<void> seedIfEmpty() async {
    final db = _requireDb;
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $_table')) ?? 0;
    if (count > 0) return;
    final samples = <TransactionModel>[];
    final batch = db.batch();
    for (final m in samples) {
      batch.insert(_table, m.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<void> add(TransactionEntity e) async {
    try {
      final db = _requireDb;
      await db.insert(_table, TransactionModel.fromEntity(e).toJson(), conflictAlgorithm: ConflictAlgorithm.abort);
    } catch (e) {
      throw DatabaseException('Add failed: $e');
    }
  }

  Future<void> update(TransactionEntity e) async {
    try {
      final db = _requireDb;
      await db.update(_table, TransactionModel.fromEntity(e).toJson(), where: 'id = ?', whereArgs: [e.id]);
    } catch (e) {
      throw DatabaseException('Update failed: $e');
    }
  }

  Future<void> delete(String id) async {
    try {
      final db = _requireDb;
      await db.delete(_table, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw DatabaseException('Delete failed: $e');
    }
  }

  Future<List<TransactionEntity>> getAll() async {
    try {
      final db = _requireDb;
      final maps = await db.query(_table, orderBy: 'date DESC');
      return maps.map((m) => TransactionModel.fromJson(m).toEntity()).toList();
    } catch (e) {
      throw DatabaseException('Fetch failed: $e');
    }
  }

  Future<List<TransactionEntity>> filter({
    TransactionType? type,
    DateTime? start,
    DateTime? end,
    String? category,
    String? search,
  }) async {
    try {
      final db = _requireDb;
      final where = <String>[];
      final args = <Object?>[];
      if (type != null) {
        where.add('type = ?');
        args.add(type.name);
      }
      if (start != null) {
        where.add('date >= ?');
        args.add(start.millisecondsSinceEpoch);
      }
      if (end != null) {
        where.add('date <= ?');
        args.add(end.millisecondsSinceEpoch);
      }
      if (category != null && category.isNotEmpty) {
        where.add('LOWER(category) = ?');
        args.add(category.toLowerCase());
      }
      if (search != null && search.isNotEmpty) {
        final q = '%${search.toLowerCase()}%';
        where.add('(LOWER(category) LIKE ? OR LOWER(note) LIKE ?)');
        args.addAll([q, q]);
      }
      final maps = await db.query(
        _table,
        where: where.isEmpty ? null : where.join(' AND '),
        whereArgs: where.isEmpty ? null : args,
        orderBy: 'date DESC',
      );
      return maps.map((m) => TransactionModel.fromJson(m).toEntity()).toList();
    } catch (e) {
      throw DatabaseException('Filter failed: $e');
    }
  }

  Future<String> exportJson() async {
    final records = await getAll();
    final jsonList = records.map((e) => TransactionModel.fromEntity(e).toJson()).toList();
    return const JsonEncoder.withIndent('  ').convert(jsonList);
  }

  Future<int> importJson(String jsonString) async {
    try {
      final parsed = json.decode(jsonString);
      if (parsed is! List) throw const FormatException('JSON must be a list');
      final db = _requireDb;
      final batch = db.batch();
      int count = 0;
      for (final item in parsed) {
        if (item is! Map<String, dynamic>) continue;
        if (!item.containsKey('id') || !item.containsKey('type') || !item.containsKey('category') || !item.containsKey('amount') || !item.containsKey('date')) {
          continue;
        }
        final incoming = TransactionModel.fromJson(item);
        final existing = await db.query(_table, where: 'id = ?', whereArgs: [incoming.id]);
        if (existing.isEmpty) {
          batch.insert(_table, incoming.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
          count++;
        } else {
          final current = TransactionModel.fromJson(existing.first);
          final keep = incoming.date >= current.date ? incoming : current;
          batch.insert(_table, keep.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
          count++;
        }
      }
      await batch.commit(noResult: true);
      return count;
    } on FormatException catch (e) {
      throw DatabaseException('Invalid JSON: ${e.message}');
    } catch (e) {
      throw DatabaseException('Import failed: $e');
    }
  }
}

