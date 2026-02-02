# shared_core

共通コア: Windows/iOS で共有されるロジック

## 役割

- 状態遷移（BOOT〜DISSOLUTION）
- データモデル（Session/Message/Crystal/Persona/Snapshot）
- 会話エンジン（ターン生成・ガード・要約・Crystal生成）
- 同期クライアント（差分同期・競合戦略）

## 契約

- **Flutter 非依存**（純粋 Dart パッケージ）
- **OS別分岐禁止**（すべて共通ロジック）
- **07_DATA_MODEL.md 準拠**
- **12_SYNC_API_SPEC.md 準拠**（M3以降）

## ディレクトリ構成

```
lib/
  shared_core.dart        # パッケージエクスポート
  src/
    schema/               # スキーマバージョン・マイグレーション（A3で実装済み）
      version.dart        # スキーマバージョン定義（単一ソース）
      migration.dart      # マイグレーションインターフェース＋ランナー
      migrations/
        migration_0_to_1.dart  # 0→1 の雛形実装
    models/               # データモデル（M1で実装）
    state/                # 状態遷移（B1で実装）
    engine/               # 会話エンジン（M1で実装）
    sync/                 # 同期クライアント（M3で実装）
```

## テスト

```bash
melos run test --scope=shared_core
```

## M0 実装状況

- ✅ パッケージ構造（A1で完了）
- ✅ スキーマバージョン・マイグレーション枠（A3で完了）
- ⏳ M1以降で実装予定（models / state / engine / sync）

## スキーマバージョン管理（A3）

### 使い方

```dart
import 'package:shared_core/shared_core.dart';

// 現在のスキーマバージョンを取得
print('Current: ${SchemaVersion.current}'); // 1

// バージョン互換性チェック
final compatible = SchemaVersion.isCompatible(1); // true
```

### マイグレーション実行

```dart
// Migration を登録
final runner = MigrationRunner(
  migrations: [const Migration0To1()],
);

// 古いデータを移行
final oldData = {'schema_version': 0};
final result = runner.run(oldData);

if (result.success) {
  print(result); // Migration成功: v0 → v1
}
```

### 新しい Migration の追加方法（M1 以降）

1. `src/schema/migrations/migration_X_to_Y.dart` を作成
2. `lib/shared_core.dart` に export 追加
3. `SchemaVersion.current` を更新
4. `SchemaVersion.history` に説明追加

**重要**: スキーマバージョンを上げる場合は必ず対応する Migration を追加すること
