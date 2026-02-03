// Persona エンティティ（M2-E1：保存・同期用）

import 'sync_metadata.dart';

/// Persona エンティティ
///
/// Persona 定義を保存・同期するためのエンティティ。
/// - persona_id: Persona の一意ID
/// - version: Persona 定義の版
/// - definition_json: PersonaDefinition のJSON表現
/// - sync: 同期メタデータ
class PersonaEntity {
  const PersonaEntity({
    required this.personaId,
    required this.version,
    required this.definitionJson,
    required this.sync,
  });

  /// Persona の一意ID
  final String personaId;

  /// Persona 定義の版
  final int version;

  /// PersonaDefinition のJSON表現
  final Map<String, dynamic> definitionJson;

  /// 同期メタデータ
  final SyncMetadata sync;

  /// JSON からデシリアライズ
  factory PersonaEntity.fromJson(Map<String, dynamic> json) {
    return PersonaEntity(
      personaId: json['persona_id'] as String,
      version: json['version'] as int,
      definitionJson: json['definition_json'] as Map<String, dynamic>,
      sync: SyncMetadata.fromJson(json),
    );
  }

  /// JSON へシリアライズ
  Map<String, dynamic> toJson() {
    return {
      'persona_id': personaId,
      'version': version,
      'definition_json': definitionJson,
      ...sync.toJson(),
    };
  }

  /// コピー（部分更新用）
  PersonaEntity copyWith({
    String? personaId,
    int? version,
    Map<String, dynamic>? definitionJson,
    SyncMetadata? sync,
  }) {
    return PersonaEntity(
      personaId: personaId ?? this.personaId,
      version: version ?? this.version,
      definitionJson: definitionJson ?? this.definitionJson,
      sync: sync ?? this.sync,
    );
  }
}
