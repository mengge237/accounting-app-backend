const express = require('express');
const { promisePool } = require('../config/database');
const { authenticateToken } = require('../middleware/auth');

const router = express.Router();

// 获取用户的所有账本
router.get('/', authenticateToken, async (req, res) => {
    const userId = req.userId;
    
    try {
        const [ledgers] = await promisePool.execute(`
            SELECT id, user_id, name, icon, color, is_default, created_at, updated_at
            FROM ledger_books
            WHERE user_id = ?
            ORDER BY is_default DESC, created_at ASC
        `, [userId]);
        
        res.json({ success: true, ledgers });
    } catch (error) {
        console.error('查询账本错误:', error);
        res.status(500).json({ success: false, message: '数据库错误' });
    }
});

// 获取默认账本
router.get('/default', authenticateToken, async (req, res) => {
    const userId = req.userId;
    
    try {
        const [ledgers] = await promisePool.execute(`
            SELECT id, user_id, name, icon, color, is_default, created_at, updated_at
            FROM ledger_books
            WHERE user_id = ? AND is_default = 1
            LIMIT 1
        `, [userId]);
        
        if (ledgers.length === 0) {
            const [result] = await promisePool.execute(`
                INSERT INTO ledger_books (user_id, name, icon, color, is_default)
                VALUES (?, '默认账本', '', '#4CAF50', 1)
            `, [userId]);
            
            const [newLedger] = await promisePool.execute(`
                SELECT id, user_id, name, icon, color, is_default, created_at, updated_at
                FROM ledger_books
                WHERE id = ?
            `, [result.insertId]);
            
            return res.json({ success: true, ledger: newLedger[0] });
        }
        
        res.json({ success: true, ledger: ledgers[0] });
    } catch (error) {
        console.error('获取默认账本错误:', error);
        res.status(500).json({ success: false, message: '数据库错误' });
    }
});

// 创建新账本
router.post('/', authenticateToken, async (req, res) => {
    const userId = req.userId;
    const { name, color } = req.body;
    
    if (!name || name.trim() === '') {
        return res.status(400).json({ success: false, message: '账本名称不能为空' });
    }
    
    const finalColor = (color && color.trim() !== '') ? color.trim() : '#4CAF50';
    
    try {
        const [countResult] = await promisePool.execute(
            'SELECT COUNT(*) as count FROM ledger_books WHERE user_id = ?',
            [userId]
        );
        
        if (countResult[0].count >= 10) {
            return res.status(400).json({ success: false, message: '账本数量已达上限（最多10个）' });
        }
        
        const [existingLedgers] = await promisePool.execute(
            'SELECT COUNT(*) as count FROM ledger_books WHERE user_id = ?',
            [userId]
        );
        
        const isDefault = existingLedgers[0].count === 0 ? 1 : 0;
        
        const [result] = await promisePool.execute(`
            INSERT INTO ledger_books (user_id, name, icon, color, is_default)
            VALUES (?, ?, '', ?, ?)
        `, [userId, name.trim(), finalColor, isDefault]);
        
        const [newLedger] = await promisePool.execute(`
            SELECT id, user_id, name, icon, color, is_default, created_at, updated_at
            FROM ledger_books
            WHERE id = ?
        `, [result.insertId]);
        
        res.json({ success: true, message: '账本创建成功', ledger: newLedger[0] });
    } catch (error) {
        console.error('创建账本错误:', error);
        res.status(500).json({ success: false, message: '创建失败: ' + error.message });
    }
});

// 更新账本信息
router.put('/:id', authenticateToken, async (req, res) => {
    const userId = req.userId;
    const ledgerId = req.params.id;
    const { name, color } = req.body;
    
    try {
        const [ledgers] = await promisePool.execute(`
            SELECT * FROM ledger_books WHERE id = ? AND user_id = ?
        `, [ledgerId, userId]);
        
        if (ledgers.length === 0) {
            return res.status(404).json({ success: false, message: '账本不存在或无权访问' });
        }
        
        const updates = [];
        const values = [];
        
        if (name && name.trim() !== '') {
            updates.push('name = ?');
            values.push(name.trim());
        }
        if (color && color.trim() !== '') {
            updates.push('color = ?');
            values.push(color.trim());
        }
        
        if (updates.length === 0) {
            return res.status(400).json({ success: false, message: '没有要更新的字段' });
        }
        
        values.push(ledgerId, userId);
        
        await promisePool.execute(`
            UPDATE ledger_books SET ${updates.join(', ')} WHERE id = ? AND user_id = ?
        `, values);
        
        const [updatedLedger] = await promisePool.execute(`
            SELECT id, user_id, name, icon, color, is_default, created_at, updated_at
            FROM ledger_books
            WHERE id = ?
        `, [ledgerId]);
        
        res.json({ success: true, message: '账本更新成功', ledger: updatedLedger[0] });
    } catch (error) {
        console.error('更新账本错误:', error);
        res.status(500).json({ success: false, message: '更新失败' });
    }
});

// 删除账本
router.delete('/:id', authenticateToken, async (req, res) => {
    const userId = req.userId;
    const ledgerId = req.params.id;
    
    try {
        const [ledgers] = await promisePool.execute(`
            SELECT * FROM ledger_books WHERE id = ? AND user_id = ?
        `, [ledgerId, userId]);
        
        if (ledgers.length === 0) {
            return res.status(404).json({ success: false, message: '账本不存在或无权访问' });
        }
        
        if (ledgers[0].is_default === 1) {
            return res.status(400).json({ success: false, message: '默认账本不能删除' });
        }
        
        const connection = await promisePool.getConnection();
        await connection.beginTransaction();
        
        try {
            await connection.execute(
                'DELETE FROM account_records WHERE user_id = ? AND ledger_id = ?',
                [userId, ledgerId]
            );
            
            await connection.execute(
                'DELETE FROM ledger_books WHERE id = ? AND user_id = ?',
                [ledgerId, userId]
            );
            
            await connection.commit();
            connection.release();
            
            res.json({ success: true, message: '账本删除成功' });
        } catch (err) {
            await connection.rollback();
            connection.release();
            throw err;
        }
    } catch (error) {
        console.error('删除账本错误:', error);
        res.status(500).json({ success: false, message: '删除失败' });
    }
});

module.exports = router;