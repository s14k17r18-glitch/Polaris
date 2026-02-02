# tools

開発ツール（lint / format / CIチェック / 英語直書き禁止）

## 役割

- **A2**: lint/format/test 自動化（✅ 実装済み）
- **A6**: 英語直書き禁止チェック（✅ 実装済み）

## 使用方法

### Windows

```cmd
# Dart 解析（lint）
tools\run_analyze.bat

# フォーマット
tools\run_format.bat

# テスト実行
tools\run_test.bat

# 英語直書きチェック（A6）
tools\run_check_english.bat
```

### 推奨実行順

1. `tools\run_format.bat`（任意）
2. `tools\run_analyze.bat`（必須）
3. `tools\run_check_english.bat`（必須）

### Melos 直接実行

```bash
# Dart 解析
melos run analyze

# フォーマット
melos run format

# テスト実行
melos run test
```

## ファイル一覧

- `run_analyze.bat`: Dart 解析スクリプト（Windows用）
- `run_format.bat`: フォーマットスクリプト（Windows用）
- `run_test.bat`: テスト実行スクリプト（Windows用）
- `run_check_english.bat`: 英語直書きチェック実行（Windows用）
- `check_english_literals.dart`: 英語直書き検出スクリプト（Dart）

## M0-A6 英語直書きチェック

### 契約
- `docs/00_PARITY_CONTRACT.md` - 文言は日本語のみ
- UI文言、エラーメッセージ、ユーザー可視ログに英語直書き禁止

### 検出対象
- `apps/` と `packages/` 配下の `.dart` ファイル
- 文字列リテラル内にASCII英字が3文字以上連続するもの

### 除外ルール（誤検知回避）
- URL（`http://`, `https://`）
- import（`package:`, `dart:`）
- ファイルパス（`/` を含む）
- ファイル拡張子（`.dart`, `.json` 等）
- raw文字列（`r'...'`, `r"..."`）
- `// ignore-english` コメントがある行
- `test/` 配下のファイル
- 生成コード（`.g.dart`, `.freezed.dart`）
- 識別子パターン（camelCase, snake_case）
- 全て大文字の定数（`DEBUG`, `API`等）
- `l10n_ja/` 自体（日本語文言の定義場所）

### 出力例
```
[OK] 英語直書きなし
```
または
```
[FAIL] 英語直書き検出 (2件)
  apps/dangi_app/lib/main.dart:42  'Hello World'
  packages/shared_core/lib/src/state.dart:15  'Error occurred'
```

## M0-A2 実装状況

- ✅ analysis_options.yaml（ルート＋各パッケージ）
- ✅ Windows用スクリプト（run_*.bat）
- ✅ melos.yaml スクリプト定義
