import 'dart:convert';
import 'dart:io';

import 'package:shared_core/shared_core.dart';
import 'package:test/test.dart';

Future<HttpServer> _startServer(
    Future<void> Function(HttpRequest request) handler) async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
  server.listen((request) async {
    await handler(request);
  });
  return server;
}

void main() {
  test('push sends mutations and parses response', () async {
    final server = await _startServer((request) async {
      expect(request.method, 'POST');
      expect(request.uri.path, '/v1/sync/push');

      final body = await utf8.decoder.bind(request).join();
      final json = jsonDecode(body) as Map<String, dynamic>;
      expect(json['client_time'], isA<String>());
      expect(json['mutations'], isA<List<dynamic>>());

      request.response.statusCode = 200;
      request.response.headers.contentType = ContentType.json;
      request.response.write(jsonEncode({
        'accepted': [
          {
            'entity': 'session',
            'id': '01HZZZZZZZZZZZZZZZZZZZZZZZ',
            'rev': '1',
            'updated_at': '2026-02-08T00:00:00Z'
          }
        ],
        'conflicts': []
      }));
      await request.response.close();
    });

    final client = SyncClient(baseUrl: 'http://127.0.0.1:${server.port}');
    final response = await client.push(
      clientTime: '2026-02-08T00:00:00Z',
      mutations: [
        SyncMutation(
          entity: 'session',
          op: 'upsert',
          id: '01HZZZZZZZZZZZZZZZZZZZZZZZ',
          updatedAt: '2026-02-08T00:00:00Z',
          payload: const {'theme': 'test'},
        ),
      ],
    );

    expect(response.accepted.length, 1);
    expect(response.accepted.first.entity, 'session');

    client.close();
    await server.close(force: true);
  });

  test('pull parses changes', () async {
    final server = await _startServer((request) async {
      expect(request.method, 'POST');
      expect(request.uri.path, '/v1/sync/pull');

      request.response.statusCode = 200;
      request.response.headers.contentType = ContentType.json;
      request.response.write(jsonEncode({
        'next_cursor': null,
        'server_time': '2026-02-08T00:00:00Z',
        'changes': [
          {
            'entity': 'session',
            'op': 'upsert',
            'id': '01HZZZZZZZZZZZZZZZZZZZZZZZ',
            'rev': '1',
            'updated_at': '2026-02-08T00:00:00Z',
            'deleted_at': null,
            'payload': {'theme': 'test'}
          }
        ]
      }));
      await request.response.close();
    });

    final client = SyncClient(baseUrl: 'http://127.0.0.1:${server.port}');
    final response = await client.pull(cursor: null, limit: 10);

    expect(response.changes.length, 1);
    expect(response.changes.first.entity, 'session');

    client.close();
    await server.close(force: true);
  });
}
