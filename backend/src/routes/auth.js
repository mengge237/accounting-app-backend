const express = require('express');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { promisePool } = require('../config/database');  // 改为 promisePool
const { authenticateToken } = require('../middleware/auth');
require('dotenv').config();

const router = express.Router();

// 注册
router.post('/register', async (req, res) => {
    const { username, password, email } = req.body;
    
    if (!username || !password) {
        return res.status(400).json({ success: false, message: '用户名和密码不能为空' });
    }
    
    if (username.length < 3) {
        return res.status(400).json({ success: false, message: '用户名长度不能少于3位' });
    }
    
    if (password.length < 6) {
        return res.status(400).json({ success: false, message: '密码长度不能少于6位' });
    }
    
    try {
        const [rows] = await promisePool.execute('SELECT id FROM users WHERE username = ?', [username]);
        
        if (rows.length > 0) {
            return res.status(400).json({ success: false, message: '用户名已存在' });
        }
        
        const hashedPassword = await bcrypt.hash(password, 10);
        const [result] = await promisePool.execute(
            'INSERT INTO users (username, password, email) VALUES (?, ?, ?)',
            [username, hashedPassword, email || null]
        );
        
        res.json({ success: true, message: '注册成功', userId: result.insertId });
    } catch (error) {
        console.error('注册错误:', error);
        res.status(500).json({ success: false, message: '服务器内部错误' });
    }
});

// 登录
router.post('/login', async (req, res) => {
    const { username, password } = req.body;
    
    if (!username || !password) {
        return res.status(400).json({ success: false, message: '用户名和密码不能为空' });
    }
    
    try {
        const [rows] = await promisePool.execute('SELECT id, username, password FROM users WHERE username = ?', [username]);
        
        if (rows.length === 0) {
            return res.status(401).json({ success: false, message: '用户名不存在' });
        }
        
        const user = rows[0];
        const isValid = await bcrypt.compare(password, user.password);
        
        if (!isValid) {
            return res.status(401).json({ success: false, message: '密码错误' });
        }
        
        const token = jwt.sign(
            { userId: user.id, username: user.username },
            process.env.JWT_SECRET || 'your_secret_key',
            { expiresIn: '7d' }
        );
        
        res.json({ success: true, message: '登录成功', token, user: { id: user.id, username: user.username } });
    } catch (error) {
        console.error('登录错误:', error);
        res.status(500).json({ success: false, message: '服务器内部错误' });
    }
});

// 检查用户名是否存在
router.get('/check-username', async (req, res) => {
    const { username } = req.query;
    if (!username) return res.json({ exists: false });
    
    try {
        const [rows] = await promisePool.execute('SELECT COUNT(*) as count FROM users WHERE username = ?', [username]);
        res.json({ exists: rows[0].count > 0 });
    } catch (error) {
        res.status(500).json({ exists: false });
    }
});

// 重置密码
router.post('/reset-password', async (req, res) => {
    const { username, new_password } = req.body;
    
    if (!username || !new_password) {
        return res.status(400).json({ success: false, message: '用户名和新密码不能为空' });
    }
    
    if (new_password.length < 6) {
        return res.status(400).json({ success: false, message: '新密码长度不能少于6位' });
    }
    
    try {
        const [rows] = await promisePool.execute('SELECT id FROM users WHERE username = ?', [username]);
        
        if (rows.length === 0) {
            return res.status(404).json({ success: false, message: '用户不存在' });
        }
        
        const hashedPassword = await bcrypt.hash(new_password, 10);
        await promisePool.execute('UPDATE users SET password = ? WHERE username = ?', [hashedPassword, username]);
        
        res.json({ success: true, message: '密码重置成功' });
    } catch (error) {
        console.error('重置密码错误:', error);
        res.status(500).json({ success: false, message: '服务器内部错误' });
    }
});

// 获取用户信息
router.get('/user/info', authenticateToken, async (req, res) => {
    try {
        const [rows] = await promisePool.execute(
            'SELECT id, username, email, avatar, created_at, updated_at FROM users WHERE id = ?',
            [req.userId]
        );
        
        if (rows.length === 0) {
            return res.status(404).json({ success: false, message: '用户不存在' });
        }
        
        res.json({ success: true, user: rows[0] });
    } catch (error) {
        console.error('获取用户信息错误:', error);
        res.status(500).json({ success: false, message: '服务器内部错误' });
    }
});

module.exports = router;