import { MemoryStore } from "./memory-store.js";

async function fetchUserFromDb(userId: string): Promise<{ id: string; name: string }> {
  console.log(`[DB] consultando usuario ${userId}`);
  await new Promise((resolve) => setTimeout(resolve, 300));
  return { id: userId, name: "Usuario " + userId };
}

async function main() {
  const cache = new MemoryStore<{ id: string; name: string }>({ defaultTtlMs: 2_000 });

  const a = await cache.getOrSet("user:123", () => fetchUserFromDb("123"));
  console.log("1) primera llamada:", a);

  const b = await cache.getOrSet("user:123", () => fetchUserFromDb("123"));
  console.log("2) segunda llamada (desde cache):", b);

  await new Promise((resolve) => setTimeout(resolve, 2_100));

  const c = await cache.getOrSet("user:123", () => fetchUserFromDb("123"));
  console.log("3) tercera llamada (expiro el ttl):", c);

  cache.set("session:abc", { id: "abc", name: "token" }, 5_000);
  console.log("4) has session:abc:", cache.has("session:abc"));
  cache.delete("session:abc");
  console.log("5) has session:abc tras delete:", cache.has("session:abc"));

  cache.dispose();
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
