const express = require('express');
const { promisePool } = require('../config/database');
const { authenticateToken } = require('../middleware/auth');

const router = express.Router();

// 获取所有便签
router.get('/', authenticateToken, async (req, res) => {
    const userId = req.userId;
    
    try {
        const [notes] = await promisePool.execute(
            'SELECT * FROM notes WHERE user_id = ? ORDER BY update_time DESC, create_time DESC',
            [userId]
        );
        res.json({ success: true, notes });
    } catch (error) {
        console.error('查询便签错误:', error);
        res.status(500).json({ success: false, message: '数据库错误' });
    }
});

// 添加便签
router.post('/', authenticateToken, async (req, res) => {
    const userId = req.userId;
    const { title, content } = req.body;
    
    if (!title) {
        return res.status(400).json({ success: false, message: '标题不能为空' });
    }
    
    try {
        const [result] = await promisePool.execute(
            'INSERT INTO notes (user_id, title, content, create_time, update_time) VALUES (?, ?, ?, NOW(), NOW())',
            [userId, title, content || '']
        );
        
        res.json({ success: true, message: '添加成功', noteId: result.insertId });
    } catch (error) {
        console.error('添加便签错误:', error);
        res.status(500).json({ success: false, message: '添加失败' });
    }
});

// 更新便签
router.put('/:id', authenticateToken, async (req, res) => {
    const userId = req.userId;
    const noteId = req.params.id;
    const { title, content } = req.body;
    
    if (!title) {
        return res.status(400).json({ success: false, message: '标题不能为空' });
    }
    
    try {
        const [result] = await promisePool.execute(
            'UPDATE notes SET title = ?, content = ?, update_time = NOW() WHERE id = ? AND user_id = ?',
            [title, content || '', noteId, userId]
        );
        
        if (result.affectedRows === 0) {
            return res.status(404).json({ success: false, message: '便签不存在' });
        }
        
        res.json({ success: true, message: '更新成功' });
    } catch (error) {
        console.error('更新便签错误:', error);
        res.status(500).json({ success: false, message: '更新失败' });
    }
});

// 删除便签
router.delete('/:id', authenticateToken, async (req, res) => {
    const userId = req.userId;
    const noteId = req.params.id;
    
    try {
        const [result] = await promisePool.execute(
            'DELETE FROM notes WHERE id = ? AND user_id = ?',
            [noteId, userId]
        );
        
        if (result.affectedRows === 0) {
            return res.status(404).json({ success: false, message: '便签不存在' });
        }
        
        res.json({ success: true, message: '删除成功' });
    } catch (error) {
        console.error('删除便签错误:', error);
        res.status(500).json({ success: false, message: '删除失败' });
    }
});

module.exports = router;