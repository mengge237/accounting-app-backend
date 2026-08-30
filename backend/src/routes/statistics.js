const express = require('express');
const { promisePool } = require('../config/database');
const { authenticateToken } = require('../middleware/auth');

const router = express.Router();

// 获取收支统计（修改：支持按账本筛选）
router.get('/', authenticateToken, async (req, res) => {
    const userId = req.userId;
    const { start_date, end_date, ledger_id } = req.query;
    
    try {
        let sql = `
            SELECT 
                COALESCE(SUM(CASE WHEN at.category = 'income' THEN ar.amount ELSE 0 END), 0) as total_income,
                COALESCE(SUM(CASE WHEN at.category = 'expense' THEN ar.amount ELSE 0 END), 0) as total_expense,
                COUNT(CASE WHEN at.category = 'income' THEN 1 END) as income_count,
                COUNT(CASE WHEN at.category = 'expense' THEN 1 END) as expense_count
            FROM account_records ar
            LEFT JOIN account_types at ON ar.type_id = at.id
            WHERE ar.user_id = ?
        `;
        const params = [userId];
        
        // 按账本筛选
        if (ledger_id) {
            sql += ` AND ar.ledger_id = ?`;
            params.push(ledger_id);
        }
        
        if (start_date && end_date) {
            sql += ` AND DATE(ar.record_date) BETWEEN ? AND ?`;
            params.push(start_date, end_date);
        }
        
        const [results] = await promisePool.execute(sql, params);
        res.json({ success: true, statistics: results[0] });
    } catch (error) {
        console.error('查询统计错误:', error);
        res.status(500).json({ success: false, message: '数据库错误' });
    }
});

// 获取月度统计（修改：支持按账本筛选）
router.get('/monthly', authenticateToken, async (req, res) => {
    const userId = req.userId;
    const { year, ledger_id } = req.query;
    
    if (!year) {
        return res.status(400).json({ success: false, message: '请提供年份参数' });
    }
    
    try {
        let sql = `
            SELECT 
                MONTH(ar.record_date) as month,
                COALESCE(SUM(CASE WHEN at.category = 'income' THEN ar.amount ELSE 0 END), 0) as total_income,
                COALESCE(SUM(CASE WHEN at.category = 'expense' THEN ar.amount ELSE 0 END), 0) as total_expense
            FROM account_records ar
            LEFT JOIN account_types at ON ar.type_id = at.id
            WHERE ar.user_id = ? AND YEAR(ar.record_date) = ?
        `;
        const params = [userId, year];
        
        // 按账本筛选
        if (ledger_id) {
            sql += ` AND ar.ledger_id = ?`;
            params.push(ledger_id);
        }
        
        sql += ` GROUP BY MONTH(ar.record_date) ORDER BY month`;
        
        const [results] = await promisePool.execute(sql, params);
        
        // 初始化12个月的数据（如果没有记录的月份返回0）
        const monthlyData = Array(12).fill().map((_, i) => ({
            month: i + 1,
            total_income: 0,
            total_expense: 0
        }));
        
        results.forEach(row => {
            monthlyData[row.month - 1] = {
                month: row.month,
                total_income: parseFloat(row.total_income) || 0,
                total_expense: parseFloat(row.total_expense) || 0
            };
        });
        
        res.json({ success: true, monthly_stats: monthlyData });
    } catch (error) {
        console.error('查询月度统计错误:', error);
        res.status(500).json({ success: false, message: '数据库错误' });
    }
});

