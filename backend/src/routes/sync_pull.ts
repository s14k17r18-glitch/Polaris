import type { FastifyInstance } from 'fastify';
import type { AppendOnlyStore } from '../store/append_only_store.js';

type SyncPullRequest = {
  cursor?: string | null;
  limit?: number;
};

export function registerSyncPull(
  app: FastifyInstance,
  store: AppendOnlyStore,
): void {
  app.post('/v1/sync/pull', async (request) => {
    const body = (request.body as SyncPullRequest | undefined) ?? {};
    const limitRaw = typeof body.limit === 'number' ? body.limit : 100;
    const limit = Math.max(1, Math.min(1000, limitRaw));
    const cursor = typeof body.cursor === 'string' ? body.cursor : null;

    const { changes, nextCursor } = await store.list(cursor, limit);

    return {
      next_cursor: nextCursor,
      server_time: new Date().toISOString(),
      changes,
    };
  });
}
