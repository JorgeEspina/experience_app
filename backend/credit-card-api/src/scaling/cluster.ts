import cluster from "node:cluster";
import { availableParallelism } from "node:os";
import process from "node:process";

const workers = Number(process.env.WEB_CONCURRENCY ?? availableParallelism());

if (cluster.isPrimary) {
  console.log(`[primary] pid ${process.pid}, levantando ${workers} workers`);

  for (let i = 0; i < workers; i++) {
    cluster.fork();
  }

  cluster.on("exit", (worker, code, signal) => {
    console.log(`[primary] worker ${worker.process.pid} murio (code=${code}, signal=${signal}), reiniciando`);
    cluster.fork();
  });
} else {
  await import("../index.js");
  console.log(`[worker] pid ${process.pid} atendiendo requests`);
}
