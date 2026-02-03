import 'package:test/test.dart';
import 'package:shared_core/shared_core.dart';

void main() {
  group('SummaryCrystal', () {
    group('generateSummary', () {
      test('メッセージがある場合、要約を生成する', () {
        final summary = SummaryCrystal.generateSummary(
          theme: 'テストテーマ',
          messages: [
            '哲学者：最初の発言',
            '芸術家：中間の発言',
            '科学者：最後の発言',
          ],
          turnCount: 3,
        );

        expect(summary, contains('テストテーマ'));
        expect(summary, contains('3 ターン'));
        expect(summary, contains('哲学者：最初の発言'));
        expect(summary, contains('科学者：最後の発言'));
      });

      test('メッセージが空の場合、デフォルトの要約を返す', () {
        final summary = SummaryCrystal.generateSummary(
          theme: 'テストテーマ',
          messages: [],
          turnCount: 0,
        );

        expect(summary, contains('テストテーマ'));
        expect(summary, contains('談議が行われました'));
      });
    });

    group('generateCrystalDraft', () {
      test('CrystalDraft を生成する', () {
        final participants = PersonaRepository.instance.getAll();
        final messages = [
          '哲学者：最初の発言',
          '芸術家：中間の発言',
          '科学者：最後の発言',
        ];

        final draft = SummaryCrystal.generateCrystalDraft(
          theme: 'AIの倫理',
          messages: messages,
          participants: participants,
          turnCount: 3,
        );

        // タイトル生成確認
        expect(draft.title, contains('AIの倫理'));
        expect(draft.title, isNotEmpty);

        // テーマ確認
        expect(draft.theme, 'AIの倫理');

        // 参加者確認
        expect(draft.participants.length, 3);
        expect(draft.participants, participants);

        // 要約確認
        expect(draft.summary, contains('AIの倫理'));
        expect(draft.summary, contains('3 ターン'));

        // 生成日時確認
        expect(draft.createdAt, isA<DateTime>());
        expect(
          draft.createdAt.difference(DateTime.now()).inSeconds.abs(),
          lessThan(2),
        );
      });

      test('タイトルが自動生成される', () {
        final participants = PersonaRepository.instance.getAll();

        final draft = SummaryCrystal.generateCrystalDraft(
          theme: 'とても長いテーマ名を設定してタイトル生成のテストをします',
          messages: [],
          participants: participants,
          turnCount: 0,
        );

        // タイトルが適切に省略される（10文字 + ...）
        expect(draft.title.length, lessThan(50));
        expect(draft.title, contains('...'));
      });
    });
  });
}
