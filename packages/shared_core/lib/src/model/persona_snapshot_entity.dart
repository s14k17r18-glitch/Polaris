// PersonaSnapshot エンティティ（M2-E1：保存・同期用）

import 'sync_metadata.dart';

/// PersonaSnapshot エンティティ
///
/// セッション実行時点の Persona 定義を固定保存するためのエンティティ。
/// Persona 定義が後で変わっても、過去のセッションは当時の定義で再現できる。
/// - snapshot_id: スナップショットの一意ID
/// - session_id: 所属するセッションID
/// - persona_id: 元の Persona ID
/// - persona_version: 当時の Persona 版
/// - definition_json: 当時の PersonaDefinition のJSON表現
/// - sync: 同期メタデータ
class PersonaSnapshotEntity {
  const PersonaSnapshotEntity({
    required this.snapshotId,
    required this.sessionId,
    required this.personaId,
    required this.personaVersion,
    required this.definitionJson,
    required this.sync,
  });

  /// スナップショットの一意ID
  final String snapshotId;

  /// 所属するセッションID
  final String sessionId;

  /// 元の Persona ID
  final String personaId;

  /// 当時の Persona 版
  final int personaVersion;

  /// 当時の PersonaDefinition のJSON表現
  final Map<String, dynamic> definitionJson;

  /// 同期メタデータ
  final SyncMetadata sync;

  /// JSON からデシリアライズ
  factory PersonaSnapshotEntity.fromJson(Map<String, dynamic> json) {
    return PersonaSnapshotEntity(
      snapshotId: json['snapshot_id'] as String,
      sessionId: json['session_id'] as String,
      personaId: json['persona_id'] as String,
      personaVersion: json['persona_version'] as int,
      definitionJson: json['definition_json'] as Map<String, dynamic>,
      sync: SyncMetadata.fromJson(json),
    );
  }

  /// JSON へシリアライズ
  Map<String, dynamic> toJson() {
    return {
      'snapshot_id': snapshotId,
      'session_id': sessionId,
      'persona_id': personaId,
      'persona_version': personaVersion,
      'definition_json': definitionJson,
      ...sync.toJson(),
    };
  }

  /// コピー（部分更新用）
  PersonaSnapshotEntity copyWith({
    String? snapshotId,
    String? sessionId,
    String? personaId,
    int? personaVersion,
    Map<String, dynamic>? definitionJson,
    SyncMetadata? sync,
  }) {
    return PersonaSnapshotEntity(
      snapshotId: snapshotId ?? this.snapshotId,
      sessionId: sessionId ?? this.sessionId,
      personaId: personaId ?? this.personaId,
      personaVersion: personaVersion ?? this.personaVersion,
      definitionJson: definitionJson ?? this.definitionJson,
      sync: sync ?? this.sync,
    );
  }
}
