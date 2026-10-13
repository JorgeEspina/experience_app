const app = require('./app');
const config = require('./config/env');

const server = app.listen(config.port, config.host, () => {
  console.log(
    `API listening on ${config.host}:${config.port}; PID=${process.pid}`
  );
});

let shuttingDown = false;

function shutdown(signal) {
  if (shuttingDown) return;
  shuttingDown = true;

  console.log(`${signal}: shutting down`);

  server.close((error) => {
    if (error) {
      console.error('Error closing server:', error);
      process.exitCode = 1;
    }
  });

  setTimeout(() => {
    console.error('Graceful shutdown timed out');
    process.exit(1);
  }, 10000).unref();
}

process.on('SIGTERM', () => shutdown('SIGTERM'));
process.on('SIGINT', () => shutdown('SIGINT'));

server.on('error', (error) => {
  console.error('Server error:', error);
  process.exitCode = 1;
});