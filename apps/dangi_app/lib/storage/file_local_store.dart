// FileLocalStore 実装（M2-E3：JSON Lines 永続化）

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_core/shared_core.dart';

/// JSON Lines ファイルベースのローカルストア
///
/// - 各エンティティを別ファイルに保存（personas.jsonl, sessions.jsonl 等）
/// - 1行=1レコード（JSON Lines 形式）
/// - upsert: 新しいレコードを追記
/// - get/list: ファイル全体を読み、ID ごとに最新 rev/updated_at を採用
/// - delete: tombstone（deleted_at 入り）を追記
class FileLocalStore implements LocalStore {
  FileLocalStore({Directory? storageDirectory})
      : _storageDirectory = storageDirectory;

  Directory? _storageDirectory;

  Future<Directory> get _dir async {
    if (_storageDirectory != null) return _storageDirectory!;
    final appDir = await getApplicationDocumentsDirectory();
    _storageDirectory = Directory('${appDir.path}/hokyoksei_data');
    if (!await _storageDirectory!.exists()) {
      await _storageDirectory!.create(recursive: true);
    }
    return _storageDirectory!;
  }

  File _getFile(String name) => File('${_storageDirectory!.path}/$name.jsonl');

  // ========== Helper: 追記 ==========
  Future<void> _append(String filename, Map<String, dynamic> data) async {
    await _dir; // ディレクトリ初期化を保証
    final file = _getFile(filename);
    final line = '${jsonEncode(data)}\n';
    await file.writeAsString(line, mode: FileMode.append);
  }

  // ========== Helper: 全読み込み ==========
  Future<List<Map<String, dynamic>>> _readAll(String filename) async {
    await _dir; // ディレクトリ初期化を保証
    final file = _getFile(filename);
    if (!await file.exists()) return [];

    final lines = await file.readAsLines();
    return lines
        .where((line) => line.trim().isNotEmpty)
        .map((line) => jsonDecode(line) as Map<String, dynamic>)
        .toList();
  }

  // ========== Helper: ID ごとに最新を取得 ==========
  Map<String, T> _getLatest<T>(
    List<Map<String, dynamic>> records,
    T Function(Map<String, dynamic>) fromJson,
    String Function(T) getId,
  ) {
    final map = <String, T>{};
    final recordMap = <String, Map<String, dynamic>>{}; // 元のJSONも保持

    for (final record in records) {
      final entity = fromJson(record);
      final id = getId(entity);
      final existing = map[id];
      if (existing == null) {
        map[id] = entity;
        recordMap[id] = record;
      } else {
        // updated_at を比較して最新を保持
        final existingUpdated = recordMap[id]!['updated_at'] as String? ?? '';
        final newUpdated = record['updated_at'] as String? ?? '';
        if (newUpdated.compareTo(existingUpdated) > 0) {
          map[id] = entity;
          recordMap[id] = record;
        }
      }
    }
    return map;
  }

  // ========== Persona ==========
  @override
  Future<void> upsertPersona(PersonaEntity entity) async {
    await _append('personas', entity.toJson());
  }

  @override
  Future<PersonaEntity?> getPersona(String personaId) async {
    final records = await _readAll('personas');
    final map = _getLatest<PersonaEntity>(
      records,
      PersonaEntity.fromJson,
      (e) => e.personaId,
    );
    return map[personaId];
  }

  @override
  Future<List<PersonaEntity>> listPersonas({bool includeDeleted = false}) async {
    final records = await _readAll('personas');
    final map = _getLatest<PersonaEntity>(
      records,
      PersonaEntity.fromJson,
      (e) => e.personaId,
    );
    final list = map.values.toList();
    if (includeDeleted) return list;
    return list.where((e) => !e.sync.isDeleted).toList();
  }

  @override
  Future<void> deletePersona(String personaId) async {
    final entity = await getPersona(personaId);
    if (entity != null) {
      final now = DateTime.now().toIso8601String();
      final deleted = entity.copyWith(
        sync: entity.sync.copyWith(
          deletedAt: now,
          updatedAt: now,
        ),
      );
      await _append('personas', deleted.toJson());
    }
  }

  // ========== PersonaSnapshot ==========
  @override
  Future<void> upsertPersonaSnapshot(PersonaSnapshotEntity entity) async {
    await _append('persona_snapshots', entity.toJson());
  }

  @override
  Future<PersonaSnapshotEntity?> getPersonaSnapshot(String snapshotId) async {
    final records = await _readAll('persona_snapshots');
    final map = _getLatest<PersonaSnapshotEntity>(
      records,
      PersonaSnapshotEntity.fromJson,
      (e) => e.snapshotId,
    );
    return map[snapshotId];
  }

  @override
  Future<List<PersonaSnapshotEntity>> listPersonaSnapshotsBySession(
    String sessionId, {
    bool includeDeleted = false,
  }) async {
    final records = await _readAll('persona_snapshots');
    final map = _getLatest<PersonaSnapshotEntity>(
      records,
      PersonaSnapshotEntity.fromJson,
      (e) => e.snapshotId,
    );
    final list = map.values.where((e) => e.sessionId == sessionId).toList();
    if (includeDeleted) return list;
    return list.where((e) => !e.sync.isDeleted).toList();
  }

