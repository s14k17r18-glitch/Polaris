// スキーマバージョン定義（単一ソース）
// アプリ・バックエンド・同期で参照する唯一の正

/// データスキーマのバージョン情報
///
/// **重要**: このバージョンは Windows / iOS / Backend で共通。
/// OS 別に異なるバージョンを持つことは禁止（00_PARITY_CONTRACT.md 準拠）
class SchemaVersion {
  SchemaVersion._();

  /// 現在のスキーマバージョン
  ///
  /// **変更時の注意**:
  /// - バージョンを上げる場合は必ず対応する Migration を追加すること
  /// - Migration がない状態でバージョンを上げると既存データが読めなくなる
  static const int current = 1;

  /// 最小互換バージョン（このバージョン未満のデータは読めない）
  ///
  /// 例: current が 5 で minCompatible が 3 の場合、
  /// バージョン 3, 4, 5 のデータは読めるが、2 以下は読めない
  static const int minCompatible = 1;

  /// スキーマバージョンの履歴（参考）
  ///
  /// - v1 (2026-02): 初期スキーマ（M0: 枠のみ）
  static const Map<int, String> history = {
    1: '初期スキーマ（M0: 枠のみ、M1以降で実装）',
  };

  /// バージョンが互換性範囲内かチェック
  static bool isCompatible(int version) {
    return version >= minCompatible && version <= current;
  }

  /// バージョン文字列を取得（デバッグ用）
  static String versionString(int version) {
    return 'v$version: ${history[version] ?? '不明なバージョン'}';
  }
}
