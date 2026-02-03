// GuardEvent エンティティ（M2-E1：保存・同期用）

import 'sync_metadata.dart';

/// GuardEvent エンティティ
///
/// ガード判定イベントを保存・同期するためのエンティティ。
/// - event_id: イベントの一意ID
/// - session_id: 所属するセッションID
/// - turn_index: ターン番号
/// - type: ガードタイプ（slander/dogmatism/deviation）
/// - target_speaker_id: 対象話者ID
/// - action: アクション（warn/rewrite/eject）
/// - note: 司会からの指示メッセージ
/// - sync: 同期メタデータ
class GuardEventEntity {
  const GuardEventEntity({
    required this.eventId,
    required this.sessionId,
    required this.turnIndex,
    required this.type,
    required this.targetSpeakerId,
    required this.action,
    required this.note,
    required this.sync,
  });

  /// イベントの一意ID
  final String eventId;

  /// 所属するセッションID
  final String sessionId;

  /// ターン番号
  final int turnIndex;

  /// ガードタイプ（slander/dogmatism/deviation）
  final String type;

  /// 対象話者ID
  final String targetSpeakerId;

  /// アクション（warn/rewrite/eject）
  final String action;

  /// 司会からの指示メッセージ
  final String note;

  /// 同期メタデータ
  final SyncMetadata sync;

  /// JSON からデシリアライズ
  factory GuardEventEntity.fromJson(Map<String, dynamic> json) {
    return GuardEventEntity(
      eventId: json['event_id'] as String,
      sessionId: json['session_id'] as String,
      turnIndex: json['turn_index'] as int,
      type: json['type'] as String,
      targetSpeakerId: json['target_speaker_id'] as String,
      action: json['action'] as String,
      note: json['note'] as String,
      sync: SyncMetadata.fromJson(json),
    );
  }

  /// JSON へシリアライズ
  Map<String, dynamic> toJson() {
    return {
      'event_id': eventId,
      'session_id': sessionId,
      'turn_index': turnIndex,
      'type': type,
      'target_speaker_id': targetSpeakerId,
      'action': action,
      'note': note,
      ...sync.toJson(),
    };
  }

  /// コピー（部分更新用）
  GuardEventEntity copyWith({
    String? eventId,
    String? sessionId,
    int? turnIndex,
    String? type,
    String? targetSpeakerId,
    String? action,
    String? note,
    SyncMetadata? sync,
  }) {
    return GuardEventEntity(
      eventId: eventId ?? this.eventId,
      sessionId: sessionId ?? this.sessionId,
      turnIndex: turnIndex ?? this.turnIndex,
      type: type ?? this.type,
      targetSpeakerId: targetSpeakerId ?? this.targetSpeakerId,
      action: action ?? this.action,
      note: note ?? this.note,
      sync: sync ?? this.sync,
    );
  }
}