  // ========== Session ==========
  @override
  Future<void> upsertSession(SessionEntity entity) async {
    await _append('sessions', entity.toJson());
  }

  @override
  Future<SessionEntity?> getSession(String sessionId) async {
    final records = await _readAll('sessions');
    final map = _getLatest<SessionEntity>(
      records,
      SessionEntity.fromJson,
      (e) => e.sessionId,
    );
    return map[sessionId];
  }

  @override
  Future<List<SessionEntity>> listSessions({bool includeDeleted = false}) async {
    final records = await _readAll('sessions');
    final map = _getLatest<SessionEntity>(
      records,
      SessionEntity.fromJson,
      (e) => e.sessionId,
    );
    final list = map.values.toList();
    if (includeDeleted) return list;
    return list.where((e) => !e.sync.isDeleted).toList();
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    final entity = await getSession(sessionId);
    if (entity != null) {
      final now = DateTime.now().toIso8601String();
      final deleted = entity.copyWith(
        sync: entity.sync.copyWith(
          deletedAt: now,
          updatedAt: now,
        ),
      );
      await _append('sessions', deleted.toJson());
    }
  }

  // ========== Message ==========
  @override
  Future<void> upsertMessage(MessageEntity entity) async {
    await _append('messages', entity.toJson());
  }

  @override
  Future<MessageEntity?> getMessage(String messageId) async {
    final records = await _readAll('messages');
    final map = _getLatest<MessageEntity>(
      records,
      MessageEntity.fromJson,
      (e) => e.messageId,
    );
    return map[messageId];
  }

  @override
  Future<List<MessageEntity>> listMessagesBySession(
    String sessionId, {
    bool includeDeleted = false,
  }) async {
    final records = await _readAll('messages');
    final map = _getLatest<MessageEntity>(
      records,
      MessageEntity.fromJson,
      (e) => e.messageId,
    );
    final list = map.values.where((e) => e.sessionId == sessionId).toList();
    if (includeDeleted) return list;
    return list.where((e) => !e.sync.isDeleted).toList();
  }

  // ========== GuardEvent ==========
  @override
  Future<void> upsertGuardEvent(GuardEventEntity entity) async {
    await _append('guard_events', entity.toJson());
  }

  @override
  Future<GuardEventEntity?> getGuardEvent(String eventId) async {
    final records = await _readAll('guard_events');
    final map = _getLatest<GuardEventEntity>(
      records,
      GuardEventEntity.fromJson,
      (e) => e.eventId,
    );
    return map[eventId];
  }

  @override
  Future<List<GuardEventEntity>> listGuardEventsBySession(
    String sessionId, {
    bool includeDeleted = false,
  }) async {
    final records = await _readAll('guard_events');
    final map = _getLatest<GuardEventEntity>(
      records,
      GuardEventEntity.fromJson,
      (e) => e.eventId,
    );
    final list = map.values.where((e) => e.sessionId == sessionId).toList();
    if (includeDeleted) return list;
    return list.where((e) => !e.sync.isDeleted).toList();
  }

  // ========== Crystal ==========
  @override
  Future<void> upsertCrystal(CrystalEntity entity) async {
    await _append('crystals', entity.toJson());
  }

  @override
  Future<CrystalEntity?> getCrystal(String crystalId) async {
    final records = await _readAll('crystals');
    final map = _getLatest<CrystalEntity>(
      records,
      CrystalEntity.fromJson,
      (e) => e.crystalId,
    );
    return map[crystalId];
  }

  @override
  Future<List<CrystalEntity>> listCrystals({bool includeDeleted = false}) async {
    final records = await _readAll('crystals');
    final map = _getLatest<CrystalEntity>(
      records,
      CrystalEntity.fromJson,
      (e) => e.crystalId,
    );
    final list = map.values.toList();
    if (includeDeleted) return list;
    return list.where((e) => !e.sync.isDeleted).toList();
  }

  @override
  Future<List<CrystalEntity>> listCrystalsBySession(
    String sessionId, {
    bool includeDeleted = false,
  }) async {
    final records = await _readAll('crystals');
    final map = _getLatest<CrystalEntity>(
      records,
      CrystalEntity.fromJson,
      (e) => e.crystalId,
    );
    final list = map.values.where((e) => e.sessionId == sessionId).toList();
    if (includeDeleted) return list;
    return list.where((e) => !e.sync.isDeleted).toList();
  }

  @override
  Future<void> deleteCrystal(String crystalId) async {
    final entity = await getCrystal(crystalId);
    if (entity != null) {
      final now = DateTime.now().toIso8601String();
      final deleted = entity.copyWith(
        sync: entity.sync.copyWith(
          deletedAt: now,
          updatedAt: now,
        ),
      );
      await _append('crystals', deleted.toJson());
    }
  }

  // ========== Utility ==========
  @override
  Future<void> clearAll() async {
    final dir = await _dir;
    if (await dir.exists()) {
      await dir.delete(recursive: true);
      await dir.create();
    }
  }

  @override
  Future<void> close() async {
    // ファイルベースなので特に何もしない
  }
}
