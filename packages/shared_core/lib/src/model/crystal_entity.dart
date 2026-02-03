// Crystal エンティティ（M2-E1：保存・同期用）

import 'sync_metadata.dart';

/// Crystal エンティティ
///
/// 談議の成果物（Crystal）を保存・同期するためのエンティティ。
/// - crystal_id: Crystal の一意ID
/// - session_id: 所属するセッションID
/// - summary_text: 要約テキスト
/// - heat_score: 熱量スコア（0.0-1.0）
/// - color: 色（red/blue/green/yellow/purple/orange など）
/// - created_at: Crystal 生成時刻（ISO 8601形式）
/// - sync: 同期メタデータ
class CrystalEntity {
  const CrystalEntity({
    required this.crystalId,
    required this.sessionId,
    required this.summaryText,
    required this.heatScore,
    required this.color,
    required this.createdAt,
    required this.sync,
  });

  /// Crystal の一意ID
  final String crystalId;

  /// 所属するセッションID
  final String sessionId;

  /// 要約テキスト
  final String summaryText;

  /// 熱量スコア（0.0-1.0）
  final double heatScore;

  /// 色（red/blue/green/yellow/purple/orange など）
  final String color;

  /// Crystal 生成時刻（ISO 8601形式）
  final String createdAt;

  /// 同期メタデータ
  final SyncMetadata sync;

  /// JSON からデシリアライズ
  factory CrystalEntity.fromJson(Map<String, dynamic> json) {
    return CrystalEntity(
      crystalId: json['crystal_id'] as String,
      sessionId: json['session_id'] as String,
      summaryText: json['summary_text'] as String,
      heatScore: (json['heat_score'] as num).toDouble(),
      color: json['color'] as String,
      createdAt: json['created_at'] as String,
      sync: SyncMetadata.fromJson(json),
    );
  }

  /// JSON へシリアライズ
  Map<String, dynamic> toJson() {
    return {
      'crystal_id': crystalId,
      'session_id': sessionId,
      'summary_text': summaryText,
      'heat_score': heatScore,
      'color': color,
      'created_at': createdAt,
      ...sync.toJson(),
    };
  }

  /// コピー（部分更新用）
  CrystalEntity copyWith({
    String? crystalId,
    String? sessionId,
    String? summaryText,
    double? heatScore,
    String? color,
    String? createdAt,
    SyncMetadata? sync,
  }) {
    return CrystalEntity(
      crystalId: crystalId ?? this.crystalId,
      sessionId: sessionId ?? this.sessionId,
      summaryText: summaryText ?? this.summaryText,
      heatScore: heatScore ?? this.heatScore,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      sync: sync ?? this.sync,
    );
  }
}
