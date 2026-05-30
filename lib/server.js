require('dotenv').config();
const express = require('express');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000;

const registerRouter = require('./private/controller/register_controller');
const loginRouter = require('./private/controller/login_controller');
const jobsRouter = require('./private/controller/jobs_controller');
const candidatesRouter = require('./private/controller/candidates_controller');
// Middleware to parse JSON data sent to the server
app.use(express.json());
app.use(cors());

// A simple test route
app.get('/', (req, res) => {
    res.send('KhmerJobs API is running successfully!');
});

app.use('/api', registerRouter);
app.use('/api', loginRouter);
app.use('/api', jobsRouter);
app.use('/api', candidatesRouter);

// Start the server
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});