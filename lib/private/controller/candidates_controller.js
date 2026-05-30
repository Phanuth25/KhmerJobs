const express = require('express');
const router = express.Router();
const db = require('../model/db_model');

router.use(express.json());

router.post('/candidates', async (req, res) => {
    const { user_id, bio, skills, cv_url, location } = req.body;
    try {
        const sql = "Insert into candidates (user_id,bio,skills,cv_url,location) values (?,?,?,?,?)";

        db.query(sql,[user_id,bio,skills,cv_url,location],(err, results) => {
            if (err) {
                return res.status(500).json({ error: err.message });
            }

            res.status(200).json({
                success: true,
                data: results,
            });
       });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

module.exports = router;