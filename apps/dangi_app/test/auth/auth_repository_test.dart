import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dangi_app/auth/auth_repository.dart';

void main() {
  group('AuthRepository', () {
    test('初回起動で device_id が生成される', () async {
      SharedPreferences.setMockInitialValues({});
      final auth = await AuthRepository.initialize();

      expect(auth.deviceId, isNotEmpty);
      expect(auth.deviceId.length, 36); // UUID v4 format
    });

    test('2回目起動で同じ device_id が返る', () async {
      SharedPreferences.setMockInitialValues({
        'auth_device_id': 'existing-device-id',
        'auth_owner_user_id': 'existing-owner-id',
      });
      final auth = await AuthRepository.initialize();

      expect(auth.deviceId, 'existing-device-id');
      expect(auth.ownerUserId, 'existing-owner-id');
    });

    test('owner_user_id は MVP で device_id と同一', () async {
      SharedPreferences.setMockInitialValues({});
      final auth = await AuthRepository.initialize();

      expect(auth.ownerUserId, auth.deviceId);
    });
  });
}
