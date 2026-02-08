# Sync smoke evidence (Windows)

Date: 2026-02-08
main: f362f16

## Backend health
curl.exe -sS http://127.0.0.1:8080/v1/health
=> {""status"":""ok"",""version"":""2026.02.08"",...}

## Flutter SyncProbe
flutter run -d windows --dart-define=SYNC_PROBE=true --dart-define=SYNC_BASE_URL=http://127.0.0.1:8080
=> SYNC_PROBE: health/pull/push completed
