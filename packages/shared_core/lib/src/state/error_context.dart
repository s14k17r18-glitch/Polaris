// エラーコンテキスト（M1-B3：最小実装）

/// エラーコンテキスト（M1-B3：最小実装）
///
/// エラー発生時の情報を保持。
/// M2 以降で詳細情報（スタックトレース等）を追加可能。
class ErrorContext {
  const ErrorContext({
    required this.message,
    this.details,
  });

  /// エラーメッセージ（日本語、ユーザー可視）
  final String message;

  /// 詳細情報（オプション、デバッグ用）
  final String? details;
}
