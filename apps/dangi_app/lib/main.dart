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

  @override
  void initState() {
    super.initState();
    // BOOT → IDLE への自動遷移（アプリ起動完了）
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _transition(SessionEvent.appStarted);
    });
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
    required VoidCallback onPressed,
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
}
