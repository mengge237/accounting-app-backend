const express = require('express');
const { promisePool } = require('../config/database');
const { authenticateToken } = require('../middleware/auth');

const router = express.Router();

// 获取背景设置
router.get('/', authenticateToken, async (req, res) => {
    const userId = req.userId;
    
    try {
        const [settings] = await promisePool.execute(
            'SELECT id, bg_type, bg_value, is_active, updated_at FROM background_settings WHERE user_id = ? AND is_active = 1',
            [userId]
        );
        
        const setting = settings.length > 0 ? settings[0] : {
            bg_type: 'color',
            bg_value: '#F5F5F5',
            is_active: 1
        };
        
        res.json({ success: true, background: setting });
    } catch (error) {
        console.error('查询背景设置错误:', error);
        res.status(500).json({ success: false, message: '数据库错误' });
    }
});

// 保存背景设置
router.post('/', authenticateToken, async (req, res) => {
    const userId = req.userId;
    const { bg_type, bg_value } = req.body;
    
    if (!bg_type || !bg_value) {
        return res.status(400).json({ success: false, message: '背景类型和值不能为空' });
    }
    
    try {
        await promisePool.execute('UPDATE background_settings SET is_active = 0 WHERE user_id = ?', [userId]);
        
        const [result] = await promisePool.execute(
            'INSERT INTO background_settings (user_id, bg_type, bg_value, is_active) VALUES (?, ?, ?, 1)',
            [userId, bg_type, bg_value]
        );
        
        res.json({ success: true, message: '保存成功', settingId: result.insertId });
    } catch (error) {
        console.error('保存背景设置错误:', error);
        res.status(500).json({ success: false, message: '保存失败' });
    }
});

module.exports = router;