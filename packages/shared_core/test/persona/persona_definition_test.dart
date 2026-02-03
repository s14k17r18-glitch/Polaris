import 'package:test/test.dart';
import 'package:shared_core/shared_core.dart';

void main() {
  group('PersonaDefinition', () {
    test('正常なPersonaはvalidateが成功する', () {
      final persona = PersonaDefinition(
        id: 'test_id',
        name: 'テスト',
        category: PersonaCategory.human,
        stance: 'テスト立場',
      );

      final result = persona.validate();
      expect(result.isValid, isTrue);
      expect(result.errorMessage, isNull);
    });

    test('IDが空の場合はvalidateが失敗する', () {
      final persona = PersonaDefinition(
        id: '',
        name: 'テスト',
        category: PersonaCategory.human,
        stance: 'テスト立場',
      );

      final result = persona.validate();
      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('ID'));
    });

    test('名前が空の場合はvalidateが失敗する', () {
      final persona = PersonaDefinition(
        id: 'test_id',
        name: '',
        category: PersonaCategory.human,
        stance: 'テスト立場',
      );

      final result = persona.validate();
      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('名前'));
    });

    test('同じIDのPersonaは等価である', () {
      final persona1 = PersonaDefinition(
        id: 'same_id',
        name: 'テスト1',
        category: PersonaCategory.human,
        stance: '立場1',
      );
      final persona2 = PersonaDefinition(
        id: 'same_id',
        name: 'テスト2',
        category: PersonaCategory.character,
        stance: '立場2',
      );

      expect(persona1, equals(persona2));
      expect(persona1.hashCode, equals(persona2.hashCode));
    });
  });
}
