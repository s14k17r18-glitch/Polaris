// Migration 0 → 1 (初期スキーマへの移行)
// M0: 枠のみ、実データは M1 以降で扱う

import '../migration.dart';

/// Migration 0 → 1: 初期スキーマへの移行
///
/// **M0 の実装**:
/// - データ構造の定義はまだない（M1 以降で追加）
/// - この Migration は schema_version を 0 → 1 に更新するだけ
///
/// **M1 以降で追加する項目（予定）**:
/// - Session データ構造の初期化
/// - Persona データ構造の初期化
/// - Message データ構造の初期化
/// - Crystal データ構造の初期化
class Migration0To1 implements Migration {
  const Migration0To1();

  @override
  int get fromVersion => 0;

  @override
  int get toVersion => 1;

  @override
  String get description => '初期スキーマへの移行（M0: 枠のみ）';

  @override
  Map<String, dynamic> migrate(Map<String, dynamic> data) {
    // M0: 何もせず schema_version だけ更新
    // M1 以降でデータ構造の初期化を追加する
    final migrated = Map<String, dynamic>.from(data);

    // 将来の拡張ポイント（M1 以降）:
    // if (!migrated.containsKey('sessions')) {
    //   migrated['sessions'] = [];
    // }
    // if (!migrated.containsKey('personas')) {
    //   migrated['personas'] = [];
    // }

    return migrated;
  }
}
