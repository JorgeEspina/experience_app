const port = Number(process.env.PORT ?? 3000);
const workers = Number(process.env.WORKERS ?? 2);

if (!Number.isInteger(port) || port < 1 || port > 65535) {
  throw new Error('PORT must be a valid port');
}

if (!Number.isInteger(workers) || workers < 1) {
  throw new Error('WORKERS must be a positive integer');
}

module.exports = {
  port,
  host: process.env.HOST ?? '0.0.0.0',
  workers,
  nodeEnv: process.env.NODE_ENV ?? 'development'
};