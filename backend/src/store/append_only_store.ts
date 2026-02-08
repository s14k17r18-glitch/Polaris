import { promises as fs } from 'node:fs';
import path from 'node:path';

export type SyncChange = {
  entity: string;
  op: string;
  id: string;
  rev: string | number;
  updated_at: string;
  deleted_at?: string | null;
  payload?: Record<string, unknown>;
};

export class AppendOnlyStore {
  constructor(private readonly baseDir: string) {}

  private filePath(): string {
    return path.join(this.baseDir, 'changes.jsonl');
  }

  private async ensureDir(): Promise<void> {
    await fs.mkdir(this.baseDir, { recursive: true });
  }

  async append(change: SyncChange): Promise<void> {
    await this.ensureDir();
    const record: SyncChange = {
      ...change,
      deleted_at: change.deleted_at ?? null,
      payload: change.payload ?? {},
    };
    await fs.appendFile(this.filePath(), `${JSON.stringify(record)}\n`);
  }

  async list(
    cursor: string | null | undefined,
    limit: number,
  ): Promise<{ changes: SyncChange[]; nextCursor: string | null }> {
    await this.ensureDir();
    let raw = '';
    try {
      raw = await fs.readFile(this.filePath(), 'utf8');
    } catch (error) {
      const err = error as NodeJS.ErrnoException;
      if (err.code === 'ENOENT') {
        return { changes: [], nextCursor: null };
      }
      throw err;
    }

    const lines = raw.split('\n').filter((line) => line.trim().length > 0);
    const start = Number.parseInt(cursor ?? '0', 10);
    const safeStart = Number.isFinite(start) && start >= 0 ? start : 0;

    const slice = lines
      .slice(safeStart, safeStart + limit)
      .map((line) => JSON.parse(line) as SyncChange);

    const nextCursor =
      safeStart + slice.length < lines.length
        ? String(safeStart + slice.length)
        : null;

    return { changes: slice, nextCursor };
  }
}
