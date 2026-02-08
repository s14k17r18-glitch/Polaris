import 'package:flutter/foundation.dart';
import 'package:shared_core/shared_core.dart';

class SyncProbe {
  static const bool enabled = bool.fromEnvironment('SYNC_PROBE');
  static const String baseUrl = String.fromEnvironment(
    'SYNC_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );

  static Future<void> maybeRun({
    required String deviceId,
    required String ownerUserId,
  }) async {
    if (!enabled) return;

    final client = SyncClient(baseUrl: baseUrl);
    final now = DateTime.now().toUtc().toIso8601String();
    final id = '$deviceId-$now';

    try {
      await client.health();
      await client.pull(cursor: null, limit: 10);
      await client.push(
        clientTime: now,
        mutations: [
          SyncMutation(
            entity: 'session',
            op: 'upsert',
            id: id,
            updatedAt: now,
            payload: {
              'probe': true,
              'device_id': deviceId,
              'owner_user_id': ownerUserId,
            },
          ),
        ],
      );
      debugPrint('SYNC_PROBE: health/pull/push completed');
    } catch (error) {
      debugPrint('SYNC_PROBE error: $error');
    } finally {
      client.close();
    }
  }
}
