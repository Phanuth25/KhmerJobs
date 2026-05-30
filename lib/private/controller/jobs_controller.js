const express = require('express');
const router = express.Router();
const db = require('../model/db_model');

router.use(express.json());

router.get('/jobs', async (req, res) => {

    try {
        const sql = "SELECT jobs.*, companies.name AS company_name FROM jobs INNER JOIN companies ON jobs.company_id = companies.id";

        db.query(sql,(err, results) => {
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