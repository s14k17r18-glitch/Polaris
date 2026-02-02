@echo off
REM 英語直書きチェック実行スクリプト（M0-A6）
REM 契約: 00_PARITY_CONTRACT.md - 文言は日本語のみ

setlocal
cd /d "%~dp0.."

echo ====================================
echo   Run: check_english_literals.dart
echo ====================================

dart run tools/check_english_literals.dart .

if %ERRORLEVEL% EQU 0 (
    echo.
    echo [OK] English literal check passed.
) else (
    echo.
    echo [FAIL] English literals detected. Fix them and re-run.
    exit /b 1
)

endlocal
