# tools

開発ツール（lint / format / CIチェック）

## 役割

- **A2**: lint/format/test 自動化（✅ 実装済み）
- A6: 英語直書き禁止チェック（⏳ 今後実装）

## 使用方法

### Windows

```cmd
# Dart 解析（lint）
tools\run_analyze.bat

# フォーマット
tools\run_format.bat

# テスト実行
tools\run_test.bat
```

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
- `check_english_strings.dart`: 英語直書き禁止チェック（A6で実装予定）

## M0-A2 実装状況

- ✅ analysis_options.yaml（ルート＋各パッケージ）
- ✅ Windows用スクリプト（run_*.bat）
- ✅ melos.yaml スクリプト定義
