// InMemoryStore 実装（M2-E2：テスト用）

import 'local_store.dart';
import '../model/persona_entity.dart';
import '../model/persona_snapshot_entity.dart';
import '../model/session_entity.dart';
import '../model/message_entity.dart';
import '../model/guard_event_entity.dart';
import '../model/crystal_entity.dart';

/// メモリ内ローカルストア（テスト用）
///
/// すべてのデータをメモリ内の Map で保持する最小実装。
/// テストや開発時に使用。本番では永続化実装に置き換える。
class InMemoryStore implements LocalStore {
  final Map<String, PersonaEntity> _personas = {};
  final Map<String, PersonaSnapshotEntity> _personaSnapshots = {};
  final Map<String, SessionEntity> _sessions = {};
  final Map<String, MessageEntity> _messages = {};
  final Map<String, GuardEventEntity> _guardEvents = {};
  final Map<String, CrystalEntity> _crystals = {};

  // ========== Persona ==========
  @override
  Future<void> upsertPersona(PersonaEntity entity) async {
    _personas[entity.personaId] = entity;
  }

  @override
  Future<PersonaEntity?> getPersona(String personaId) async {
    return _personas[personaId];
  }

  @override
  Future<List<PersonaEntity>> listPersonas({bool includeDeleted = false}) async {
    final all = _personas.values.toList();
    if (includeDeleted) return all;
    return all.where((e) => !e.sync.isDeleted).toList();
  }

  @override
  Future<void> deletePersona(String personaId) async {
    final entity = _personas[personaId];
    if (entity != null) {
      final deleted = entity.copyWith(
        sync: entity.sync.copyWith(
          deletedAt: DateTime.now().toIso8601String(),
        ),
      );
      _personas[personaId] = deleted;
    }
  }

  // ========== PersonaSnapshot ==========
  @override
  Future<void> upsertPersonaSnapshot(PersonaSnapshotEntity entity) async {
    _personaSnapshots[entity.snapshotId] = entity;
  }

  @override
  Future<PersonaSnapshotEntity?> getPersonaSnapshot(String snapshotId) async {
    return _personaSnapshots[snapshotId];
  }

  @override
  Future<List<PersonaSnapshotEntity>> listPersonaSnapshotsBySession(
    String sessionId, {
    bool includeDeleted = false,
  }) async {
    final all = _personaSnapshots.values
        .where((e) => e.sessionId == sessionId)
        .toList();
    if (includeDeleted) return all;
    return all.where((e) => !e.sync.isDeleted).toList();
  }

  // ========== Session ==========
  @override
  Future<void> upsertSession(SessionEntity entity) async {
    _sessions[entity.sessionId] = entity;
  }

  @override
  Future<SessionEntity?> getSession(String sessionId) async {
    return _sessions[sessionId];
  }

  @override
  Future<List<SessionEntity>> listSessions({bool includeDeleted = false}) async {
    final all = _sessions.values.toList();
    if (includeDeleted) return all;
    return all.where((e) => !e.sync.isDeleted).toList();
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    final entity = _sessions[sessionId];
    if (entity != null) {
      final deleted = entity.copyWith(
        sync: entity.sync.copyWith(
          deletedAt: DateTime.now().toIso8601String(),
        ),
      );
      _sessions[sessionId] = deleted;
    }
  }

  // ========== Message ==========
  @override
  Future<void> upsertMessage(MessageEntity entity) async {
    _messages[entity.messageId] = entity;
  }

  @override
  Future<MessageEntity?> getMessage(String messageId) async {
    return _messages[messageId];
  }

  @override
  Future<List<MessageEntity>> listMessagesBySession(
    String sessionId, {
    bool includeDeleted = false,
  }) async {
    final all = _messages.values
        .where((e) => e.sessionId == sessionId)
        .toList();
    if (includeDeleted) return all;
    return all.where((e) => !e.sync.isDeleted).toList();
  }

  // ========== GuardEvent ==========
  @override
  Future<void> upsertGuardEvent(GuardEventEntity entity) async {
    _guardEvents[entity.eventId] = entity;
  }

  @override
  Future<GuardEventEntity?> getGuardEvent(String eventId) async {
    return _guardEvents[eventId];
  }

  @override
  Future<List<GuardEventEntity>> listGuardEventsBySession(
    String sessionId, {
    bool includeDeleted = false,
  }) async {
    final all = _guardEvents.values
        .where((e) => e.sessionId == sessionId)
        .toList();
    if (includeDeleted) return all;
    return all.where((e) => !e.sync.isDeleted).toList();
  }

  // ========== Crystal ==========
  @override
  Future<void> upsertCrystal(CrystalEntity entity) async {
    _crystals[entity.crystalId] = entity;
  }

  @override
  Future<CrystalEntity?> getCrystal(String crystalId) async {
    return _crystals[crystalId];
  }

  @override
  Future<List<CrystalEntity>> listCrystals({bool includeDeleted = false}) async {
    final all = _crystals.values.toList();
    if (includeDeleted) return all;
    return all.where((e) => !e.sync.isDeleted).toList();
  }

  @override
  Future<List<CrystalEntity>> listCrystalsBySession(
    String sessionId, {
    bool includeDeleted = false,
  }) async {
    final all = _crystals.values
        .where((e) => e.sessionId == sessionId)
        .toList();
    if (includeDeleted) return all;
    return all.where((e) => !e.sync.isDeleted).toList();
  }

  @override
  Future<void> deleteCrystal(String crystalId) async {
    final entity = _crystals[crystalId];
    if (entity != null) {
      final deleted = entity.copyWith(
        sync: entity.sync.copyWith(
          deletedAt: DateTime.now().toIso8601String(),
        ),
      );
      _crystals[crystalId] = deleted;
    }
  }

  // ========== Utility ==========
  @override
  Future<void> clearAll() async {
    _personas.clear();
    _personaSnapshots.clear();
    _sessions.clear();
    _messages.clear();
    _guardEvents.clear();
    _crystals.clear();
  }

  @override
  Future<void> close() async {
    // メモリ内実装なので何もしない
  }
}
