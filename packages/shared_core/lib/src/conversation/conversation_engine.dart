// 談議エンジン（M1-D2：スタブ実装、M1-D3：ガード追加）

import 'dart:async';
import '../persona/persona_definition.dart';
import 'message_chunk.dart';
import 'prompt_template.dart';
import 'guard.dart';

/// 談議エンジン（M1-D2：スタブ実装）
///
/// ターン生成をストリーミング配信する。
/// MVP では LLM 実接続なし（疑似応答で縦スライス成立）。
/// M2 以降で実 LLM 接続に置き換え。
class ConversationEngine {
  ConversationEngine({
    required this.theme,
    required this.personas,
  });

  final String theme;
  final List<PersonaDefinition> personas;

  int _currentTurnIndex = 0;
  int _currentSpeakerIndex = 0;

  /// 次のターンを生成（ストリーミング配信）
  ///
  /// 返り値: `Stream<MessageChunk>`
  /// - 疑似 LLM 応答をチャンク分割して配信
  /// - delay でストリーミング感を演出
  /// - M1-D3: ガード判定を追加（moderator 介入）
  Stream<MessageChunk> nextTurn() async* {
    if (personas.isEmpty) {
      throw StateError('Persona リストが空です');
    }

    // 話者を順番に選択（哲学者→芸術家→科学者→哲学者...）
    final speaker = personas[_currentSpeakerIndex % personas.length];

    // スタブ応答を生成
    final response = _generateStubResponse(speaker, _currentTurnIndex);

    // M1-D3: ガード判定
    final guardResult = Guard.evaluate(
      text: response,
      theme: theme,
      turnIndex: _currentTurnIndex,
    );

    // ガードが発動した場合、moderator が介入
    if (guardResult.isTriggered) {
      // moderator の介入メッセージを配信
      final moderatorMessage = '【司会より】${guardResult.note}';
      final moderatorChunks = _splitIntoChunks(moderatorMessage, chunkSize: 5);

      for (int i = 0; i < moderatorChunks.length; i++) {
        await Future.delayed(const Duration(milliseconds: 50));

        yield MessageChunk(
          speakerId: 'moderator',
          speakerName: '司会',
          textFragment: moderatorChunks[i],
          isComplete: i == moderatorChunks.length - 1,
        );
      }

      // eject の場合はセッション終了
      if (guardResult.action == GuardAction.eject) {
        throw StateError(
            '談議ルール違反により、セッションを終了します。（理由: ${guardResult.matchedRule}）');
      }

      // warn/rewrite の場合は警告のみ（元の発言は配信しない）
      // ターンカウンタ更新
      _currentTurnIndex++;
      _currentSpeakerIndex++;
      return;
    }

    // チャンク分割（5文字ごと）
    final chunks = _splitIntoChunks(response, chunkSize: 5);

    // ストリーミング配信（50ms ごとにチャンク送信）
    for (int i = 0; i < chunks.length; i++) {
      await Future.delayed(const Duration(milliseconds: 50));

      yield MessageChunk(
        speakerId: speaker.id,
        speakerName: speaker.name,
        textFragment: chunks[i],
        isComplete: i == chunks.length - 1,
      );
    }

    // ターンカウンタ更新
    _currentTurnIndex++;
    _currentSpeakerIndex++;
  }

  /// スタブ応答生成（疑似 LLM）
  ///
  /// MVP では固定パターンで応答を生成。
  /// M2 以降で実 LLM 接続に置き換え。
  String _generateStubResponse(PersonaDefinition speaker, int turnIndex) {
    // プロンプトは生成するが、スタブでは使わない（構造確認のみ）
    final _ = PromptTemplate.buildPersonaPrompt(
      persona: speaker,
      theme: theme,
    );

    // 固定パターンで応答（M1-D3: テーマ語彙を含めてガード回避）
    final responses = [
      '${speaker.stance}から考えると、「$theme」は興味深い話題です。',
      '私は${speaker.name}として、「$theme」について異なる角度から意見を述べます。',
      '「$theme」については、さらに深く議論する価値がありますね。',
    ];

    return responses[turnIndex % responses.length];
  }

  /// テキストをチャンク分割
  List<String> _splitIntoChunks(String text, {required int chunkSize}) {
    final chunks = <String>[];
    for (int i = 0; i < text.length; i += chunkSize) {
      final end = (i + chunkSize < text.length) ? i + chunkSize : text.length;
      chunks.add(text.substring(i, end));
    }
    return chunks;
  }

  /// 現在のターン番号
  int get currentTurnIndex => _currentTurnIndex;

  /// リセット（テスト用）
  void reset() {
    _currentTurnIndex = 0;
    _currentSpeakerIndex = 0;
  }
}
