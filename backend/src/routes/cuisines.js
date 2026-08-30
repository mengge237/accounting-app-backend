const express = require('express');
const { promisePool } = require('../config/database');
const { authenticateToken } = require('../middleware/auth');

const router = express.Router();

// 获取菜系列表
router.get('/', authenticateToken, async (req, res) => {
    try {
        const [cuisines] = await promisePool.execute(`
            SELECT id, name, description, sort_order 
            FROM cuisines 
            WHERE is_active = 1 
            ORDER BY sort_order
        `);
        
        res.json({ success: true, cuisines });
    } catch (error) {
        console.error('查询菜系错误:', error);
        res.status(500).json({ success: false, message: '数据库错误' });
    }
});

module.exports = router;