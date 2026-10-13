const { parentPort } = require('node:worker_threads');

parentPort.on('message', (message) => {
  console.log('Worker recibió:', message);

  parentPort.postMessage({
    success: true,
    result: `Procesado: ${message}`
  });
});