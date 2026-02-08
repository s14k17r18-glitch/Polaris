import type { FastifyInstance } from 'fastify';
import type { AppendOnlyStore } from '../store/append_only_store.js';

type SyncMutation = {
  entity: string;
  op: string;
  id: string;
  base_rev?: string | number | null;
  updated_at: string;
  deleted_at?: string | null;
  payload?: Record<string, unknown>;
};

type SyncPushRequest = {
  client_time: string;
  mutations: SyncMutation[];
};

export function registerSyncPush(
  app: FastifyInstance,
  store: AppendOnlyStore,
): void {
  app.post('/v1/sync/push', async (request, reply) => {
    const body = request.body as Partial<SyncPushRequest> | undefined;

    if (!body || typeof body.client_time !== 'string') {
      reply.code(400);
      return { error: '不正なリクエスト' };
    }

    if (!Array.isArray(body.mutations)) {
      reply.code(400);
      return { error: 'mutations が不正です' };
    }

    const now = new Date().toISOString();
    const accepted: Array<{ entity: string; id: string; rev: string; updated_at: string }> = [];

    for (let index = 0; index < body.mutations.length; index += 1) {
      const mutation = body.mutations[index];
      if (
        !mutation ||
        typeof mutation.entity !== 'string' ||
        typeof mutation.op !== 'string' ||
        typeof mutation.id !== 'string' ||
        typeof mutation.updated_at !== 'string'
      ) {
        reply.code(400);
        return { error: 'mutations の必須項目が不足しています' };
      }

      const updatedAt = mutation.updated_at;
      const rev = `${Date.now()}-${index}`;
      const deletedAt =
        mutation.op === 'delete'
          ? mutation.deleted_at ?? updatedAt
          : mutation.deleted_at ?? null;

      await store.append({
        entity: mutation.entity,
        op: mutation.op,
        id: mutation.id,
        rev,
        updated_at: updatedAt,
        deleted_at: deletedAt,
        payload: mutation.payload ?? {},
      });

      accepted.push({
        entity: mutation.entity,
        id: mutation.id,
        rev,
        updated_at: updatedAt,
      });
    }

    return { accepted, conflicts: [] };
  });
}
