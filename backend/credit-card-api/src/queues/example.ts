import { PriorityQueue } from "./priority-queue.js";
import { TaskQueue } from "./task-queue.js";

function demoPriorityQueue() {
  console.log("=== PriorityQueue ===");
  const pq = new PriorityQueue<string>();

  pq.enqueue("enviar email de bienvenida", 10);
  pq.enqueue("procesar pago urgente", 1);
  pq.enqueue("generar reporte nocturno", 20);
  pq.enqueue("alerta de fraude", 1);

  while (!pq.isEmpty()) {
    console.log("->", pq.dequeue());
  }
}

async function demoTaskQueue() {
  console.log("\n=== TaskQueue (concurrencia 2) ===");

  const job = (name: string, ms: number) => async () => {
    console.log(`[inicia] ${name}`);
    await new Promise((resolve) => setTimeout(resolve, ms));
    console.log(`[termina] ${name}`);
    return name;
  };

  const queue = new TaskQueue({ concurrency: 2 });

  const results = Promise.all([
    queue.add(job("baja-A", 200), 20),
    queue.add(job("baja-B", 200), 20),
    queue.add(job("alta-1", 100), 1),
    queue.add(job("media", 100), 10),
  ]);

  console.log(`pendientes: ${queue.pending}, ejecutandose: ${queue.running}`);

  const done = await results;
  console.log("resultados:", done);
}

async function main() {
  demoPriorityQueue();
  await demoTaskQueue();
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
