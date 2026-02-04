import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core/shared_core.dart';
import 'package:dangi_app/storage/file_local_store.dart';

void main() {
  group('M2-E4: 永続化統合テスト', () {
    late Directory tempDir;
    late FileLocalStore store;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('integration_test_');
      store = FileLocalStore(storageDirectory: tempDir);
    });

    tearDown(() async {
      await store.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('セッション保存 → 復元の一貫性', () async {
      // 共通メタデータ
      final sync = SyncMetadata(
        schemaVersion: 1,
        ownerUserId: 'test_user',
        updatedAt: '2026-02-04T00:00:00Z',
        rev: 'rev_001',
        deletedAt: null,
        deviceId: 'test_device',
      );

      // Session 保存
      final session = SessionEntity(
        sessionId: 'session_test_001',
        createdAt: '2026-02-04T00:00:00Z',
        theme: 'テスト議題',
        participants: [
          {'persona_id': 'p1', 'seat': 0},
          {'persona_id': 'p2', 'seat': 1},
        ],
        roundsMax: 20,
        sync: sync,
      );
      await store.upsertSession(session);

      // Message 保存（複数）
      await store.upsertMessage(MessageEntity(
        messageId: 'msg_001',
        sessionId: 'session_test_001',
        turnIndex: 0,
        speakerType: 'persona',
        speakerId: 'p1',
        text: 'メッセージ1',
        createdAt: '2026-02-04T00:00:00Z',
        sync: sync,
      ));
      await store.upsertMessage(MessageEntity(
        messageId: 'msg_002',
        sessionId: 'session_test_001',
        turnIndex: 1,
        speakerType: 'persona',
        speakerId: 'p2',
        text: 'メッセージ2',
        createdAt: '2026-02-04T00:01:00Z',
        sync: sync.copyWith(updatedAt: '2026-02-04T00:01:00Z'),
      ));

      // Crystal 保存
      await store.upsertCrystal(CrystalEntity(
        crystalId: 'crystal_001',
        sessionId: 'session_test_001',
        summaryText: 'テスト要約',
        heatScore: 0.7,
        color: 'blue',
        createdAt: '2026-02-04T00:02:00Z',
        sync: sync.copyWith(updatedAt: '2026-02-04T00:02:00Z'),
      ));

      // 復元確認
      final retrievedSession = await store.getSession('session_test_001');
      expect(retrievedSession, isNotNull);
      expect(retrievedSession!.theme, 'テスト議題');

      final messages = await store.listMessagesBySession('session_test_001');
      expect(messages.length, 2);
      expect(messages[0].text, 'メッセージ1');
      expect(messages[1].text, 'メッセージ2');

      final crystals = await store.listCrystalsBySession('session_test_001');
      expect(crystals.length, 1);
      expect(crystals.first.summaryText, 'テスト要約');
    });

    test('セッション終了の保存と読込', () async {
      final sync = SyncMetadata(
        schemaVersion: 1,
        ownerUserId: 'test_user',
        updatedAt: '2026-02-04T00:00:00Z',
        rev: 'rev_001',
        deletedAt: null,
        deviceId: 'test_device',
      );

      // 初期Session保存
      final session = SessionEntity(
        sessionId: 'session_end_test',
        createdAt: '2026-02-04T00:00:00Z',
        theme: 'テーマ',
        participants: [],
        roundsMax: 10,
        sync: sync,
      );
      await store.upsertSession(session);

      // Session終了（ended_reason更新）
      final ended = session.copyWith(
        endedReason: 'user_action',
        sync: sync.copyWith(
          updatedAt: '2026-02-04T01:00:00Z',
          rev: 'rev_002',
        ),
      );
      await store.upsertSession(ended);

      // 復元確認
      final retrieved = await store.getSession('session_end_test');
      expect(retrieved, isNotNull);
      expect(retrieved!.endedReason, 'user_action');
      expect(retrieved.sync.rev, 'rev_002');
    });
  });
}
