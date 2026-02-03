// Session エンティティ（M2-E1：保存・同期用）

import 'sync_metadata.dart';

/// Session エンティティ
///
/// 談議セッション全体を保存・同期するためのエンティティ。
/// - session_id: セッションの一意ID
/// - created_at: セッション開始時刻（ISO 8601形式）
/// - theme: 談議テーマ
/// - constraints: 制約条件（任意、JSON形式）
/// - participants: 参加 Persona の配列（persona_id + 席順）
/// - moderator_persona_id: 司会の Persona ID（任意）
/// - rounds_max: 最大ターン数
/// - ended_reason: 終了理由（user_action / rounds_max / error）
/// - sync: 同期メタデータ
class SessionEntity {
  const SessionEntity({
    required this.sessionId,
    required this.createdAt,
    required this.theme,
    this.constraints,
    required this.participants,
    this.moderatorPersonaId,
    required this.roundsMax,
    this.endedReason,
    required this.sync,
  });

  /// セッションの一意ID
  final String sessionId;

  /// セッション開始時刻（ISO 8601形式）
  final String createdAt;

  /// 談議テーマ
  final String theme;

  /// 制約条件（任意、JSON形式）
  final Map<String, dynamic>? constraints;

  /// 参加 Persona の配列（persona_id + 席順）
  /// 例：[{"persona_id": "p1", "seat": 0}, {"persona_id": "p2", "seat": 1}]
  final List<Map<String, dynamic>> participants;

  /// 司会の Persona ID（任意）
  final String? moderatorPersonaId;

  /// 最大ターン数
  final int roundsMax;

  /// 終了理由（user_action / rounds_max / error、未終了ならnull）
  final String? endedReason;

  /// 同期メタデータ
  final SyncMetadata sync;

  /// JSON からデシリアライズ
  factory SessionEntity.fromJson(Map<String, dynamic> json) {
    return SessionEntity(
      sessionId: json['session_id'] as String,
      createdAt: json['created_at'] as String,
      theme: json['theme'] as String,
      constraints: json['constraints'] as Map<String, dynamic>?,
      participants: (json['participants'] as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList(),
      moderatorPersonaId: json['moderator_persona_id'] as String?,
      roundsMax: json['rounds_max'] as int,
      endedReason: json['ended_reason'] as String?,
      sync: SyncMetadata.fromJson(json),
    );
  }

  /// JSON へシリアライズ
  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'created_at': createdAt,
      'theme': theme,
      'constraints': constraints,
      'participants': participants,
      'moderator_persona_id': moderatorPersonaId,
      'rounds_max': roundsMax,
      'ended_reason': endedReason,
      ...sync.toJson(),
    };
  }

  /// コピー（部分更新用）
  SessionEntity copyWith({
    String? sessionId,
    String? createdAt,
    String? theme,
    Map<String, dynamic>? constraints,
    List<Map<String, dynamic>>? participants,
    String? moderatorPersonaId,
    int? roundsMax,
    String? endedReason,
    SyncMetadata? sync,
  }) {
    return SessionEntity(
      sessionId: sessionId ?? this.sessionId,
      createdAt: createdAt ?? this.createdAt,
      theme: theme ?? this.theme,
      constraints: constraints ?? this.constraints,
      participants: participants ?? this.participants,
      moderatorPersonaId: moderatorPersonaId ?? this.moderatorPersonaId,
      roundsMax: roundsMax ?? this.roundsMax,
      endedReason: endedReason ?? this.endedReason,
      sync: sync ?? this.sync,
    );
  }
}
