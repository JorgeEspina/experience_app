const {
  parentPort,
  workerData
} = require('node:worker_threads');

function sumTo(n) {
  let sum = 0;

  for (let i = 1; i <= n; i++) {
    sum += i;
  }

  return sum;
}

try {
  const result = sumTo(workerData.limit);

  parentPort.postMessage({
    success: true,
    result
  });
} catch (error) {
  parentPort.postMessage({
    success: false,
    error: error.message
  });
}