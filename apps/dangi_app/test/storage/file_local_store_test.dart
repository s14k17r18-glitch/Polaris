import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core/shared_core.dart';
import 'package:dangi_app/storage/file_local_store.dart';

void main() {
  group('FileLocalStore（M2-E3）', () {
    late Directory tempDir;
    late FileLocalStore store;

    setUp(() async {
      // テスト用の一時ディレクトリを作成
      tempDir = await Directory.systemTemp.createTemp('file_store_test_');
      store = FileLocalStore(storageDirectory: tempDir);
    });

    tearDown(() async {
      await store.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    // 共通の同期メタデータ（テスト用）
    final testSync = SyncMetadata(
      schemaVersion: 1,
      ownerUserId: 'test_user',
      updatedAt: '2026-01-30T00:00:00Z',
      rev: 'rev_001',
      deletedAt: null,
      deviceId: 'test_device',
    );

    group('Session', () {
      test('upsert → get → 一致', () async {
        final session = SessionEntity(
          sessionId: 'session_001',
          createdAt: '2026-01-30T10:00:00Z',
          theme: 'テストテーマ',
          participants: [
            {'persona_id': 'p1', 'seat': 0},
            {'persona_id': 'p2', 'seat': 1},
          ],
          roundsMax: 20,
          sync: testSync,
        );

        await store.upsertSession(session);
        final retrieved = await store.getSession('session_001');

        expect(retrieved, isNotNull);
        expect(retrieved!.sessionId, session.sessionId);
        expect(retrieved.theme, session.theme);
        expect(retrieved.participants, session.participants);
      });

      test('list → 未削除のみ取得', () async {
        await store.upsertSession(SessionEntity(
          sessionId: 's1',
          createdAt: '2026-01-30T00:00:00Z',
          theme: 'テーマ1',
          participants: [],
          roundsMax: 10,
          sync: testSync,
        ));
        await store.upsertSession(SessionEntity(
          sessionId: 's2',
          createdAt: '2026-01-30T00:00:00Z',
          theme: 'テーマ2',
          participants: [],
          roundsMax: 10,
          sync: testSync,
        ));

        await store.deleteSession('s1');

        final list = await store.listSessions();
        expect(list.length, 1);
        expect(list.first.sessionId, 's2');
      });

      test('再起動後もデータが残る', () async {
        await store.upsertSession(SessionEntity(
          sessionId: 's1',
          createdAt: '2026-01-30T00:00:00Z',
          theme: 'テーマ',
          participants: [],
          roundsMax: 10,
          sync: testSync,
        ));

        // ストアを閉じて再作成（再起動をシミュレート）
        await store.close();
        store = FileLocalStore(storageDirectory: tempDir);

        final retrieved = await store.getSession('s1');
        expect(retrieved, isNotNull);
        expect(retrieved!.theme, 'テーマ');
      });
    });

    group('Message', () {
      test('upsert → get → 一致', () async {
        final message = MessageEntity(
          messageId: 'message_001',
          sessionId: 'session_001',
          turnIndex: 0,
          speakerType: 'persona',
          speakerId: 'persona_001',
          text: 'テストメッセージ',
          createdAt: '2026-01-30T10:00:00Z',
          sync: testSync,
        );

        await store.upsertMessage(message);
        final retrieved = await store.getMessage('message_001');

        expect(retrieved, isNotNull);
        expect(retrieved!.messageId, message.messageId);
        expect(retrieved.text, message.text);
      });

      test('listMessagesBySession → セッション別取得', () async {
        await store.upsertMessage(MessageEntity(
          messageId: 'm1',
          sessionId: 's1',
          turnIndex: 0,
          speakerType: 'persona',
          speakerId: 'p1',
          text: 'メッセージ1',
          createdAt: '2026-01-30T10:00:00Z',
          sync: testSync,
        ));
        await store.upsertMessage(MessageEntity(
          messageId: 'm2',
          sessionId: 's2',
          turnIndex: 0,
          speakerType: 'persona',
          speakerId: 'p1',
          text: 'メッセージ2',
          createdAt: '2026-01-30T10:00:00Z',
          sync: testSync,
        ));

        final list = await store.listMessagesBySession('s1');
        expect(list.length, 1);
        expect(list.first.messageId, 'm1');
      });

      test('upsert 更新 → 最新版を取得', () async {
        // 最初のバージョン
        await store.upsertMessage(MessageEntity(
          messageId: 'm1',
          sessionId: 's1',
          turnIndex: 0,
          speakerType: 'persona',
          speakerId: 'p1',
          text: '古いメッセージ',
          createdAt: '2026-01-30T10:00:00Z',
          sync: testSync,
        ));

        // 更新版（updated_at が新しい）
        await store.upsertMessage(MessageEntity(
          messageId: 'm1',
          sessionId: 's1',
          turnIndex: 0,
          speakerType: 'persona',
          speakerId: 'p1',
          text: '新しいメッセージ',
          createdAt: '2026-01-30T10:00:00Z',
          sync: testSync.copyWith(
            updatedAt: '2026-01-30T11:00:00Z',
            rev: 'rev_002',
          ),
        ));

        final retrieved = await store.getMessage('m1');
        expect(retrieved, isNotNull);
        expect(retrieved!.text, '新しいメッセージ');
        expect(retrieved.sync.rev, 'rev_002');
      });
    });

    test('clearAll → すべてクリア', () async {
      await store.upsertSession(SessionEntity(
        sessionId: 's1',
        createdAt: '2026-01-30T00:00:00Z',
        theme: 'テーマ',
        participants: [],
        roundsMax: 10,
        sync: testSync,
      ));
      await store.upsertMessage(MessageEntity(
        messageId: 'm1',
        sessionId: 's1',
        turnIndex: 0,
        speakerType: 'persona',
        speakerId: 'p1',
        text: 'メッセージ',
        createdAt: '2026-01-30T10:00:00Z',
        sync: testSync,
      ));

      await store.clearAll();

      final sessions = await store.listSessions();
      final messages = await store.listMessagesBySession('s1');
      expect(sessions.length, 0);
      expect(messages.length, 0);
    });
  });
}
