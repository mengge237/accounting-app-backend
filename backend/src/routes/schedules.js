const express = require('express');
const { promisePool } = require('../config/database');
const { authenticateToken } = require('../middleware/auth');

const router = express.Router();

// 获取日程列表
router.get('/', authenticateToken, async (req, res) => {
    const userId = req.userId;
    const { start_date, end_date } = req.query;
    
    try {
        let sql = 'SELECT * FROM schedules WHERE user_id = ?';
        const params = [userId];
        
        if (start_date && end_date) {
            sql += ' AND scheduled_date BETWEEN ? AND ?';
            params.push(start_date, end_date);
        }
        
        sql += ' ORDER BY scheduled_date ASC, priority DESC, scheduled_time ASC';
        
        const [schedules] = await promisePool.execute(sql, params);
        res.json({ success: true, schedules });
    } catch (error) {
        console.error('查询日程错误:', error);
        res.status(500).json({ success: false, message: '数据库错误' });
    }
});

// 添加日程
router.post('/', authenticateToken, async (req, res) => {
    const userId = req.userId;
    const { title, type, content, related_id, scheduled_date, scheduled_time, priority, reminder_minutes, repeat_type, note } = req.body;
    
    if (!title || !scheduled_date) {
        return res.status(400).json({ success: false, message: '标题和日期不能为空' });
    }
    
    try {
        const [result] = await promisePool.execute(`
            INSERT INTO schedules 
            (user_id, title, type, content, related_id, scheduled_date, scheduled_time, priority, reminder_minutes, repeat_type, note, is_completed) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0)
        `, [userId, title, type || 'event', content || null, related_id || null, scheduled_date, scheduled_time || null, priority || 1, reminder_minutes || null, repeat_type || 'none', note || null]);
        
        res.json({ success: true, message: '添加成功', scheduleId: result.insertId });
    } catch (error) {
        console.error('添加日程错误:', error);
        res.status(500).json({ success: false, message: '添加失败' });
    }
});

// 更新日程状态
router.put('/:id/status', authenticateToken, async (req, res) => {
    const userId = req.userId;
    const scheduleId = req.params.id;
    const { is_completed } = req.body;
    
    try {
        await promisePool.execute(
            'UPDATE schedules SET is_completed = ? WHERE id = ? AND user_id = ?',
            [is_completed ? 1 : 0, scheduleId, userId]
        );
        res.json({ success: true, message: '更新成功' });
    } catch (error) {
        console.error('更新日程状态错误:', error);
        res.status(500).json({ success: false, message: '更新失败' });
    }
});

// 更新日程
router.put('/:id', authenticateToken, async (req, res) => {
    const userId = req.userId;
    const scheduleId = req.params.id;
    const { title, type, content, scheduled_date, scheduled_time, priority, note } = req.body;
    
    try {
        await promisePool.execute(`
            UPDATE schedules 
            SET title = ?, type = ?, content = ?, scheduled_date = ?, scheduled_time = ?, priority = ?, note = ?
            WHERE id = ? AND user_id = ?
        `, [title, type || 'event', content || null, scheduled_date, scheduled_time || null, priority || 1, note || null, scheduleId, userId]);
        
        res.json({ success: true, message: '更新成功' });
    } catch (error) {
        console.error('更新日程错误:', error);
        res.status(500).json({ success: false, message: '更新失败' });
    }
});

// 删除日程
router.delete('/:id', authenticateToken, async (req, res) => {
    const userId = req.userId;
    const scheduleId = req.params.id;
    
    try {
        const [result] = await promisePool.execute(
            'DELETE FROM schedules WHERE id = ? AND user_id = ?',
            [scheduleId, userId]
        );
        
        res.json({ success: true, message: '删除成功' });
    } catch (error) {
        console.error('删除日程错误:', error);
        res.status(500).json({ success: false, message: '删除失败' });
    }
});

module.exports = router;