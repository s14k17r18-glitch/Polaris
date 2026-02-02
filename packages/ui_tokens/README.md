# ui_tokens

UI トークン（色・余白・角丸・影）単一ソース

## 役割

- **05_UI_VISUAL_SPEC.md 準拠**
- Windows/iOS で同一の値を参照
- **OS別値禁止**（00_PARITY_CONTRACT.md）

## 使用例

```dart
import 'package:ui_tokens/ui_tokens.dart';

Container(
  color: UITokens.colorBase,
  padding: EdgeInsets.all(UITokens.spacingMd),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(UITokens.radiusMd),
  ),
)
```

## 色定義

- `colorBase`: `#0A0E17` (Deep Space) - 背景色
- `colorAccent`: `#00F0FF` (Cyan Neon) - アクセント色、アクティブ要素
- `colorSecondary`: `#7000FF` (Purple) - セカンダリアクセント

## 余白

- `spacingXs`: 4.0
- `spacingSm`: 8.0
- `spacingMd`: 16.0
- `spacingLg`: 24.0
- `spacingXl`: 32.0

## 角丸

- `radiusSm`: 4.0
- `radiusMd`: 8.0
- `radiusLg`: 16.0

## Glassmorphism

- `blurMin`: 10.0
- `blurMax`: 20.0
- `opacity`: 0.8
