import express from 'express';
import { Worker } from 'node:worker_threads'


const app = express();
const PORT = 3000;

app.get('/fast', (req, res) => {
  res.json({ status: 'ok' , message: 'Respuesta rapida (Event Loop Libre)' });
});

//const PORT = process.env.PORT || 3000;


app.get('/slow-io', (req, res) => {
    setTimeout(() => {
      res.json({ message: 'I/O resultado despues de 4 seg' });
    }, 4000); // Simula un retraso de 4 segundos
});


app.get('/heavy-cpu-block', (req, res) => {
    console.time('heavy-cpu-block');
    for(let i = 0; i < 5e9; i++) {} // Simula una carga pesada de CPU
    console.timeEnd('heavy-cpu-block');
    res.json({ message: 'Heavy CPU task completed' });
});

app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});