// 获取分类统计（修改：支持按账本筛选）
router.get('/categories', authenticateToken, async (req, res) => {
    const userId = req.userId;
    const { start_date, end_date, category, ledger_id } = req.query;
    
    try {
        // 首先获取所有分类
        let sql = `
            SELECT 
                at.id,
                at.type_name,
                at.category,
                at.icon,
                at.is_default,
                COALESCE(SUM(ar.amount), 0) as total_amount,
                COUNT(ar.id) as record_count
            FROM account_types at
            LEFT JOIN account_records ar ON ar.type_id = at.id AND ar.user_id = ?
        `;
        let params = [userId];
        
        // 添加账本筛选
        if (ledger_id) {
            sql += ` AND ar.ledger_id = ?`;
            params.push(ledger_id);
        }
        
        // 添加日期筛选
        if (start_date && end_date) {
            sql += ` AND DATE(ar.record_date) BETWEEN ? AND ?`;
            params.push(start_date, end_date);
        }
        
        // 筛选收入或支出
        const categoryType = category || 'expense';
        sql += ` WHERE at.user_id IN (0, ?) AND at.category = ?`;
        params.push(userId, categoryType);
        
        sql += ` GROUP BY at.id, at.type_name, at.category, at.icon, at.is_default
                 ORDER BY total_amount DESC`;
        
        const [results] = await promisePool.execute(sql, params);
        
        // 格式化返回数据
        const categories = results.map(row => ({
            id: row.id,
            type_name: row.type_name,
            category: row.category,
            icon: row.icon,
            is_default: row.is_default === 1,
            total_amount: parseFloat(row.total_amount) || 0,
            record_count: row.record_count || 0
        }));
        
        res.json({ success: true, categories: categories });
    } catch (error) {
        console.error('查询分类统计错误:', error);
        res.status(500).json({ success: false, message: '数据库错误: ' + error.message });
    }
});

// 获取所有分类类型（不需要修改，分类与账本无关）
router.get('/types', authenticateToken, async (req, res) => {
    const userId = req.userId;
    
    try {
        const [results] = await promisePool.execute(`
            SELECT 
                id,
                type_name,
                category,
                icon,
                is_default
            FROM account_types
            WHERE user_id IN (0, ?)
            ORDER BY 
                CASE 
                    WHEN category = 'income' THEN 1 
                    WHEN category = 'expense' THEN 2 
                END,
                id
        `, [userId]);
        
        const types = results.map(row => ({
            id: row.id,
            type_name: row.type_name,
            category: row.category,
            icon: row.icon,
            is_default: row.is_default === 1
        }));
        
        res.json({ success: true, types: types });
    } catch (error) {
        console.error('查询分类类型错误:', error);
        res.status(500).json({ success: false, message: '数据库错误' });
    }
});

// 新增：获取账本列表的统计摘要
router.get('/ledgers-summary', authenticateToken, async (req, res) => {
    const userId = req.userId;
    
    try {
        const [results] = await promisePool.execute(`
            SELECT 
                lb.id,
                lb.name,
                lb.icon,
                lb.color,
                lb.is_default,
                COALESCE(SUM(CASE WHEN at.category = 'income' THEN ar.amount ELSE 0 END), 0) as total_income,
                COALESCE(SUM(CASE WHEN at.category = 'expense' THEN ar.amount ELSE 0 END), 0) as total_expense,
                COUNT(ar.id) as record_count
            FROM ledger_books lb
            LEFT JOIN account_records ar ON ar.ledger_id = lb.id AND ar.user_id = lb.user_id
            LEFT JOIN account_types at ON ar.type_id = at.id
            WHERE lb.user_id = ?
            GROUP BY lb.id, lb.name, lb.icon, lb.color, lb.is_default
            ORDER BY lb.is_default DESC, lb.created_at ASC
        `, [userId]);
        
        const summary = results.map(row => ({
            id: row.id,
            name: row.name,
            icon: row.icon,
            color: row.color,
            is_default: row.is_default === 1,
            total_income: parseFloat(row.total_income) || 0,
            total_expense: parseFloat(row.total_expense) || 0,
            record_count: row.record_count || 0,
            balance: parseFloat(row.total_income) - parseFloat(row.total_expense)
        }));
        
        res.json({ success: true, ledgers: summary });
    } catch (error) {
        console.error('查询账本统计摘要错误:', error);
        res.status(500).json({ success: false, message: '数据库错误' });
    }
});

module.exports = router;