---
name: autofix-loop
description: Use when lint/test fails: apply limited fix loops (max 3), do not expand scope beyond MVP.
---
# Purpose
This skill encodes the project's working agreement and should be used when relevant.

# Instructions
- Follow the rules exactly.
- If the user's request conflicts with these rules, stop and explain the conflict, then propose the compliant alternative.
- Keep changes minimal and aligned with the MVP scope.

# Source (cloudcode/.claude)
This skill was derived from: .claude/rules/25-autofix-loop.md

# Rules (verbatim / adapted)

> BEGIN SOURCE
> # AutoFix Loop（解析/フォーマットの自動修正ループ）
> 
> 目的：
> - tools\run_analyze.bat が [OK] になるまで
> - 必要なら tools\run_format.bat も通るまで
> - 「検知→修正→再実行」を自動で回す
> 
> ## 実行順（必須）
> 1) cd <repo-root>
> 2) flutter pub get（必要なら）
> 3) tools\run_format.bat（任意だが推奨）
> 4) tools\run_analyze.bat
> 5) FAILなら、ログから原因分類→修正→(2に戻る) を最大3ループ
> 6) 3ループで直らない場合は停止して、原因と次の選択肢を提示
> 
> ## 実行できる/できない の分岐
> - 実行できる環境：自分でコマンド実行してログ解析→修正→再実行まで行う
> - 実行できない環境：ユーザーに実行コマンドを提示し、返ってきたログを解析して修正案を出す
>   （“待つ”のではなく、次にユーザーが打つコマンドを明示する）
> 
> ## 自動修正の対象（よくある軽微エラー）
> ### A) unused_import / unused_local_variable / dead_code
> - 未使用 import / 変数 / 到達不能コードを削除
> 
> ### B) unnecessary_library_name
> - 各 library の公開ファイル（lib/*.dart）にある `library xxx;` を削除
> 
> ### C) dangling_library_doc_comments
> - 先頭の `///` が library 宣言なしでぶら下がっている場合は、
>   `///` を `//` に置換（library宣言を増やさない方針）
> 
> ### D) deprecated_member_use（置換が明確なもの）
> - 置換が明確な場合のみ置換（例：withOpacity → withAlpha(…))
> - 置換が不明確なら停止して選択肢提示
> 
> ### E) include_file_not_found（analysis_options）
> - Dart-only package は lints を採用し、Flutter package は flutter_lints を採用する
> - Dart-only：analysis_options.yaml は `include: package:lints/recommended.yaml`
> - Flutter：analysis_options.yaml は `include: package:flutter_lints/flutter.yaml`
> - includeに合わせて dev_dependencies を追加（lints / flutter_lints）
> 
> ## コード変更のルール
> - 1回のループで変更するのは最小限（原因のあるファイルのみ）
> - 変更後は必ず再実行し、修正の効果をログで確認
> - “MVP範囲外の機能追加”は絶対にしない（契約違反）
> 
> ## 完了報告（必須）
> - 直したエラー種別（A〜Eのどれ）
> - 修正したファイル一覧
> - 最終ログ（No issues found / [OK]）の要点
> END SOURCE
