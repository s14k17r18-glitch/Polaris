import 'package:test/test.dart';
import 'package:shared_core/shared_core.dart';

void main() {
  group('Guard', () {
    group('誹謗中傷チェック', () {
      test('誹謗中傷キーワードが含まれる場合は eject', () {
        final result = Guard.evaluate(
          text: 'あなたはバカだ',
          theme: 'テストテーマ',
          turnIndex: 0,
        );

        expect(result.isTriggered, true);
        expect(result.action, GuardAction.eject);
        expect(result.note, contains('誹謗中傷'));
        expect(result.matchedRule, contains('バカ'));
      });

      test('誹謗中傷キーワードがない場合は pass', () {
        final result = Guard.evaluate(
          text: '私はこのテーマについて考えます',
          theme: 'テストテーマ',
          turnIndex: 0,
        );

        expect(result.isTriggered, false);
      });
    });

    group('強断定チェック', () {
      test('「すべき」が含まれる場合は warn', () {
        final result = Guard.evaluate(
          text: 'これはテストテーマについてすべきことです',
          theme: 'テストテーマ',
          turnIndex: 0,
        );

        expect(result.isTriggered, true);
        expect(result.action, GuardAction.warn);
        expect(result.note, contains('断定的な表現'));
        expect(result.matchedRule, contains('すべき'));
      });

      test('「絶対に」が含まれる場合は warn', () {
        final result = Guard.evaluate(
          text: 'テストテーマは絶対に正しい',
          theme: 'テストテーマ',
          turnIndex: 0,
        );

        expect(result.isTriggered, true);
        expect(result.action, GuardAction.warn);
        expect(result.note, contains('断定的な表現'));
        expect(result.matchedRule, contains('絶対に'));
      });

      test('強断定表現がない場合は pass', () {
        final result = Guard.evaluate(
          text: 'テストテーマについて考えると、興味深いと思います',
          theme: 'テストテーマ',
          turnIndex: 0,
        );

        expect(result.isTriggered, false);
      });
    });

    group('脱線チェック', () {
      test('テーマ語彙が含まれない場合は warn（2ターン目以降）', () {
        final result = Guard.evaluate(
          text: '全く関係ない話題について語ります',
          theme: 'AIの倫理',
          turnIndex: 2,
        );

        expect(result.isTriggered, true);
        expect(result.action, GuardAction.warn);
        expect(result.note, contains('テーマから離れている'));
        expect(result.matchedRule, contains('脱線禁止'));
      });

      test('テーマ語彙が含まれる場合は pass', () {
        final result = Guard.evaluate(
          text: 'AIの発展について考えると、倫理的な課題があります',
          theme: 'AIの倫理',
          turnIndex: 2,
        );

        expect(result.isTriggered, false);
      });

      test('1ターン目は脱線チェックしない', () {
        final result = Guard.evaluate(
          text: '全く関係ない話題について語ります',
          theme: 'AIの倫理',
          turnIndex: 0,
        );

        expect(result.isTriggered, false);
      });
    });

    group('優先順位', () {
      test('誹謗中傷が最優先（eject）', () {
        // 誹謗中傷 + 強断定 の両方を含む場合、誹謗中傷が優先
        final result = Guard.evaluate(
          text: 'バカなことをすべきではない',
          theme: 'テストテーマ',
          turnIndex: 0,
        );

        expect(result.isTriggered, true);
        expect(result.action, GuardAction.eject);
        expect(result.matchedRule, contains('誹謗中傷'));
      });
    });
  });
}
