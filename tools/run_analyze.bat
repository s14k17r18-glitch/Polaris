@echo off
setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

REM Force UTF-8 for output (ASCII-only commands stay safe)
chcp 65001 >nul

echo ====================================
echo   Analyze: monorepo (apps + packages)
echo ====================================

REM Move to repo root (this .bat is expected to live in tools\)
pushd "%~dp0.."

set "EXITCODE=0"

call :ANALYZE_GLOB "apps\*"
call :ANALYZE_GLOB "packages\*"

popd

if NOT "%EXITCODE%"=="0" (
  echo.
  echo [FAIL] Analyze finished with errors.
  exit /b %EXITCODE%
)

echo.
echo [OK] Analyze finished successfully.
exit /b 0


:ANALYZE_GLOB
for /d %%D in (%~1) do (
  if exist "%%D\pubspec.yaml" (
    call :ANALYZE_ONE "%%D"
  )
)
exit /b 0


:ANALYZE_ONE
set "PKG=%~1"
echo.
echo ---- %PKG% ----

REM Detect Flutter package by checking for "sdk: flutter" in pubspec.yaml
findstr /C:"sdk: flutter" "%PKG%\pubspec.yaml" >nul 2>nul
if %ERRORLEVEL%==0 (
  echo [RUN] flutter analyze
  pushd "%PKG%"
  flutter analyze
  set "PKGRESULT=!ERRORLEVEL!"
  popd
  if NOT "!PKGRESULT!"=="0" set "EXITCODE=1"
) else (
  echo [RUN] dart analyze
  pushd "%PKG%"
  dart analyze
  set "PKGRESULT=!ERRORLEVEL!"
  popd
  if NOT "!PKGRESULT!"=="0" set "EXITCODE=1"
)

exit /b 0
