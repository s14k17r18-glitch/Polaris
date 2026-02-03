import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ui_tokens/ui_tokens.dart';
import 'package:l10n_ja/l10n_ja.dart';
import 'package:shared_core/shared_core.dart';

void main() {
  runApp(const DangiApp());
}

/// 北極星アプリ（Windows + iOS）
///
/// SessionMachine を単一ソースとして画面を切り替える。
/// ロジックは shared_core に集約（00_PARITY_CONTRACT.md 準拠）。
class DangiApp extends StatelessWidget {
  const DangiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: L10nJa.appTitle,
      theme: ThemeData(
        scaffoldBackgroundColor: UITokens.colorBase,
        useMaterial3: true,
      ),
      home: const SessionScreen(),
    );
  }
}

/// セッション画面（状態駆動）
///
/// SessionMachine の状態に応じて画面を切り替える。
/// UI 層は状態を観察するだけ（ロジックは shared_core）。
class SessionScreen extends StatefulWidget {
  const SessionScreen({super.key});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen> {
  final SessionMachine _machine = SessionMachine();

  // M1-D2: 会話エンジン（discussion 状態で初期化）
  ConversationEngine? _conversationEngine;

  // M1-D2: ストリーム購読用
  StreamSubscription<MessageChunk>? _streamSubscription;

  // M1-D2: 表示中のメッセージ（蓄積）
  final List<String> _messages = [];
  String _currentMessage = '';
  bool _isStreaming = false;

  // M1-D4: Crystal Draft（結晶化画面で表示）
  CrystalDraft? _crystalDraft;

  @override
  void initState() {
    super.initState();
    // BOOT → IDLE への自動遷移（アプリ起動完了）
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _transition(SessionEvent.appStarted);
    });
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  /// イベントを発火して状態遷移
  void _transition(SessionEvent event) {
    if (_machine.canTransition(event)) {
      setState(() {
        _machine.transition(event);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _buildContent(),
      ),
    );
  }

  /// 状態に応じた画面を構築
  Widget _buildContent() {
    switch (_machine.current) {
      case SessionState.boot:
        return _buildBootScreen();
      case SessionState.idle:
        return _buildIdleScreen();
      case SessionState.themeInput:
        return _buildThemeInputScreen();
      case SessionState.personaSelect:
        return _buildNotImplementedScreen(L10nJa.statePersonaSelect);
      case SessionState.ignition:
        // ignition → discussion の自動遷移（M1-D2）
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _transition(SessionEvent.sessionStarted);
        });
        return _buildNotImplementedScreen(L10nJa.stateIgnition);
      case SessionState.discussion:
        return _buildDiscussionScreen();
      case SessionState.convergence:
        return _buildConvergenceScreen();
      case SessionState.error:
        return _buildErrorScreen();
      default:
        return _buildNotImplementedScreen(_machine.current.displayName);
    }
  }

  /// 起動中画面
  Widget _buildBootScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            L10nJa.appTitle,
            style: TextStyle(
              fontSize: 32,
              color: UITokens.colorAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: UITokens.spacingLg),
          Text(
            L10nJa.stateBooting,
            style: TextStyle(
              fontSize: 16,
              color: UITokens.colorAccent.withAlpha(204),
            ),
          ),
        ],
      ),
    );
  }

  /// 待機中画面（セッション開始ボタン）
  Widget _buildIdleScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            L10nJa.appTitle,
            style: TextStyle(
              fontSize: 32,
              color: UITokens.colorAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: UITokens.spacingMd),
          Text(
            L10nJa.stateIdle,
            style: TextStyle(
              fontSize: 20,
              color: UITokens.colorAccent,
            ),
          ),
          const SizedBox(height: UITokens.spacingLg),
          Text(
            L10nJa.descIdle,
            style: TextStyle(
              fontSize: 14,
              color: UITokens.colorAccent.withAlpha(153),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: UITokens.spacingXl),
          _buildActionButton(
            label: L10nJa.buttonStart,
            onPressed: () => _transition(SessionEvent.themeSubmitted),
          ),
        ],
      ),
    );
  }

  /// テーマ入力画面
  Widget _buildThemeInputScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(UITokens.spacingLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              L10nJa.stateThemeInput,
              style: TextStyle(
                fontSize: 24,
                color: UITokens.colorAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: UITokens.spacingMd),
            Text(
              L10nJa.descThemeInput,
              style: TextStyle(
                fontSize: 14,
                color: UITokens.colorAccent.withAlpha(153),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: UITokens.spacingXl),
            _buildActionButton(
              label: L10nJa.buttonNext,
              onPressed: () => _transition(SessionEvent.themeSubmitted),
            ),
          ],
        ),
      ),
    );
  }

  /// 未実装画面（M1 以降で実装予定）
  Widget _buildNotImplementedScreen(String stateName) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            stateName,
            style: TextStyle(
              fontSize: 24,
              color: UITokens.colorAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: UITokens.spacingMd),
          Text(
            L10nJa.descNotImplemented,
            style: TextStyle(
              fontSize: 14,
              color: UITokens.colorAccent.withAlpha(153),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// アクションボタン（共通スタイル）
  Widget _buildActionButton({
    required String label,
    required VoidCallback? onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: UITokens.colorAccent,
        foregroundColor: UITokens.colorBase,
        padding: const EdgeInsets.symmetric(
          horizontal: UITokens.spacingXl,
          vertical: UITokens.spacingMd,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UITokens.radiusMd),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// 議論中画面（M1-D2）
  Widget _buildDiscussionScreen() {
    return Padding(
      padding: const EdgeInsets.all(UITokens.spacingLg),
      child: Column(
        children: [
          // ヘッダー
          Text(
            L10nJa.stateDiscussion,
            style: TextStyle(
              fontSize: 24,
              color: UITokens.colorAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: UITokens.spacingMd),

          // メッセージ表示エリア（スクロール可能）
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: UITokens.colorAccent.withAlpha(77),
                ),
                borderRadius: BorderRadius.circular(UITokens.radiusMd),
              ),
              padding: const EdgeInsets.all(UITokens.spacingMd),
              child: ListView.builder(
                itemCount:
                    _messages.length + (_currentMessage.isNotEmpty ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < _messages.length) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(bottom: UITokens.spacingSm),
                      child: Text(
                        _messages[index],
                        style: TextStyle(
                          fontSize: 16,
                          color: UITokens.colorAccent,
                        ),
                      ),
                    );
                  } else {
                    // 現在ストリーミング中のメッセージ
                    return Text(
                      _currentMessage,
                      style: TextStyle(
                        fontSize: 16,
                        color: UITokens.colorAccent,
                      ),
                    );
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: UITokens.spacingLg),

          // アクションボタン
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                label: L10nJa.buttonNextTurn,
                onPressed: _isStreaming ? null : _handleNextTurn,
              ),
              _buildActionButton(
                label: L10nJa.buttonConclusion,
                onPressed: _isStreaming ? null : _handleConclusion,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 次のターン生成ハンドラ（M1-D2）
  void _handleNextTurn() async {
    // ConversationEngine 初期化（初回のみ）
    _conversationEngine ??= ConversationEngine(
      theme: 'テスト議題', // TODO: M1で実装時に実際のテーマを渡す
      personas: PersonaRepository.instance.getAll(),
    );

    setState(() {
      _isStreaming = true;
      _currentMessage = '';
    });

    // 前回のストリーム購読をキャンセル
    await _streamSubscription?.cancel();

    // ストリーム購読開始
    _streamSubscription = _conversationEngine!.nextTurn().listen(
      (chunk) {
        setState(() {
          _currentMessage += chunk.textFragment;

          // ストリーム完了時
          if (chunk.isComplete) {
            _messages.add('${chunk.speakerName}：$_currentMessage');
            _currentMessage = '';
            _isStreaming = false;

            // 状態遷移: turnCompleted イベント発火
            _transition(SessionEvent.turnCompleted);
          }
        });
      },
      onError: (error) {
        setState(() {
          _isStreaming = false;
        });
        // TODO: エラーハンドリング（M1-B3 で実装）
      },
    );
  }

  /// 結論トリガーハンドラ（M1-D2, M1-D4で拡張）
  void _handleConclusion() {
    // M1-D4: Crystal Draft を生成
    if (_conversationEngine != null) {
      setState(() {
        _crystalDraft = SummaryCrystal.generateCrystalDraft(
          theme: 'テスト議題', // TODO: M1で実装時に実際のテーマを渡す
          messages: _messages,
          participants: PersonaRepository.instance.getAll(),
          turnCount: _conversationEngine!.currentTurnIndex,
        );
      });
    }

    _transition(SessionEvent.conclusionTriggered);
  }

  /// 結晶化画面（M1-D4）
  Widget _buildConvergenceScreen() {
    if (_crystalDraft == null) {
      return Center(
        child: Text(
          'Crystal を生成できませんでした',
          style: TextStyle(
            fontSize: 16,
            color: UITokens.colorAccent,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(UITokens.spacingLg),
      child: Column(
        children: [
          // ヘッダー
          Text(
            L10nJa.stateConvergence,
            style: TextStyle(
              fontSize: 24,
              color: UITokens.colorAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: UITokens.spacingMd),
          Text(
            L10nJa.descConvergence,
            style: TextStyle(
              fontSize: 14,
              color: UITokens.colorAccent.withAlpha(153),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: UITokens.spacingLg),

          // Crystal 内容表示エリア（スクロール可能）
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: UITokens.colorAccent.withAlpha(77),
                ),
                borderRadius: BorderRadius.circular(UITokens.radiusMd),
              ),
              padding: const EdgeInsets.all(UITokens.spacingMd),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // タイトル
                    _buildCrystalField(
                      label: L10nJa.labelCrystalTitle,
                      value: _crystalDraft!.title,
                    ),
                    const SizedBox(height: UITokens.spacingMd),

                    // テーマ
                    _buildCrystalField(
                      label: L10nJa.labelCrystalTheme,
                      value: _crystalDraft!.theme,
                    ),
                    const SizedBox(height: UITokens.spacingMd),

                    // 参加者
                    _buildCrystalField(
                      label: L10nJa.labelCrystalParticipants,
                      value: _crystalDraft!.participants
                          .map((p) => p.name)
                          .join('、'),
                    ),
                    const SizedBox(height: UITokens.spacingLg),

                    // 要約
                    _buildCrystalField(
                      label: L10nJa.labelCrystalSummary,
                      value: _crystalDraft!.summary,
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: UITokens.spacingLg),

          // アクションボタン
          _buildActionButton(
            label: L10nJa.buttonToHistory,
            onPressed: () => _transition(SessionEvent.crystalSaved),
          ),
        ],
      ),
    );
  }

  /// Crystal フィールド表示（ラベル＋値）
  Widget _buildCrystalField({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: UITokens.colorAccent.withAlpha(153),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: UITokens.spacingSm),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: UITokens.colorAccent,
          ),
        ),
      ],
    );
  }

  /// エラー画面（M1-B3）
  Widget _buildErrorScreen() {
    final errorMessage =
        _machine.errorContext?.message ?? L10nJa.errorGeneric;
    final details = _machine.errorContext?.details;

    return Padding(
      padding: const EdgeInsets.all(UITokens.spacingLg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ヘッダー
          Text(
            L10nJa.stateError,
            style: TextStyle(
              fontSize: 24,
              color: UITokens.colorAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: UITokens.spacingLg),

          // エラーメッセージ
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: UITokens.colorAccent.withAlpha(77)),
              borderRadius: BorderRadius.circular(UITokens.radiusMd),
            ),
            padding: const EdgeInsets.all(UITokens.spacingMd),
            child: Text(
              errorMessage,
              style: TextStyle(
                fontSize: 16,
                color: UITokens.colorAccent,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          if (details != null) ...[
            const SizedBox(height: UITokens.spacingMd),
            ExpansionTile(
              title: Text(
                '詳細情報',
                style: TextStyle(
                  fontSize: 14,
                  color: UITokens.colorAccent,
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(UITokens.spacingMd),
                  child: Text(
                    details,
                    style: TextStyle(
                      fontSize: 12,
                      color: UITokens.colorAccent.withAlpha(204),
                    ),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: UITokens.spacingMd),
          Text(
            L10nJa.errorRecoveryHint,
            style: TextStyle(
              fontSize: 14,
              color: UITokens.colorAccent.withAlpha(153),
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: UITokens.spacingXl),

          // ボタン（縦並び）
          _buildActionButton(
            label: L10nJa.buttonRetry,
            onPressed: () => _handleErrorRecovered(),
          ),
          const SizedBox(height: UITokens.spacingMd),
          _buildActionButton(
            label: L10nJa.buttonAbort,
            onPressed: () => _handleErrorAbort(),
          ),
          const SizedBox(height: UITokens.spacingMd),
          _buildActionButton(
            label: L10nJa.buttonResume,
            onPressed: () => _handleErrorRecovered(), // 再試行と同じ
          ),
        ],
      ),
    );
  }

  /// エラーリカバリーハンドラ（再試行/再開）（M1-B3）
  void _handleErrorRecovered() {
    _transition(SessionEvent.recovered);
  }

  /// エラー中断ハンドラ（M1-B3）
  void _handleErrorAbort() {
    _transition(SessionEvent.sessionEnded);
  }
}
