interface MemoryEntry<T> {
  value: T;
  expiresAt: number | null;
}

export interface MemoryStoreOptions {
  defaultTtlMs?: number;
  cleanupIntervalMs?: number;
}

export class MemoryStore<T = unknown> {
  private readonly store = new Map<string, MemoryEntry<T>>();
  private readonly defaultTtlMs: number;
  private readonly cleanupTimer: NodeJS.Timeout;

  constructor(options: MemoryStoreOptions = {}) {
    this.defaultTtlMs = options.defaultTtlMs ?? 0;
    const interval = options.cleanupIntervalMs ?? 60_000;
    this.cleanupTimer = setInterval(() => this.cleanup(), interval);
    this.cleanupTimer.unref();
  }

  set(key: string, value: T, ttlMs?: number): void {
    const effectiveTtl = ttlMs ?? this.defaultTtlMs;
    const expiresAt = effectiveTtl > 0 ? Date.now() + effectiveTtl : null;
    this.store.set(key, { value, expiresAt });
  }

  get(key: string): T | undefined {
    const entry = this.store.get(key);
    if (!entry) return undefined;

    if (this.isExpired(entry)) {
      this.store.delete(key);
      return undefined;
    }
    return entry.value;
  }

  has(key: string): boolean {
    return this.get(key) !== undefined;
  }

  delete(key: string): boolean {
    return this.store.delete(key);
  }

  clear(): void {
    this.store.clear();
  }

  get size(): number {
    this.cleanup();
    return this.store.size;
  }

  async getOrSet(key: string, loader: () => Promise<T>, ttlMs?: number): Promise<T> {
    const cached = this.get(key);
    if (cached !== undefined) return cached;

    const value = await loader();
    this.set(key, value, ttlMs);
    return value;
  }

  dispose(): void {
    clearInterval(this.cleanupTimer);
    this.store.clear();
  }

  private isExpired(entry: MemoryEntry<T>): boolean {
    return entry.expiresAt !== null && entry.expiresAt <= Date.now();
  }

  private cleanup(): void {
    const now = Date.now();
    for (const [key, entry] of this.store) {
      if (entry.expiresAt !== null && entry.expiresAt <= now) {
        this.store.delete(key);
      }
    }
  }
}
