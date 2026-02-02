@echo off
setlocal ENABLEEXTENSIONS

REM Force UTF-8 for output (ASCII-only commands stay safe)
chcp 65001 >nul

echo ====================================
echo   Format: dart format .
echo ====================================

REM Move to repo root (this .bat is expected to live in tools\)
pushd "%~dp0.."

dart format .

set "EXITCODE=%ERRORLEVEL%"
popd

if NOT "%EXITCODE%"=="0" (
  echo.
  echo [FAIL] Format failed (exit=%EXITCODE%)
  exit /b %EXITCODE%
)

echo.
echo [OK] Format finished successfully.
exit /b 0
