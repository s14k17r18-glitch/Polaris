# motion_tokens

モーショントークン（duration・curve）単一ソース

## 役割

- **06_MOTION_AUDIO_SPEC.md 準拠**
- Windows/iOS で同一のアニメーション定数を参照
- **OS別値禁止**（00_PARITY_CONTRACT.md）

## 使用例

```dart
import 'package:motion_tokens/motion_tokens.dart';

AnimatedContainer(
  duration: MotionTokens.durationNormal,
  curve: MotionTokens.curveDefault,
  ...
)
```

## Duration

- `durationFast`: 150ms - 素早い遷移
- `durationNormal`: 300ms - 標準的な遷移
- `durationSlow`: 500ms - ゆっくりした遷移
- `durationGenesis`: 5000ms - Genesis Sequence（Persona生成）

## Curve

- `curveDefault`: `Curves.easeOutExpo` - デフォルト（Fluid Sci-Fi）
- `curveSharp`: `Curves.easeOut` - シャープな遷移
- `curveSmooth`: `Curves.easeInOutCubic` - スムーズな遷移

## FPS Target

- `fpsTarget`: 60 - 目標フレームレート
