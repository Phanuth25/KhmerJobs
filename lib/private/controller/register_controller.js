const express = require('express');
const router = express.Router();
const db = require('../model/db_model');

router.use(express.json());

router.post('/register', async (req, res) => {
    const { name, email, password, phone, position } = req.body;

    // 1. Validation
    if (!name || !email || !password || !phone || !position) {
        return res.status(400).json({ error: "Everything are required fields" });
    }

    try {

        // 3. Database Query (Must be inside the try block or use the imageUrl here)
        const sql = "INSERT INTO users (name, email, password, phone, role ) VALUES (?, ?, ?, ?, ?)";

       await db.query(sql, [name, email, password, phone, position], (err, results) => {
            if (err) {
                return res.status(500).json({ error: err.message });
            }

            res.status(200).json({
                success: true,
                message: "Registered successfully",
                userid: results.insertId
            });
       });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

module.exports = router;