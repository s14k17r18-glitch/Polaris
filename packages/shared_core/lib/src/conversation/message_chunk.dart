// メッセージチャンク（ストリーミング配信用）

/// メッセージチャンク（ストリーミング配信用）
///
/// ターン生成時に `Stream<MessageChunk>` で配信される。
/// M1-D2 では疑似ストリーミング（チャンク分割＋delay）で使用。
class MessageChunk {
  const MessageChunk({
    required this.speakerId,
    required this.speakerName,
    required this.textFragment,
    required this.isComplete,
  });

  /// 話者ID（persona_philosopher など）
  final String speakerId;

  /// 話者名（「哲学者」など、UI表示用）
  final String speakerName;

  /// テキスト断片（チャンク）
  final String textFragment;

  /// ストリーム完了フラグ（最後のチャンクのみ true）
  final bool isComplete;
}
