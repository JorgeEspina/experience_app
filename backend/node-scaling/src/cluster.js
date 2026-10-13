const cluster = require('node:cluster');
const config = require('./config/env');

if (cluster.isPrimary) {
  const workers = new Map();

  function startWorker() {
    const worker = cluster.fork();
    workers.set(worker.id, worker);
  }

  for (let i = 0; i < config.workers; i++) {
    startWorker();
  }

  cluster.on('exit', (worker, code, signal) => {
    workers.delete(worker.id);

    console.error(
      `Worker ${worker.process.pid} exited: code=${code}, signal=${signal}`
    );

    if (!cluster.isPrimary || process.exitCode !== undefined) {
      return;
    }

    setTimeout(startWorker, 1000);
  });

  function shutdown(signal) {
    console.log(`${signal}: stopping workers`);

    for (const worker of workers.values()) {
      worker.process.kill('SIGTERM');
    }

    setTimeout(() => {
      for (const worker of Object.values(cluster.workers ?? {})) {
        worker?.process.kill('SIGKILL');
      }
    }, 12000).unref();
  }

  process.on('SIGTERM', () => shutdown('SIGTERM'));
  process.on('SIGINT', () => shutdown('SIGINT'));
} else {
  require('./server');
}