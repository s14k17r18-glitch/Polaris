import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

/// 認証リポジトリ（M3-F1: 最小実装）
///
/// device_id と owner_user_id を永続化・取得する。
/// MVP では owner_user_id = device_id（単一ユーザー、クラウド認証なし）。
class AuthRepository {
  AuthRepository._();

  static const _keyDeviceId = 'auth_device_id';
  static const _keyOwnerUserId = 'auth_owner_user_id';

  late final SharedPreferences _prefs;
  late final String _deviceId;
  late final String _ownerUserId;

  /// デバイスID（UUID、初回起動時に生成）
  String get deviceId => _deviceId;

  /// オーナーユーザーID（MVP: device_id と同一）
  String get ownerUserId => _ownerUserId;

  /// 初期化（アプリ起動時に1回呼ぶ）
  static Future<AuthRepository> initialize() async {
    final instance = AuthRepository._();
    instance._prefs = await SharedPreferences.getInstance();

    // device_id: 未設定なら UUID 生成
    var deviceId = instance._prefs.getString(_keyDeviceId);
    if (deviceId == null) {
      deviceId = const Uuid().v4();
      await instance._prefs.setString(_keyDeviceId, deviceId);
    }
    instance._deviceId = deviceId;

    // owner_user_id: MVP では device_id と同一
    var ownerUserId = instance._prefs.getString(_keyOwnerUserId);
    if (ownerUserId == null) {
      ownerUserId = deviceId;
      await instance._prefs.setString(_keyOwnerUserId, ownerUserId);
    }
    instance._ownerUserId = ownerUserId;

    return instance;
  }
}
