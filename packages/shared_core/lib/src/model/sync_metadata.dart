// 同期メタデータ（M2-E1）
// すべての同期対象エンティティに必須のフィールド

/// 同期メタデータ
///
/// すべての同期対象エンティティが持つ必須フィールド。
/// - schema_version: データスキーマの版
/// - owner_user_id: 所有者（アカウント）
/// - updated_at: 更新時刻（ISO 8601形式）
/// - rev: 更新リビジョン（競合解決用）
/// - deleted_at: 削除時刻（tombstone、未削除ならnull）
/// - device_id: 更新した端末（任意）
class SyncMetadata {
  const SyncMetadata({
    required this.schemaVersion,
    required this.ownerUserId,
    required this.updatedAt,
    required this.rev,
    this.deletedAt,
    this.deviceId,
  });

  /// データスキーマの版（例：1）
  final int schemaVersion;

  /// 所有者（アカウントID）
  final String ownerUserId;

  /// 更新時刻（ISO 8601形式）
  final String updatedAt;

  /// 更新リビジョン（整数 or UUID、競合解決用）
  final String rev;

  /// 削除時刻（tombstone、未削除ならnull）
  final String? deletedAt;

  /// 更新した端末（任意だが推奨）
  final String? deviceId;

  /// JSON からデシリアライズ
  factory SyncMetadata.fromJson(Map<String, dynamic> json) {
    return SyncMetadata(
      schemaVersion: json['schema_version'] as int,
      ownerUserId: json['owner_user_id'] as String,
      updatedAt: json['updated_at'] as String,
      rev: json['rev'] as String,
      deletedAt: json['deleted_at'] as String?,
      deviceId: json['device_id'] as String?,
    );
  }

  /// JSON へシリアライズ
  Map<String, dynamic> toJson() {
    return {
      'schema_version': schemaVersion,
      'owner_user_id': ownerUserId,
      'updated_at': updatedAt,
      'rev': rev,
      'deleted_at': deletedAt,
      'device_id': deviceId,
    };
  }

  /// 削除済みかどうか
  bool get isDeleted => deletedAt != null;

  /// コピー（部分更新用）
  SyncMetadata copyWith({
    int? schemaVersion,
    String? ownerUserId,
    String? updatedAt,
    String? rev,
    String? deletedAt,
    String? deviceId,
  }) {
    return SyncMetadata(
      schemaVersion: schemaVersion ?? this.schemaVersion,
      ownerUserId: ownerUserId ?? this.ownerUserId,
      updatedAt: updatedAt ?? this.updatedAt,
      rev: rev ?? this.rev,
      deletedAt: deletedAt ?? this.deletedAt,
      deviceId: deviceId ?? this.deviceId,
    );
  }
}
