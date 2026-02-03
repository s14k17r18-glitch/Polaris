// Personaリポジトリ（M1-C1）
// MVP固定3名のPersonaデータを提供

import 'persona_definition.dart';

/// Personaリポジトリ
///
/// MVP では固定3名のPersonaを提供。
/// M2以降でローカル保存、M3以降で同期を追加予定。
class PersonaRepository {
  PersonaRepository._();

  /// シングルトンインスタンス
  static final PersonaRepository instance = PersonaRepository._();

  /// MVP固定Persona（3名）
  ///
  /// 多角的な議論を可能にする3つの視点：
  /// - 哲学者: 論理的・批判的視点
  /// - 芸術家: 感性的・直感的視点
  /// - 科学者: 実証的・分析的視点
  static const List<PersonaDefinition> _mvpPersonas = [
    PersonaDefinition(
      id: 'persona_philosopher',
      name: '哲学者',
      category: PersonaCategory.human,
      stance: '論理的・批判的視点から議論を深める',
    ),
    PersonaDefinition(
      id: 'persona_artist',
      name: '芸術家',
      category: PersonaCategory.human,
      stance: '感性的・直感的視点から新たな発想を提示する',
    ),
    PersonaDefinition(
      id: 'persona_scientist',
      name: '科学者',
      category: PersonaCategory.human,
      stance: '実証的・分析的視点から事実を検証する',
    ),
  ];

  /// 全Personaを取得
  ///
  /// MVP では固定3名を返す。
  List<PersonaDefinition> getAll() {
    return List.unmodifiable(_mvpPersonas);
  }

  /// IDでPersonaを取得
  ///
  /// 見つからない場合は null を返す。
  PersonaDefinition? getById(String id) {
    for (final persona in _mvpPersonas) {
      if (persona.id == id) {
        return persona;
      }
    }
    return null;
  }

  /// Personaの数を取得
  int get count => _mvpPersonas.length;
}
