# 08 アーキテクチャ（Windows + iOS / 同機能維持）

## 原則（置いてけぼり防止のための設計）
- Windows/iOSでロジック二重化をしない
- 変更は「共通コア」に集約し、両OSへ同時反映する
- 同期（persona/談議データ共有）は最初から前提にする

---

## 推奨の構成（論理）
### 1) Shared Core（共通コア：1つだけ）
- Conversation Engine（ターン生成、ガード、要約、Crystal）
- Session State Machine（状態遷移、席順、ターン管理）
- Data Model（スキーマ、version、migration）
- Sync Client（API呼び出し、差分同期、競合戦略）
- Persona Store（定義、スナップショット）

### 2) Platform Shell（薄い殻：原則“1アプリ”）
- クロスプラットフォーム採用時は **1つのアプリ**（例：`apps/dangi_app`）の中で `windows/` `ios/` を内包し、UIコードは共有する（入力差のみ分岐）。
- どうしても別アプリになる場合でも、共通ロジックは必ず Shared Core に置き、Shell は **UIとOS連携だけ**に限定する。
※ここは「見た目と入力」だけ。会話の本体ロジックを置かない。

### 3) Backend（共有のために必須）
- Auth（ユーザー識別）
- API（Sync/Persona/Session/Message/Crystal）
- DB（クラウド）
- 監査ログ/レート制限/安全フィルタ（必要に応じて）

---

## 実装パターン（現実解）
- “1コードベースでWindows+iOS両方”を作れるフレームワークを採用するのが最も安全
  - 例：Flutter（Windows+iOS）
  - 例：.NET MAUI（Windows+iOS）※会話UI/演出との相性は要検討
- どうしても別実装にする場合でも、共通コアはライブラリ化して共有する（ただし難易度が上がる）

---

## 境界（後で揉めないために決める）
- UIは「演出したいイベント」をSession層へ要求するだけ（LLM/同期のことは知らない）
- Engineは「次の発言/要約/ガード判断」を返すだけ（UIの見た目は知らない）
- SyncはData Modelに従って差分をやり取りするだけ（UIは同期詳細を知らない）

---

## キー管理（必須）
- APIキー/秘密情報はクライアントに埋め込まない
- LLM呼び出しは原則バックエンド経由（キー漏洩と課金事故を防ぐ）
