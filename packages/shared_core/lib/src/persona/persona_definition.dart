// Persona定義（M1-C1）
// 談議に参加するPersonaの最小データ構造

/// Personaカテゴリ（03_PERSONAS_SCHEMA.md 準拠）
///
/// カテゴリにより neuro_plasticity（信念の変化率）が異なる：
/// - human: 1.0x（標準）
/// - character: 1.0x（標準）
/// - nature: 0.0x（不変）
enum PersonaCategory {
  /// 人間（歴史上の人物、専門家など）
  human,

  /// キャラクター（アニメ、フィクションなど）
  character,

  /// 自然（木、石、概念など）- 信念は不変
  nature,
}

/// バリデーション結果
class ValidationResult {
  /// 成功
  const ValidationResult.success()
      : isValid = true,
        errorMessage = null;

  /// 失敗
  const ValidationResult.failure(String message)
      : isValid = false,
        errorMessage = message;

  final bool isValid;
  final String? errorMessage;
}

/// Persona定義（MVP最小構造）
///
/// **契約**: Windows/iOS で同一構造（00_PARITY_CONTRACT.md）
///
/// MVP では以下のフィールドのみ使用：
/// - id: 一意識別子
/// - name: 表示名（日本語）
/// - category: カテゴリ
/// - stance: 立場/役割（議論での視点）
class PersonaDefinition {
  const PersonaDefinition({
    required this.id,
    required this.name,
    required this.category,
    required this.stance,
  });

  /// 一意識別子
  final String id;

  /// 表示名（日本語）
  final String name;

  /// カテゴリ
  final PersonaCategory category;

  /// 立場/役割（議論での視点）
  final String stance;

  /// バリデーション
  ///
  /// - id が空ならエラー
  /// - name が空ならエラー
  ValidationResult validate() {
    if (id.isEmpty) {
      return const ValidationResult.failure('IDが空です');
    }
    if (name.isEmpty) {
      return const ValidationResult.failure('名前が空です');
    }
    return const ValidationResult.success();
  }

  @override
  String toString() => 'Persona($id: $name)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PersonaDefinition &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
