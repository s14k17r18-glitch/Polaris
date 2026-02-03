import 'package:test/test.dart';
import 'package:shared_core/shared_core.dart';

void main() {
  group('PromptTemplate', () {
    test('buildModeratorPrompt が日本語プロンプトを生成する', () {
      final personas = PersonaRepository.instance.getAll();
      final prompt = PromptTemplate.buildModeratorPrompt(
        theme: '人工知能の未来',
        personas: personas,
      );

      expect(prompt, contains('司会者'));
      expect(prompt, contains('人工知能の未来'));
      expect(prompt, contains('哲学者'));
      expect(prompt, contains('芸術家'));
      expect(prompt, contains('科学者'));
    });

    test('buildPersonaPrompt が Persona 情報を含む', () {
      final philosopher =
          PersonaRepository.instance.getById('persona_philosopher')!;
      final prompt = PromptTemplate.buildPersonaPrompt(
        persona: philosopher,
        theme: '人工知能の未来',
      );

      expect(prompt, contains('哲学者'));
      expect(prompt, contains('論理的・批判的'));
      expect(prompt, contains('人工知能の未来'));
    });

    test('buildModeratorPrompt はカスタムルールを受け入れる', () {
      final personas = PersonaRepository.instance.getAll();
      final customRules = ['カスタムルール1', 'カスタムルール2'];
      final prompt = PromptTemplate.buildModeratorPrompt(
        theme: 'テスト',
        personas: personas,
        rules: customRules,
      );

      expect(prompt, contains('カスタムルール1'));
      expect(prompt, contains('カスタムルール2'));
    });

    test('defaultRules が3つのルールを含む', () {
      expect(PromptTemplate.defaultRules.length, equals(3));
      expect(PromptTemplate.defaultRules[0], contains('誹謗中傷'));
      expect(PromptTemplate.defaultRules[1], contains('独断'));
      expect(PromptTemplate.defaultRules[2], contains('脱線'));
    });
  });
}
