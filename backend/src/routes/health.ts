import type { FastifyInstance } from 'fastify';

export function registerHealth(app: FastifyInstance): void {
  app.get('/v1/health', async () => {
    return {
      status: 'ok',
      version: '2026.02.08',
      now: new Date().toISOString(),
    };
  });
}
