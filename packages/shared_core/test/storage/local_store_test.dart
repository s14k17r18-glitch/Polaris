import 'package:test/test.dart';
import 'package:shared_core/shared_core.dart';

void main() {
  group('LocalStore（M2-E2）', () {
    late LocalStore store;

    setUp(() {
      store = InMemoryStore();
    });

    tearDown(() async {
      await store.close();
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

    group('Persona', () {
      test('upsert → get → 一致', () async {
        final persona = PersonaEntity(
          personaId: 'persona_001',
          version: 1,
          definitionJson: {'name': 'テストペルソナ', 'stance': 'テスト立場'},
          sync: testSync,
        );

        await store.upsertPersona(persona);
        final retrieved = await store.getPersona('persona_001');

        expect(retrieved, isNotNull);
        expect(retrieved!.personaId, persona.personaId);
        expect(retrieved.version, persona.version);
        expect(retrieved.definitionJson, persona.definitionJson);
      });

      test('list → 未削除のみ取得', () async {
        await store.upsertPersona(PersonaEntity(
          personaId: 'p1',
          version: 1,
          definitionJson: {},
          sync: testSync,
        ));
        await store.upsertPersona(PersonaEntity(
          personaId: 'p2',
          version: 1,
          definitionJson: {},
          sync: testSync,
        ));

        await store.deletePersona('p1');

        final list = await store.listPersonas();
        expect(list.length, 1);
        expect(list.first.personaId, 'p2');
      });
    });

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
    });

    group('Crystal', () {
      test('upsert → get → 一致', () async {
        final crystal = CrystalEntity(
          crystalId: 'crystal_001',
          sessionId: 'session_001',
          summaryText: 'テスト要約',
          heatScore: 0.75,
          color: 'red',
          createdAt: '2026-01-30T12:00:00Z',
          sync: testSync,
        );

        await store.upsertCrystal(crystal);
        final retrieved = await store.getCrystal('crystal_001');

        expect(retrieved, isNotNull);
        expect(retrieved!.crystalId, crystal.crystalId);
        expect(retrieved.summaryText, crystal.summaryText);
        expect(retrieved.heatScore, crystal.heatScore);
      });
    });

    group('GuardEvent', () {
      test('upsert → get → 一致', () async {
        final event = GuardEventEntity(
          eventId: 'event_001',
          sessionId: 'session_001',
          turnIndex: 3,
          type: 'slander',
          targetSpeakerId: 'persona_002',
          action: 'warn',
          note: '誹謗中傷の可能性があります',
          sync: testSync,
        );

        await store.upsertGuardEvent(event);
        final retrieved = await store.getGuardEvent('event_001');

        expect(retrieved, isNotNull);
        expect(retrieved!.eventId, event.eventId);
        expect(retrieved.type, event.type);
        expect(retrieved.action, event.action);
      });
    });

    group('PersonaSnapshot', () {
      test('upsert → get → 一致', () async {
        final snapshot = PersonaSnapshotEntity(
          snapshotId: 'snapshot_001',
          sessionId: 'session_001',
          personaId: 'persona_001',
          personaVersion: 1,
          definitionJson: {'name': 'テストペルソナ', 'stance': 'テスト立場'},
          sync: testSync,
        );

        await store.upsertPersonaSnapshot(snapshot);
        final retrieved = await store.getPersonaSnapshot('snapshot_001');

        expect(retrieved, isNotNull);
        expect(retrieved!.snapshotId, snapshot.snapshotId);
        expect(retrieved.personaId, snapshot.personaId);
      });
    });

    test('clearAll → すべてクリア', () async {
      await store.upsertPersona(PersonaEntity(
        personaId: 'p1',
        version: 1,
        definitionJson: {},
        sync: testSync,
      ));
      await store.upsertSession(SessionEntity(
        sessionId: 's1',
        createdAt: '2026-01-30T00:00:00Z',
        theme: 'テーマ',
        participants: [],
        roundsMax: 10,
        sync: testSync,
      ));

      await store.clearAll();

      final personas = await store.listPersonas();
      final sessions = await store.listSessions();
      expect(personas.length, 0);
      expect(sessions.length, 0);
    });
  });
}
