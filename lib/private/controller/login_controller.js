const express = require('express');
const router = express.Router();
const db = require('../model/db_model');
const jwt = require('jsonwebtoken');

router.use(express.json());

const ACCESS_SECRET = process.env.ACCESS_SECRET || 'access_secret_key';
const REFRESH_SECRET = process.env.REFRESH_SECRET || 'refresh_secret_key';

// ─── LOGIN ──────────────────────────────────────────────
router.post('/login', (req, res) => {
    const { email, password } = req.body;

    if (!email || !password) {
        return res.status(400).json({ error: "Email and password are required" });
    }

    const sql = "SELECT * FROM users WHERE email = ?";

    db.query(sql, [email], (err, results) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }

        if (results.length === 0) {
            return res.status(404).json({ error: "User not found" });
        }

        const user = results[0];

        if (password !== user.password) {
            return res.status(401).json({ error: "Invalid password" });
        }

        // Generate tokens
        const accessToken = jwt.sign(
            { id: user.id, role: user.position },
            ACCESS_SECRET,
            { expiresIn: '15m' }
        );

        const refreshToken = jwt.sign(
            { id: user.id, role: user.position },
            REFRESH_SECRET,
            { expiresIn: '7d' }
        );

        // Save refresh token to DB
        const updateSql = "UPDATE users SET refresh_token = ? WHERE id = ?";

        db.query(updateSql, [refreshToken, user.id], (err) => {
            if (err) {
                return res.status(500).json({ error: err.message });
            }

            res.status(200).json({
                success: true,
                message: "Login successful",
                token: accessToken,
                refreshtoken: refreshToken,
                userid: user.id,
                role: user.position,
                name: user.name
            });
        });
    });
});

// ─── REFRESH TOKEN ──────────────────────────────────────
router.post('/refresh', (req, res) => {
    const { refreshtoken } = req.body;

    if (!refreshtoken) {
        return res.status(401).json({ error: "Refresh token required" });
    }

    // Check if refresh token exists in DB
    const sql = "SELECT * FROM users WHERE refresh_token = ?";

    db.query(sql, [refreshtoken], (err, results) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }

        if (results.length === 0) {
            return res.status(403).json({ error: "Invalid refresh token" });
        }

        // Verify the refresh token
        jwt.verify(refreshtoken, REFRESH_SECRET, (err, decoded) => {
            if (err) {
                return res.status(403).json({ error: "Refresh token expired, please login again" });
            }

            const user = results[0];

            // Generate new access token
            const newAccessToken = jwt.sign(
                { id: user.id, role: user.position },
                ACCESS_SECRET,
                { expiresIn: '15m' }
            );

            res.status(200).json({
                success: true,
                token: newAccessToken,
            });
        });
    });
});

module.exports = router;