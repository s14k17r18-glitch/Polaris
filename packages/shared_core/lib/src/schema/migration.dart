// マイグレーションインターフェース＋ランナー
// データスキーマの破壊的変更を安全に適用するための枠

import 'version.dart';

/// マイグレーション結果
class MigrationResult {
  const MigrationResult({
    required this.success,
    required this.fromVersion,
    required this.toVersion,
    this.errorMessage,
  });

  final bool success;
  final int fromVersion;
  final int toVersion;
  final String? errorMessage;

  @override
  String toString() {
    if (success) {
      return 'Migration成功: v$fromVersion → v$toVersion';
    } else {
      return 'Migration失敗: v$fromVersion → v$toVersion (理由: $errorMessage)';
    }
  }
}

/// マイグレーションインターフェース
///
/// データスキーマのバージョン間の移行を定義する。
/// 各 Migration は必ず1つのバージョン間の移行のみを担当する。
abstract class Migration {
  /// 移行元のバージョン
  int get fromVersion;

  /// 移行先のバージョン
  int get toVersion;

  /// マイグレーション説明（デバッグ用）
  String get description;

  /// マイグレーション実行
  ///
  /// [data]: 移行対象のデータ（`Map<String, dynamic>`）
  /// 返り値: 移行後のデータ（`Map<String, dynamic>`）
  ///
  /// **注意**:
  /// - データの破壊は禁止。必ず新しい Map を返すこと。
  /// - 移行に失敗した場合は例外を throw すること。
  Map<String, dynamic> migrate(Map<String, dynamic> data);
}

/// マイグレーションランナー
///
/// 複数の Migration を順次実行して、任意のバージョンから現在のバージョンへ移行する。
class MigrationRunner {
  MigrationRunner({required this.migrations});

  /// 登録されている Migration のリスト
  final List<Migration> migrations;

  /// データを現在のスキーマバージョンまで移行する
  ///
  /// [data]: 移行対象のデータ（'schema_version' フィールドを持つこと）
  /// 返り値: 移行結果
  ///
  /// **処理の流れ**:
  /// 1. data から現在のバージョンを取得
  /// 2. SchemaVersion.current まで順次 Migration を適用
  /// 3. 移行後のデータに 'schema_version' を更新
  MigrationResult run(Map<String, dynamic> data) {
    // 現在のデータバージョンを取得
    final currentVersion = data['schema_version'] as int? ?? 0;

    // 既に最新バージョンの場合は何もしない
    if (currentVersion == SchemaVersion.current) {
      return MigrationResult(
        success: true,
        fromVersion: currentVersion,
        toVersion: SchemaVersion.current,
      );
    }

    // 互換性チェック
    if (!SchemaVersion.isCompatible(currentVersion)) {
      return MigrationResult(
        success: false,
        fromVersion: currentVersion,
        toVersion: SchemaVersion.current,
        errorMessage:
            'バージョン $currentVersion は互換性範囲外です（最小: ${SchemaVersion.minCompatible}）',
      );
    }

    // 必要な Migration を収集
    var version = currentVersion;
    var migratedData = Map<String, dynamic>.from(data);

    try {
      while (version < SchemaVersion.current) {
        // 次のバージョンへの Migration を探す
        final migration = migrations.firstWhere(
          (m) => m.fromVersion == version && m.toVersion == version + 1,
          orElse: () => throw Exception(
            'Migration が見つかりません: v$version → v${version + 1}',
          ),
        );

        // Migration 実行
        migratedData = migration.migrate(migratedData);
        version = migration.toVersion;

        // バージョンを更新
        migratedData['schema_version'] = version;
      }

      return MigrationResult(
        success: true,
        fromVersion: currentVersion,
        toVersion: version,
      );
    } catch (e) {
      return MigrationResult(
        success: false,
        fromVersion: currentVersion,
        toVersion: version,
        errorMessage: e.toString(),
      );
    }
  }

  /// 利用可能な Migration のパスを取得（デバッグ用）
  List<String> getAvailablePaths() {
    return migrations
        .map((m) => 'v${m.fromVersion} → v${m.toVersion}: ${m.description}')
        .toList();
  }
}
