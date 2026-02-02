import 'package:flutter/material.dart';
import 'package:ui_tokens/ui_tokens.dart';
import 'package:l10n_ja/l10n_ja.dart';

void main() {
  runApp(const DangiApp());
}

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
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
            const SizedBox(height: 16),
            Text(
              L10nJa.helloWorld,
              style: TextStyle(
                fontSize: 16,
                color: UITokens.colorAccent.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
