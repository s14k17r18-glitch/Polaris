// LocalStore インターフェース（M2-E2：ローカル保存基盤）

import '../model/persona_entity.dart';
import '../model/persona_snapshot_entity.dart';
import '../model/session_entity.dart';
import '../model/message_entity.dart';
import '../model/guard_event_entity.dart';
import '../model/crystal_entity.dart';

/// ローカル保存インターフェース
///
/// すべてのエンティティに対する基本的な CRUD 操作を提供。
/// - upsert: 作成または更新（ID が同じなら更新、なければ作成）
/// - get: 単一取得（ID 指定）
/// - list: 一覧取得（deleted_at が null のものだけ）
/// - delete: 論理削除（deleted_at を設定）
abstract class LocalStore {
  // ========== Persona ==========
  Future<void> upsertPersona(PersonaEntity entity);
  Future<PersonaEntity?> getPersona(String personaId);
  Future<List<PersonaEntity>> listPersonas({bool includeDeleted = false});
  Future<void> deletePersona(String personaId);

  // ========== PersonaSnapshot ==========
  Future<void> upsertPersonaSnapshot(PersonaSnapshotEntity entity);
  Future<PersonaSnapshotEntity?> getPersonaSnapshot(String snapshotId);
  Future<List<PersonaSnapshotEntity>> listPersonaSnapshotsBySession(
    String sessionId, {
    bool includeDeleted = false,
  });

  // ========== Session ==========
  Future<void> upsertSession(SessionEntity entity);
  Future<SessionEntity?> getSession(String sessionId);
  Future<List<SessionEntity>> listSessions({bool includeDeleted = false});
  Future<void> deleteSession(String sessionId);

  // ========== Message ==========
  Future<void> upsertMessage(MessageEntity entity);
  Future<MessageEntity?> getMessage(String messageId);
  Future<List<MessageEntity>> listMessagesBySession(
    String sessionId, {
    bool includeDeleted = false,
  });

  // ========== GuardEvent ==========
  Future<void> upsertGuardEvent(GuardEventEntity entity);
  Future<GuardEventEntity?> getGuardEvent(String eventId);
  Future<List<GuardEventEntity>> listGuardEventsBySession(
    String sessionId, {
    bool includeDeleted = false,
  });

  // ========== Crystal ==========
  Future<void> upsertCrystal(CrystalEntity entity);
  Future<CrystalEntity?> getCrystal(String crystalId);
  Future<List<CrystalEntity>> listCrystals({bool includeDeleted = false});
  Future<List<CrystalEntity>> listCrystalsBySession(
    String sessionId, {
    bool includeDeleted = false,
  });
  Future<void> deleteCrystal(String crystalId);

  // ========== Utility ==========
  /// すべてのデータをクリア（テスト用）
  Future<void> clearAll();

  /// ストアを閉じる（リソース解放）
  Future<void> close();
}
