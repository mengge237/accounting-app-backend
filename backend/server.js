const express = require('express');
const cors = require('cors');
require('dotenv').config();

const app = express();

app.use(cors());
app.use(express.json());

const authRoutes = require('./src/routes/auth');
const recipeRoutes = require('./src/routes/recipes');
const cuisineRoutes = require('./src/routes/cuisines');
const recordRoutes = require('./src/routes/records');
const statisticRoutes = require('./src/routes/statistics');
const backgroundRoutes = require('./src/routes/background');
const scheduleRoutes = require('./src/routes/schedules');
const ledgerRoutes = require('./src/routes/ledgers');

app.use('/api', authRoutes);
app.use('/api/recipes', recipeRoutes);
app.use('/api/cuisines', cuisineRoutes);
app.use('/api/records', recordRoutes);
app.use('/api/statistics', statisticRoutes);
app.use('/api/background', backgroundRoutes);
app.use('/api/schedules', scheduleRoutes);
app.use('/api/ledgers', ledgerRoutes);

app.get('/', (req, res) => {
    res.json({ message: '服务器运行正常！' });
});

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
    console.log(`========================================`);
    console.log(`🚀 服务器运行在 http://localhost:${PORT}`);
    console.log(`========================================`);
});