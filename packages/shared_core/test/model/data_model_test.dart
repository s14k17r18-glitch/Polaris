import 'package:test/test.dart';
import 'package:shared_core/shared_core.dart';

void main() {
  group('データモデル（M2-E1）', () {
    // 共通の同期メタデータ（テスト用）
    final testSync = SyncMetadata(
      schemaVersion: 1,
      ownerUserId: 'test_user',
      updatedAt: '2026-01-30T00:00:00Z',
      rev: 'rev_001',
      deletedAt: null,
      deviceId: 'test_device',
    );

    group('SyncMetadata', () {
      test('toJson/fromJson ラウンドトリップ', () {
        final original = SyncMetadata(
          schemaVersion: 1,
          ownerUserId: 'user_001',
          updatedAt: '2026-01-30T12:00:00Z',
          rev: 'rev_100',
          deletedAt: null,
          deviceId: 'device_001',
        );

        final json = original.toJson();
        final restored = SyncMetadata.fromJson(json);

        expect(restored.schemaVersion, original.schemaVersion);
        expect(restored.ownerUserId, original.ownerUserId);
        expect(restored.updatedAt, original.updatedAt);
        expect(restored.rev, original.rev);
        expect(restored.deletedAt, original.deletedAt);
        expect(restored.deviceId, original.deviceId);
      });

      test('isDeleted プロパティ', () {
        final notDeleted = SyncMetadata(
          schemaVersion: 1,
          ownerUserId: 'user_001',
          updatedAt: '2026-01-30T00:00:00Z',
          rev: 'rev_001',
        );
        expect(notDeleted.isDeleted, false);

        final deleted = notDeleted.copyWith(
          deletedAt: '2026-01-31T00:00:00Z',
        );
        expect(deleted.isDeleted, true);
      });
    });

    group('PersonaEntity', () {
      test('toJson/fromJson ラウンドトリップ', () {
        final original = PersonaEntity(
          personaId: 'persona_001',
          version: 1,
          definitionJson: {'name': 'テストペルソナ', 'stance': 'テスト立場'},
          sync: testSync,
        );

        final json = original.toJson();
        final restored = PersonaEntity.fromJson(json);

        expect(restored.personaId, original.personaId);
        expect(restored.version, original.version);
        expect(restored.definitionJson, original.definitionJson);
        expect(restored.sync.ownerUserId, testSync.ownerUserId);
      });
    });

    group('PersonaSnapshotEntity', () {
      test('toJson/fromJson ラウンドトリップ', () {
        final original = PersonaSnapshotEntity(
          snapshotId: 'snapshot_001',
          sessionId: 'session_001',
          personaId: 'persona_001',
          personaVersion: 1,
          definitionJson: {'name': 'テストペルソナ', 'stance': 'テスト立場'},
          sync: testSync,
        );

        final json = original.toJson();
        final restored = PersonaSnapshotEntity.fromJson(json);

        expect(restored.snapshotId, original.snapshotId);
        expect(restored.sessionId, original.sessionId);
        expect(restored.personaId, original.personaId);
        expect(restored.personaVersion, original.personaVersion);
        expect(restored.definitionJson, original.definitionJson);
      });
    });

    group('SessionEntity', () {
      test('toJson/fromJson ラウンドトリップ', () {
        final original = SessionEntity(
          sessionId: 'session_001',
          createdAt: '2026-01-30T10:00:00Z',
          theme: 'テストテーマ',
          constraints: {'max_turns': 10},
          participants: [
            {'persona_id': 'p1', 'seat': 0},
            {'persona_id': 'p2', 'seat': 1},
          ],
          moderatorPersonaId: 'moderator_001',
          roundsMax: 20,
          endedReason: 'user_action',
          sync: testSync,
        );

        final json = original.toJson();
        final restored = SessionEntity.fromJson(json);

        expect(restored.sessionId, original.sessionId);
        expect(restored.createdAt, original.createdAt);
        expect(restored.theme, original.theme);
        expect(restored.constraints, original.constraints);
        expect(restored.participants, original.participants);
        expect(restored.moderatorPersonaId, original.moderatorPersonaId);
        expect(restored.roundsMax, original.roundsMax);
        expect(restored.endedReason, original.endedReason);
      });
    });

    group('MessageEntity', () {
      test('toJson/fromJson ラウンドトリップ', () {
        final original = MessageEntity(
          messageId: 'message_001',
          sessionId: 'session_001',
          turnIndex: 0,
          speakerType: 'persona',
          speakerId: 'persona_001',
          text: 'テストメッセージ',
          createdAt: '2026-01-30T10:00:00Z',
          tags: ['tag1', 'tag2'],
          guardFlags: {'warned': true},
          sync: testSync,
        );

        final json = original.toJson();
        final restored = MessageEntity.fromJson(json);

        expect(restored.messageId, original.messageId);
        expect(restored.sessionId, original.sessionId);
        expect(restored.turnIndex, original.turnIndex);
        expect(restored.speakerType, original.speakerType);
        expect(restored.speakerId, original.speakerId);
        expect(restored.text, original.text);
        expect(restored.createdAt, original.createdAt);
        expect(restored.tags, original.tags);
        expect(restored.guardFlags, original.guardFlags);
      });
    });

    group('GuardEventEntity', () {
      test('toJson/fromJson ラウンドトリップ', () {
        final original = GuardEventEntity(
          eventId: 'event_001',
          sessionId: 'session_001',
          turnIndex: 3,
          type: 'slander',
          targetSpeakerId: 'persona_002',
          action: 'warn',
          note: '誹謗中傷の可能性があります',
          sync: testSync,
        );

        final json = original.toJson();
        final restored = GuardEventEntity.fromJson(json);

        expect(restored.eventId, original.eventId);
        expect(restored.sessionId, original.sessionId);
        expect(restored.turnIndex, original.turnIndex);
        expect(restored.type, original.type);
        expect(restored.targetSpeakerId, original.targetSpeakerId);
        expect(restored.action, original.action);
        expect(restored.note, original.note);
      });
    });

    group('CrystalEntity', () {
      test('toJson/fromJson ラウンドトリップ', () {
        final original = CrystalEntity(
          crystalId: 'crystal_001',
          sessionId: 'session_001',
          summaryText: 'テスト要約',
          heatScore: 0.75,
          color: 'red',
          createdAt: '2026-01-30T12:00:00Z',
          sync: testSync,
        );

        final json = original.toJson();
        final restored = CrystalEntity.fromJson(json);

        expect(restored.crystalId, original.crystalId);
        expect(restored.sessionId, original.sessionId);
        expect(restored.summaryText, original.summaryText);
        expect(restored.heatScore, original.heatScore);
        expect(restored.color, original.color);
        expect(restored.createdAt, original.createdAt);
      });
    });
  });
}
