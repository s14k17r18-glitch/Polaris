import Fastify from 'fastify';
import path from 'node:path';
import { AppendOnlyStore } from './store/append_only_store.js';
import { registerHealth } from './routes/health.js';
import { registerSyncPush } from './routes/sync_push.js';
import { registerSyncPull } from './routes/sync_pull.js';

const app = Fastify({ logger: true });
const store = new AppendOnlyStore(path.resolve(process.cwd(), '.data'));

registerHealth(app);
registerSyncPush(app, store);
registerSyncPull(app, store);

const port = Number(process.env.PORT ?? 8080);
const host = process.env.HOST ?? '0.0.0.0';

app
  .listen({ port, host })
  .then(() => {
    app.log.info(`listening on ${host}:${port}`);
  })
  .catch((error) => {
    app.log.error(error);
    process.exit(1);
  });
