import 'dart:convert';
import 'dart:io';

import 'sync_models.dart';

class SyncClientException implements Exception {
  const SyncClientException(this.message, {this.statusCode, this.body});

  final String message;
  final int? statusCode;
  final String? body;

  @override
  String toString() => 'SyncClientException: $message';
}

class SyncClient {
  SyncClient({
    required String baseUrl,
    HttpClient? httpClient,
    String? bearerToken,
  })  : _baseUrl = baseUrl.endsWith('/')
            ? baseUrl.substring(0, baseUrl.length - 1)
            : baseUrl,
        _client = httpClient ?? HttpClient(),
        _bearerToken = bearerToken;

  final String _baseUrl;
  final HttpClient _client;
  final String? _bearerToken;

  void close() {
    _client.close(force: true);
  }

  Future<Map<String, dynamic>> health() async {
    final uri = Uri.parse('$_baseUrl/v1/health');
    final request = await _client.getUrl(uri);
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();
    if (response.statusCode != 200) {
      throw SyncClientException('ヘルスチェックに失敗しました',
          statusCode: response.statusCode, body: body);
    }
    final decoded = jsonDecode(body);
    if (decoded is! Map<String, dynamic>) {
      throw const SyncClientException('ヘルスレスポンスが不正です');
    }
    return decoded;
  }

  Future<SyncPushResponse> push({
    required String clientTime,
    required List<SyncMutation> mutations,
  }) async {
    final body = {
      'client_time': clientTime,
      'mutations': mutations.map((e) => e.toJson()).toList(),
    };
    final json = await _postJson('/v1/sync/push', body);
    return SyncPushResponse.fromJson(json);
  }

  Future<SyncPullResponse> pull({
    String? cursor,
    int? limit,
  }) async {
    final body = <String, dynamic>{};
    if (cursor != null) {
      body['cursor'] = cursor;
    }
    if (limit != null) {
      body['limit'] = limit;
    }
    final json = await _postJson('/v1/sync/pull', body);
    return SyncPullResponse.fromJson(json);
  }

  Future<Map<String, dynamic>> _postJson(
    String path,
    Map<String, dynamic> body,
  ) async {
    final uri = Uri.parse('$_baseUrl$path');
    final request = await _client.postUrl(uri);
    request.headers.contentType = ContentType.json;
    if (_bearerToken?.isNotEmpty == true) {
      request.headers.set('authorization', 'Bearer $_bearerToken');
    }
    request.write(jsonEncode(body));

    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    if (response.statusCode != 200) {
      throw SyncClientException('リクエストに失敗しました',
          statusCode: response.statusCode, body: responseBody);
    }

    final decoded = jsonDecode(responseBody);
    if (decoded is! Map<String, dynamic>) {
      throw const SyncClientException('レスポンス形式が不正です');
    }
    return decoded;
  }
}
