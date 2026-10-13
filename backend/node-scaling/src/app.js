const express = require('express');
const healthRoutes = require('./routes/health.routes');

const app = express();

app.disable('x-powered-by');
app.use(express.json({ limit: '1mb' }));

app.use('/health', healthRoutes);

app.use((req, res) => {
  res.status(404).json({
    error: 'Not found'
  });
});

module.exports = app;