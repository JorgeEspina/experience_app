# API de tarjetas de crédito

API REST con Express, TypeScript estricto, Prisma y PostgreSQL. Este proyecto vive separado del backend existente.

## Requisitos

- Node.js 20 o superior y npm
- Docker con Docker Compose

## Inicio local

Desde esta carpeta:

```powershell
npm install
Copy-Item .env.example .env
docker compose up -d
npm run db:generate
npm run db:migrate -- --name init
npm run db:seed
npm run dev
```

La API escucha en `http://localhost:3000`. El seed crea un usuario para probar la creación de tarjetas. En una instalación real, `userId` debe pertenecer a un usuario existente.

## Rutas

| Método | Ruta | Resultado |
| --- | --- | --- |
| GET | `/api/v1/credit-cards` | Lista tarjetas activas no eliminadas (200) |
| POST | `/api/v1/credit-cards` | Crea tarjeta (201); requiere `userId` y `creditLimit` |
| GET | `/api/v1/credit-cards/:id` | Consulta tarjeta no eliminada (200 o 404) |
| PATCH | `/api/v1/credit-cards/:id` | Actualiza `creditLimit` o `status` (200) |
| DELETE | `/api/v1/credit-cards/:id` | Borrado lógico con `deletedAt` (204) |

Los estados permitidos son `ACTIVE` y `BLOCKED`. El límite debe ser un número positivo. Los errores de validación responden 400.

## Prueba con curl

```sh
curl -X POST http://localhost:3000/api/v1/credit-cards \
  -H "Content-Type: application/json" \
  -d '{"userId":"11111111-1111-4111-8111-111111111111","creditLimit":2500}'

curl http://localhost:3000/api/v1/credit-cards
curl -X PATCH http://localhost:3000/api/v1/credit-cards/ID -H "Content-Type: application/json" -d '{"status":"BLOCKED"}'
curl -X DELETE http://localhost:3000/api/v1/credit-cards/ID
```

Reemplaza `ID` por el UUID devuelto al crear la tarjeta. Para compilar y ejecutar la versión compilada: `npm run build` y `npm start`.

## Memoria RAM (caché en memoria)

Almacén clave-valor que vive en el proceso de Node (`src/memory/memory-store.ts`). Sirve como caché rápida para no golpear la base de datos en cada request. Soporta expiración por TTL y limpieza automática de entradas vencidas. Los datos se pierden si el proceso reinicia.

Ejecutar el ejemplo:

```sh
npx tsx src/memory/example.ts
```

Uso básico:

```ts
import { MemoryStore } from "./memory/memory-store.js";

const cache = new MemoryStore<User>({ defaultTtlMs: 60_000 });

// Guardar y leer
cache.set("user:123", user);
const u = cache.get("user:123"); // undefined si no existe o si expiro

// Patron cache-aside: si no esta en cache, lo carga y lo guarda
const user = await cache.getOrSet("user:123", () => prisma.user.findUnique({ where: { id: "123" } }));
```

Opciones del constructor:

| Opción | Por defecto | Descripción |
| --- | --- | --- |
| `defaultTtlMs` | `0` (sin expiración) | TTL en ms aplicado a cada `set()` |
| `cleanupIntervalMs` | `60000` | Cada cuánto se barren las entradas vencidas |

Métodos: `set(key, value, ttlMs?)`, `get(key)`, `has(key)`, `delete(key)`, `clear()`, `getOrSet(key, loader, ttlMs?)`, `size`, `dispose()`.

Llama a `dispose()` al apagar la app para liberar el timer de limpieza.

## Colas y prioridad

Dos piezas en `src/queues/`:

- `priority-queue.ts`: cola de prioridad genérica basada en min-heap binario (`enqueue`/`dequeue` en O(log n)). Menor número de prioridad = más urgente. Ante igual prioridad respeta el orden de llegada.
- `task-queue.ts`: cola de tareas asíncronas sobre la anterior, con concurrencia configurable. Pensada para trabajo en segundo plano dentro del mismo proceso (ej. enviar una notificación tras responder un request).

