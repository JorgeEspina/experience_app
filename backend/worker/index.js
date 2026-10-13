const { Worker } = require('node:worker_threads');

const worker = new Worker('./worker.js');

worker.on('message', (result) => {
  console.log('Resultado:', result);
});

worker.on('error', (error) => {
  console.error('Error del worker:', error);
});

worker.postMessage('Hola desde Node.js');