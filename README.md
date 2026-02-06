# Polaris

Windows + iOS クロスプラットフォーム対話アプリケーション

## 概要

「Polaris」は、複数のPersona（人格）による対話を通じて、新しい洞察（Knowledge Crystal）を生成するアプリケーションです。

## 技術スタック

- **Flutter + Dart**: Windows + iOS クロスプラットフォーム
- **Pub Workspaces + Melos**: モノレポ管理

## ディレクトリ構成

```
/
  docs/                         # 契約・仕様書
  apps/
    dangi_app/                  # Flutter アプリ（Windows + iOS）
  packages/
    shared_core/                # 共通コア（状態遷移・会話エンジン・データモデル・同期）
    ui_tokens/                  # UI トークン（色・余白・角丸・影）
    motion_tokens/              # モーショントークン（duration・curve）
    l10n_ja/                    # 日本語文言（完全日本語固定）
  contracts/                    # OpenAPI / JSON Schema（M3で使用）
  backend/                      # API / DB（M3で実装）
  tools/                        # lint / format / CIチェック
```

## セットアップ

### 前提条件

- Flutter SDK 3.27 以上
- Dart SDK 3.6 以上

### 初期セットアップ

```bash
# 1. Melos をグローバルにアクティベート
dart pub global activate melos

# 2. 依存関係を解決
melos bootstrap
```

## 起動方法

### Windows

```bash
cd apps/dangi_app
flutter run -d windows
```

### iOS

```bash
# シミュレータ一覧を確認
flutter devices

# iOS シミュレータで起動
cd apps/dangi_app
flutter run -d <simulator-id>
```

## 開発ルール

### 契約遵守（必須）

- [docs/00_PARITY_CONTRACT.md](docs/00_PARITY_CONTRACT.md): Windows/iOS 同一機能・同一データ・日本語固定
- [docs/00_MVP_SCOPE_LOCK.md](docs/00_MVP_SCOPE_LOCK.md): MVP範囲固定（勝手盛り禁止）
- [docs/09_IMPLEMENTATION_PLAN.md](docs/09_IMPLEMENTATION_PLAN.md): 実装順序

### コーディング規約

- **UI トークン**: `ui_tokens` パッケージから参照（OS別値禁止）
- **モーション**: `motion_tokens` パッケージから参照（OS別値禁止）
- **文言**: `l10n_ja` パッケージから参照（英語直書き禁止）
- **ロジック**: `shared_core` に集約（殻には置かない）

## Melos コマンド

```bash
# 全パッケージの依存関係を解決
melos bootstrap

# 全パッケージを解析
melos run analyze

# 全パッケージをフォーマット
melos run format

# 全パッケージのテストを実行
melos run test
```

## マイルストーン

- **M0**: 骨組み（共通コア＋殻）✓ 実装中
- **M1**: 談議エンジン（縦スライス完走）
- **M2**: 保存（ローカル）＋再現
- **M3**: 同期（全共有の最低ライン）
- **M4**: UX強化（操作性）
- **M5**: 演出（Research Lab感）

## ライセンス

TBD

## 運用ルール

詳細は [.claude/CLAUDE.md](.claude/CLAUDE.md) を参照してください。
