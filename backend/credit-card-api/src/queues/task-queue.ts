import { PriorityQueue } from "./priority-queue.js";

export type Task<R> = () => Promise<R>;

interface QueuedTask {
  run: Task<unknown>;
  resolve: (value: unknown) => void;
  reject: (reason: unknown) => void;
}

export interface TaskQueueOptions {
  concurrency?: number;
}

export class TaskQueue {
  private readonly queue = new PriorityQueue<QueuedTask>();
  private readonly concurrency: number;
  private active = 0;

  constructor(options: TaskQueueOptions = {}) {
    this.concurrency = Math.max(1, options.concurrency ?? 1);
  }

  get pending(): number {
    return this.queue.size;
  }

  get running(): number {
    return this.active;
  }

  add<R>(task: Task<R>, priority = 10): Promise<R> {
    return new Promise<R>((resolve, reject) => {
      this.queue.enqueue(
        {
          run: task as Task<unknown>,
          resolve: resolve as (value: unknown) => void,
          reject,
        },
        priority,
      );
      this.drain();
    });
  }

  private drain(): void {
    while (this.active < this.concurrency && !this.queue.isEmpty()) {
      const task = this.queue.dequeue()!;
      this.active++;
      void this.execute(task);
    }
  }

  private async execute(task: QueuedTask): Promise<void> {
    try {
      const result = await task.run();
      task.resolve(result);
    } catch (error) {
      task.reject(error);
    } finally {
      this.active--;
      this.drain();
    }
  }
}
