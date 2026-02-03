import 'package:test/test.dart';
import 'package:shared_core/shared_core.dart';

void main() {
  group('PersonaRepository', () {
    test('シングルトンインスタンスが取得できる', () {
      final repo1 = PersonaRepository.instance;
      final repo2 = PersonaRepository.instance;
      expect(identical(repo1, repo2), isTrue);
    });

    test('MVP固定3名が取得できる', () {
      final repo = PersonaRepository.instance;
      final personas = repo.getAll();

      expect(personas.length, equals(3));
      expect(repo.count, equals(3));
    });

    test('getByIdで正しいPersonaが取得できる', () {
      final repo = PersonaRepository.instance;
      final persona = repo.getById('persona_philosopher');

      expect(persona, isNotNull);
      expect(persona!.name, equals('哲学者'));
      expect(persona.category, equals(PersonaCategory.human));
    });

    test('存在しないIDではnullが返る', () {
      final repo = PersonaRepository.instance;
      final persona = repo.getById('non_existent_id');

      expect(persona, isNull);
    });

    test('全Personaがvalidationをパスする', () {
      final repo = PersonaRepository.instance;
      final personas = repo.getAll();

      for (final persona in personas) {
        final result = persona.validate();
        expect(result.isValid, isTrue,
               reason: '${persona.name} のvalidationが失敗: ${result.errorMessage}');
      }
    });
  });
}
