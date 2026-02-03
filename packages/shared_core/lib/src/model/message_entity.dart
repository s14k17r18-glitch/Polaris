// Message エンティティ（M2-E1：保存・同期用）

import 'sync_metadata.dart';

/// Message エンティティ
///
/// 談議セッション内の1メッセージを保存・同期するためのエンティティ。
/// - message_id: メッセージの一意ID
/// - session_id: 所属するセッションID
/// - turn_index: ターン番号
/// - speaker_type: 話者タイプ（persona/user/moderator/system）
/// - speaker_id: 話者ID
/// - text: メッセージ本文
/// - created_at: メッセージ作成時刻（ISO 8601形式）
/// - tags: タグ（任意、配列）
/// - guard_flags: ガード判定フラグ（任意、JSON形式）
/// - sync: 同期メタデータ
class MessageEntity {
  const MessageEntity({
    required this.messageId,
    required this.sessionId,
    required this.turnIndex,
    required this.speakerType,
    required this.speakerId,
    required this.text,
    required this.createdAt,
    this.tags,
    this.guardFlags,
    required this.sync,
  });

  /// メッセージの一意ID
  final String messageId;

  /// 所属するセッションID
  final String sessionId;

  /// ターン番号
  final int turnIndex;

  /// 話者タイプ（persona/user/moderator/system）
  final String speakerType;

  /// 話者ID
  final String speakerId;

  /// メッセージ本文
  final String text;

  /// メッセージ作成時刻（ISO 8601形式）
  final String createdAt;

  /// タグ（任意、配列）
  final List<String>? tags;

  /// ガード判定フラグ（任意、JSON形式）
  final Map<String, dynamic>? guardFlags;

  /// 同期メタデータ
  final SyncMetadata sync;

  /// JSON からデシリアライズ
  factory MessageEntity.fromJson(Map<String, dynamic> json) {
    return MessageEntity(
      messageId: json['message_id'] as String,
      sessionId: json['session_id'] as String,
      turnIndex: json['turn_index'] as int,
      speakerType: json['speaker_type'] as String,
      speakerId: json['speaker_id'] as String,
      text: json['text'] as String,
      createdAt: json['created_at'] as String,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>(),
      guardFlags: json['guard_flags'] as Map<String, dynamic>?,
      sync: SyncMetadata.fromJson(json),
    );
  }

  /// JSON へシリアライズ
  Map<String, dynamic> toJson() {
    return {
      'message_id': messageId,
      'session_id': sessionId,
      'turn_index': turnIndex,
      'speaker_type': speakerType,
      'speaker_id': speakerId,
      'text': text,
      'created_at': createdAt,
      'tags': tags,
      'guard_flags': guardFlags,
      ...sync.toJson(),
    };
  }

  /// コピー（部分更新用）
  MessageEntity copyWith({
    String? messageId,
    String? sessionId,
    int? turnIndex,
    String? speakerType,
    String? speakerId,
    String? text,
    String? createdAt,
    List<String>? tags,
    Map<String, dynamic>? guardFlags,
    SyncMetadata? sync,
  }) {
    return MessageEntity(
      messageId: messageId ?? this.messageId,
      sessionId: sessionId ?? this.sessionId,
      turnIndex: turnIndex ?? this.turnIndex,
      speakerType: speakerType ?? this.speakerType,
      speakerId: speakerId ?? this.speakerId,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      tags: tags ?? this.tags,
      guardFlags: guardFlags ?? this.guardFlags,
      sync: sync ?? this.sync,
    );
  }
}
