# 共有用Zipの作り方（正規手順）
共有用Zipは必ず `scripts/make_shared_zip.sh` で生成する。

- 配布対象：Git追跡ファイル（HEAD）のみ
- 含めない：.git、.dart_tool、build、IDEファイル、.flutter-plugins* 等の生成物

手作業でフォルダを丸ごとZip化するのは禁止（混入の原因になる）。
