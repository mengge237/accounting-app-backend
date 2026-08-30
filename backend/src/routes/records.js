const express = require('express');
const { promisePool } = require('../config/database');
const { authenticateToken } = require('../middleware/auth');

const router = express.Router();

// 获取账目类型列表（保持不变）
router.get('/types', authenticateToken, async (req, res) => {
    const userId = req.userId;
    
    try {
        const [types] = await promisePool.execute(`
            SELECT id, user_id, type_name, category, icon, is_default 
            FROM account_types 
            WHERE user_id = 0 OR user_id = ?
            ORDER BY category, id
        `, [userId]);
        
        res.json({ success: true, types });
    } catch (error) {
        console.error('查询类型错误:', error);
        res.status(500).json({ success: false, message: '数据库错误' });
    }
});

// 添加自定义账目类型（保持不变）
router.post('/types', authenticateToken, async (req, res) => {
    const userId = req.userId;
    const { type_name, category, icon } = req.body;
    
    if (!type_name || !category) {
        return res.status(400).json({ success: false, message: '类型名称和分类不能为空' });
    }
    
    try {
        const [result] = await promisePool.execute(
            'INSERT INTO account_types (user_id, type_name, category, icon, is_default) VALUES (?, ?, ?, ?, 0)',
            [userId, type_name, category, icon || null]
        );
        
        res.json({ success: true, message: '添加成功', typeId: result.insertId });
    } catch (error) {
        console.error('添加类型错误:', error);
        res.status(500).json({ success: false, message: '添加失败' });
    }
});

// 删除自定义账目类型（保持不变）
router.delete('/types/:id', authenticateToken, async (req, res) => {
    const userId = req.userId;
    const typeId = req.params.id;
    
    try {
        const [result] = await promisePool.execute(
            'DELETE FROM account_types WHERE id = ? AND user_id = ? AND is_default = 0',
            [typeId, userId]
        );
        
        if (result.affectedRows === 0) {
            return res.status(404).json({ success: false, message: '类型不存在或无权删除' });
        }
        
        res.json({ success: true, message: '删除成功' });
    } catch (error) {
        console.error('删除类型错误:', error);
        res.status(500).json({ success: false, message: '删除失败' });
    }
});

// 获取所有记账记录（修改：支持按账本筛选）
router.get('/', authenticateToken, async (req, res) => {
    const userId = req.userId;
    const ledgerId = req.query.ledger_id;
    
    let sql = `
        SELECT ar.id, ar.user_id, ar.type_id, ar.amount, ar.note, ar.record_date, ar.created_at, ar.ledger_id,
               at.type_name, at.category, at.icon,
               lb.name as ledger_name, lb.icon as ledger_icon, lb.color as ledger_color
        FROM account_records ar
        LEFT JOIN account_types at ON ar.type_id = at.id
        LEFT JOIN ledger_books lb ON ar.ledger_id = lb.id
        WHERE ar.user_id = ?
    `;
    const params = [userId];
    
    if (ledgerId) {
        sql += ` AND ar.ledger_id = ?`;
        params.push(ledgerId);
    }
    
    sql += ` ORDER BY ar.record_date DESC, ar.created_at DESC`;
    
    try {
        const [records] = await promisePool.execute(sql, params);
        res.json({ success: true, records });
    } catch (error) {
        console.error('查询记录错误:', error);
        res.status(500).json({ success: false, message: '数据库错误' });
    }
});

// 添加记账记录（修改：支持账本ID）
router.post('/', authenticateToken, async (req, res) => {
    const userId = req.userId;
    const { type_id, amount, note, record_date, ledger_id } = req.body;
    
    if (!type_id || !amount || !record_date) {
        return res.status(400).json({ success: false, message: '类型、金额和日期不能为空' });
    }
    
    if (amount <= 0) {
        return res.status(400).json({ success: false, message: '金额必须大于0' });
    }
    
    // 如果没有指定账本，使用默认账本
    let targetLedgerId = ledger_id;
    if (!targetLedgerId) {
        const [defaultLedger] = await promisePool.execute(`
            SELECT id FROM ledger_books WHERE user_id = ? AND is_default = 1 LIMIT 1
        `, [userId]);
        
        if (defaultLedger.length > 0) {
            targetLedgerId = defaultLedger[0].id;
        } else {
            // 如果没有默认账本，创建一个
            const [result] = await promisePool.execute(`
                INSERT INTO ledger_books (user_id, name, icon, color, is_default)
                VALUES (?, '默认账本', 'book', '#4CAF50', 1)
            `, [userId]);
            targetLedgerId = result.insertId;
        }
    }
    
    try {
        const [result] = await promisePool.execute(`
            INSERT INTO account_records (user_id, type_id, amount, note, record_date, ledger_id)
            VALUES (?, ?, ?, ?, ?, ?)
        `, [userId, type_id, amount, note || null, record_date, targetLedgerId]);
        
        res.json({ success: true, message: '添加成功', recordId: result.insertId });
    } catch (error) {
        console.error('添加记录错误:', error);
        res.status(500).json({ success: false, message: '添加失败' });
    }
});

// 更新记账记录
router.put('/:id', authenticateToken, async (req, res) => {
    const userId = req.userId;
    const recordId = req.params.id;
    const { type_id, amount, note, record_date } = req.body;
    
    try {
        const [result] = await promisePool.execute(`
            UPDATE account_records 
            SET type_id = ?, amount = ?, note = ?, record_date = ?
            WHERE id = ? AND user_id = ?
        `, [type_id, amount, note || null, record_date, recordId, userId]);
        
        if (result.affectedRows === 0) {
            return res.status(404).json({ success: false, message: '记录不存在或无权访问' });
        }
        
        res.json({ success: true, message: '更新成功' });
    } catch (error) {
        console.error('更新记录错误:', error);
        res.status(500).json({ success: false, message: '更新失败' });
    }
});

// 删除记账记录
router.delete('/:id', authenticateToken, async (req, res) => {
    const userId = req.userId;
    const recordId = req.params.id;
    
    try {
        const [result] = await promisePool.execute(
            'DELETE FROM account_records WHERE id = ? AND user_id = ?',
            [recordId, userId]
        );
        
        if (result.affectedRows === 0) {
            return res.status(404).json({ success: false, message: '记录不存在或无权访问' });
        }
        
        res.json({ success: true, message: '删除成功' });
    } catch (error) {
        console.error('删除记录错误:', error);
        res.status(500).json({ success: false, message: '删除失败' });
    }
});

module.exports = router;