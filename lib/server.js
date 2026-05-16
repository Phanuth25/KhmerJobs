const express = require('express');
const app = express();
const PORT = process.env.PORT || 5000;

// Middleware to parse JSON data sent to the server
app.use(express.json());

// A simple test route
app.get('/', (req, res) => {
    res.send('KhmerJobs API is running successfully!');
});

// Start the server
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});