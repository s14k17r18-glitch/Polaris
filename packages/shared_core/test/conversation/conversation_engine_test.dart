import 'package:test/test.dart';
import 'package:shared_core/shared_core.dart';

void main() {
  group('ConversationEngine', () {
    test('nextTurn が Stream<MessageChunk> を返す', () async {
      final engine = ConversationEngine(
        theme: 'テストテーマ',
        personas: PersonaRepository.instance.getAll(),
      );

      final chunks = await engine.nextTurn().toList();
      expect(chunks.isNotEmpty, true);
      expect(chunks.last.isComplete, true);
    });

    test('チャンクが順番に配信される', () async {
      final engine = ConversationEngine(
        theme: 'テストテーマ',
        personas: PersonaRepository.instance.getAll(),
      );

      final chunks = await engine.nextTurn().toList();

      // 最後のチャンク以外は isComplete が false
      for (int i = 0; i < chunks.length - 1; i++) {
        expect(chunks[i].isComplete, false);
      }

      // 最後のチャンクのみ isComplete が true
      expect(chunks.last.isComplete, true);
    });

    test('話者が順番に切り替わる', () async {
      final engine = ConversationEngine(
        theme: 'テストテーマ',
        personas: PersonaRepository.instance.getAll(),
      );

      final personas = PersonaRepository.instance.getAll();

      // 1ターン目: 哲学者
      final turn1 = await engine.nextTurn().toList();
      expect(turn1.first.speakerId, personas[0].id);
      expect(turn1.first.speakerName, personas[0].name);

      // 2ターン目: 芸術家
      final turn2 = await engine.nextTurn().toList();
      expect(turn2.first.speakerId, personas[1].id);
      expect(turn2.first.speakerName, personas[1].name);

      // 3ターン目: 科学者
      final turn3 = await engine.nextTurn().toList();
      expect(turn3.first.speakerId, personas[2].id);
      expect(turn3.first.speakerName, personas[2].name);

      // 4ターン目: 哲学者（ループ）
      final turn4 = await engine.nextTurn().toList();
      expect(turn4.first.speakerId, personas[0].id);
      expect(turn4.first.speakerName, personas[0].name);
    });

    test('ターン番号が正しくインクリメントされる', () async {
      final engine = ConversationEngine(
        theme: 'テストテーマ',
        personas: PersonaRepository.instance.getAll(),
      );

      expect(engine.currentTurnIndex, 0);

      await engine.nextTurn().toList();
      expect(engine.currentTurnIndex, 1);

      await engine.nextTurn().toList();
      expect(engine.currentTurnIndex, 2);

      await engine.nextTurn().toList();
      expect(engine.currentTurnIndex, 3);
    });

    test('reset() でターン番号がリセットされる', () async {
      final engine = ConversationEngine(
        theme: 'テストテーマ',
        personas: PersonaRepository.instance.getAll(),
      );

      await engine.nextTurn().toList();
      await engine.nextTurn().toList();
      expect(engine.currentTurnIndex, 2);

      engine.reset();
      expect(engine.currentTurnIndex, 0);
    });

    test('personas が空の場合はエラーが発生する', () async {
      final engine = ConversationEngine(
        theme: 'テストテーマ',
        personas: [],
      );

      expect(
        () => engine.nextTurn().toList(),
        throwsA(isA<StateError>()),
      );
    });
  });
}
