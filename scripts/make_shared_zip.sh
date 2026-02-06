#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

mkdir -p dist
ZIP="dist/polaris-source-$(git rev-parse --short HEAD).zip"

# Git追跡ファイルのみを配布する（.git や生成物が入らないことを保証）
git archive --format=zip -o "$ZIP" HEAD

# 検査：入ってはいけないものが含まれていたら失敗
if unzip -l "$ZIP" | rg -n "\.git/|\.dart_tool/|build/|\.idea/|\.vscode/|\.iml$|\.flutter-plugins|\.flutter-plugins-dependencies"; then
  echo "ERROR: zip contains forbidden paths"
  exit 1
fi

echo "OK: $ZIP"
