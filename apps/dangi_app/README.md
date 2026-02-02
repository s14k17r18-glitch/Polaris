# dangi_app

Hokyoksei 談議アプリケーション（Windows + iOS クロスプラットフォーム）

## 役割

- UI層（画面遷移・ユーザー入力）
- プラットフォーム固有の入力差分のみを扱う
- **ロジックは shared_core に委譲**（契約遵守）

## 起動

### Windows

```bash
flutter run -d windows
```

### iOS

```bash
# シミュレータ一覧を確認
flutter devices

# iOS シミュレータで起動
flutter run -d <simulator-id>
```

## 契約

- UI トークンは `ui_tokens` から参照（OS別値禁止）
- モーションは `motion_tokens` から参照（OS別値禁止）
- 文言は `l10n_ja` から参照（英語直書き禁止）
- ロジックは `shared_core` に集約（殻は薄く保つ）

## M0 実装状況

- ✅ Hello World 表示
- ✅ UI トークン参照（colorBase, colorAccent）
- ✅ 日本語文言参照（appTitle, helloWorld）
- ⏳ 状態遷移接続（B2で実装予定）
