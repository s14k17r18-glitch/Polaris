@echo off
REM テストを全パッケージで実行（Windows用）
REM 使用方法: tools\run_test.bat

echo.
echo ====================================
echo   テストを実行中...
echo ====================================
echo.

cd /d "%~dp0.."
melos run test

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo [エラー] テストに失敗しました
    exit /b 1
)

echo.
echo [成功] テストが完了しました
exit /b 0
