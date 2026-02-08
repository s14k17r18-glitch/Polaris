// Sync API models (contracts/openapi.yaml 準拠)

class SyncChange {
  const SyncChange({
    required this.entity,
    required this.op,
    required this.id,
    required this.rev,
    required this.updatedAt,
    this.deletedAt,
    this.payload = const {},
  });

  final String entity;
  final String op;
  final String id;
  final Object rev;
  final String updatedAt;
  final String? deletedAt;
  final Map<String, dynamic> payload;

  factory SyncChange.fromJson(Map<String, dynamic> json) {
    return SyncChange(
      entity: json['entity'] as String,
      op: json['op'] as String,
      id: json['id'] as String,
      rev: json['rev'] as Object,
      updatedAt: json['updated_at'] as String,
      deletedAt: json['deleted_at'] as String?,
      payload: (json['payload'] as Map<String, dynamic>?) ?? const {},
    );
  }
}

class SyncPullResponse {
  const SyncPullResponse({
    required this.nextCursor,
    required this.serverTime,
    required this.changes,
  });

  final String? nextCursor;
  final String serverTime;
  final List<SyncChange> changes;

  factory SyncPullResponse.fromJson(Map<String, dynamic> json) {
    final changes = (json['changes'] as List<dynamic>? ?? [])
        .map((e) => SyncChange.fromJson(e as Map<String, dynamic>))
        .toList();
    return SyncPullResponse(
      nextCursor: json['next_cursor'] as String?,
      serverTime: json['server_time'] as String,
      changes: changes,
    );
  }
}

class SyncMutation {
  const SyncMutation({
    required this.entity,
    required this.op,
    required this.id,
    this.baseRev,
    required this.updatedAt,
    this.deletedAt,
    this.payload = const {},
  });

  final String entity;
  final String op;
  final String id;
  final Object? baseRev;
  final String updatedAt;
  final String? deletedAt;
  final Map<String, dynamic> payload;

  Map<String, dynamic> toJson() {
    return {
      'entity': entity,
      'op': op,
      'id': id,
      'base_rev': baseRev,
      'updated_at': updatedAt,
      'deleted_at': deletedAt,
      'payload': payload,
    };
  }
}

class SyncAccepted {
  const SyncAccepted({
    required this.entity,
    required this.id,
    required this.rev,
    required this.updatedAt,
  });

  final String entity;
  final String id;
  final Object rev;
  final String updatedAt;

  factory SyncAccepted.fromJson(Map<String, dynamic> json) {
    return SyncAccepted(
      entity: json['entity'] as String,
      id: json['id'] as String,
      rev: json['rev'] as Object,
      updatedAt: json['updated_at'] as String,
    );
  }
}

class SyncConflict {
  const SyncConflict({
    required this.entity,
    required this.id,
    required this.reason,
    this.serverRecord,
    this.clientRecord,
  });

  final String entity;
  final String id;
  final String reason;
  final Map<String, dynamic>? serverRecord;
  final Map<String, dynamic>? clientRecord;

  factory SyncConflict.fromJson(Map<String, dynamic> json) {
    return SyncConflict(
      entity: json['entity'] as String,
      id: json['id'] as String,
      reason: json['reason'] as String,
      serverRecord: json['server_record'] as Map<String, dynamic>?,
      clientRecord: json['client_record'] as Map<String, dynamic>?,
    );
  }
}

class SyncPushResponse {
  const SyncPushResponse({
    required this.accepted,
    required this.conflicts,
  });

  final List<SyncAccepted> accepted;
  final List<SyncConflict> conflicts;

  factory SyncPushResponse.fromJson(Map<String, dynamic> json) {
    final accepted = (json['accepted'] as List<dynamic>? ?? [])
        .map((e) => SyncAccepted.fromJson(e as Map<String, dynamic>))
        .toList();
    final conflicts = (json['conflicts'] as List<dynamic>? ?? [])
        .map((e) => SyncConflict.fromJson(e as Map<String, dynamic>))
        .toList();
    return SyncPushResponse(accepted: accepted, conflicts: conflicts);
  }
}
