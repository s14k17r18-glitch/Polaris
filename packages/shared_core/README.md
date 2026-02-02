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

- ✅ パッケージ構造のみ（枠作成完了）
- ⏳ M1以降で実装予定