Ejecutar el ejemplo:

```sh
npx tsx src/queues/example.ts
```

Cola de prioridad:

```ts
import { PriorityQueue } from "./queues/priority-queue.js";

const pq = new PriorityQueue<string>();
pq.enqueue("tarea normal", 10);
pq.enqueue("tarea urgente", 1); // sale primero

while (!pq.isEmpty()) {
  console.log(pq.dequeue());
}
```

Cola de tareas:

```ts
import { TaskQueue } from "./queues/task-queue.js";

const queue = new TaskQueue({ concurrency: 2 }); // 2 tareas en paralelo

// add(tarea, prioridad). Devuelve una promesa con el resultado de la tarea.
const result = await queue.add(async () => {
  return await enviarNotificacion();
}, 1); // prioridad 1 = más urgente

console.log(queue.pending); // tareas en espera
console.log(queue.running); // tareas ejecutándose
```

Para trabajo que deba sobrevivir reinicios o escalar entre varias instancias, conviene una cola externa (Redis con BullMQ, SQS). Estas piezas son para procesamiento en memoria del propio proceso.

### Worker de tareas en segundo plano

`TaskQueue` funciona como un worker in-process: procesa tareas asíncronas respetando la prioridad y la concurrencia, sin bloquear el hilo que atiende los requests. El patrón típico es responder al cliente de inmediato y dejar el trabajo pesado encolado.

```ts
import { TaskQueue } from "./queues/task-queue.js";

// Un único worker compartido para toda la app.
export const backgroundWorker = new TaskQueue({ concurrency: 4 });

// Dentro de un handler de Express:
app.post(basePath, asyncHandler(async (request, response) => {
  const card = await prisma.creditCard.create({ data: input.data });

  // Respondemos ya; la notificación se procesa en segundo plano.
  response.status(201).json(card);

  backgroundWorker.add(async () => {
    await enviarNotificacion(card.userId);
  }, 5); // prioridad 5
}));
```

Límites: este worker vive dentro del proceso de Node. Si el proceso reinicia, las tareas pendientes se pierden. Para garantías de entrega, reintentos y persistencia, usar una cola externa (Redis con BullMQ, SQS).

## Node scaling (varios núcleos)

Node corre tu código en un solo hilo, así que por defecto una instancia usa un único núcleo de CPU. Para aprovechar todos los núcleos de la máquina se levanta un proceso por núcleo con el módulo `cluster` (`src/scaling/cluster.ts`). El proceso primario reparte las conexiones entrantes entre los workers y reinicia cualquiera que se caiga.

Ejecutar en modo cluster:

```sh
# un worker por núcleo disponible
npx tsx src/scaling/cluster.ts

# o fijando la cantidad de procesos
WEB_CONCURRENCY=4 npx tsx src/scaling/cluster.ts
```

Todos los workers escuchan el mismo puerto (`3000`); el SO reparte las conexiones entre ellos.

Consideraciones:

- El estado en memoria no se comparte entre workers. Cada proceso tiene su propio `MemoryStore` y su propio `TaskQueue`. Si necesitas caché o colas compartidas entre workers, usa un backend externo (Redis).
- `cluster` sirve para escalar E/S (atender más requests en paralelo). Para trabajo que satura la CPU dentro de un request, conviene `worker_threads`.
- En producción es común delegar este escalado al orquestador (varias réplicas del contenedor en Docker/Kubernetes) en lugar de usar `cluster` dentro del contenedor. Elige una de las dos estrategias, no ambas a la vez.

| Mecanismo | Para qué sirve |
| --- | --- |
| `cluster` | Varios procesos atendiendo requests, un núcleo cada uno |
| `worker_threads` | Descargar tareas que consumen mucha CPU fuera del hilo principal |
| Réplicas (Docker/K8s) | Escalar horizontalmente a nivel de contenedor |
