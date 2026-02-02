# DanGi ドキュメント構成（CONCEPT→実装計画）

このフォルダは `CONCEPT.md`（世界観/体験リファレンス）を**変更せず**に保持しつつ、
実装に必要な情報を「実装できる粒度」に分割していくための派生ドキュメント群です。

## 最重要方針：Windows+iOSで“同一機能”を維持する
本プロダクトは **Windows（PC）版と iOS（モバイル）版で同一機能**を提供し、
さらに **persona（全て）と談議後データ（全て）を共有**します。

そのため、以下を原則とします。

- 仕様は **docs を唯一の正**とし、片方の実装だけ先行させない  
- ロジックは **共通コア（Conversation Engine / Data Model / Sync）**へ集約し、OS別に二重実装しない  
- 変更の完了条件（DoD）は **Windows+iOSの両方で成立**して初めてPASSとする  
- データはクラウド同期を前提にし、スキーマはバージョニングし、移行（migration）を必須にする

## ファイル一覧（役割）
- `00_PARITY_CONTRACT.md`：Windows+iOSの完全一致契約（最優先）
- `00_MVP_SCOPE_LOCK.md`：M0〜M3のMVP範囲固定（勝手盛り防止）
- `12_SYNC_API_SPEC.md`：同期API契約（M3実装の唯一の正）
- `CONCEPT.md`：原典（変更しない）
- `01_REQUIREMENTS.md`：要件（MUST/SHOULD/LATER）※Windows+iOSパリティと全共有をMUST化
- `02_PRODUCT_FLOW.md`：セッション体験の状態遷移/画面フロー
- `03_PERSONAS_SCHEMA.md`：Personaデータのスキーマと最低限の定義項目
- `04_CONVERSATION_ENGINE_SPEC.md`：討論エンジン（ターン制/ルール/逸脱処理/終了条件）
- `05_UI_VISUAL_SPEC.md`：UI/ビジュアルの実装指針
- `06_MOTION_AUDIO_SPEC.md`：アニメ/SE/BGM（イベント→演出）と段階導入案
- `07_DATA_MODEL.md`：保存・同期形式（Session/Message/Persona/Crystal等）＋スキーマversion/競合対策
- `08_ARCHITECTURE.md`：アーキテクチャ（共通コア＋薄い殻×2、同期境界）
- `09_IMPLEMENTATION_PLAN.md`：マイルストーン & WBS（実装順とDoDを両OSで固定）
- `10_RISKS_AND_GUARDS.md`：安全・法務・運用リスクとガード（声/実在人物persona等）

## 分割方針（原典を守る）
`CONCEPT.md` は「世界観と体験の北極星」。実装で揉めやすい箇所（会話ルール、状態遷移、同期、データ形式、段階導入）
を派生ファイルで具体化します。原典に追記したくなったら、まず派生側に追記し、十分固まったら原典に戻す運用。
